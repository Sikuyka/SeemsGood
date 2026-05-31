--!strict
--[[ CombatService.lua — server-authoritative combat. docs/modules/CombatService.md ]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local AbilityRegistry = require(ReplicatedStorage.Config.Abilities.AbilityRegistry)
local Constants = require(ReplicatedStorage.Shared.Constants)
local HeroService = require(script.Parent.HeroService)
local QuestService = require(script.Parent.QuestService)
local RemoteSetup = require(script.Parent.RemoteSetup)

local CombatService = {}

local lastAction: { [Player]: number } = {}
local comboIndex: { [Player]: number } = {}
local cooldowns: { [Player]: { [string]: number } } = {}

local COMBO_MAX = 4
local LIGHT_DAMAGE_MULT = { 1, 1.1, 1.2, 1.5 }
local HEAVY_DAMAGE_MULT = 2.2

local function getHumanoid(target: Instance): Humanoid?
	if target:IsA("Humanoid") then
		return target
	end
	local model = target:FindFirstAncestorOfClass("Model")
	if model then
		return model:FindFirstChildOfClass("Humanoid")
	end
	return nil
end

local function applyDamage(attacker: Player, targetHumanoid: Humanoid, rawDamage: number, knockback: number, stun: number)
	local stats = HeroService.GetEquippedStats(attacker)
	if not stats then
		return
	end

	local damage = math.max(1, rawDamage - (targetHumanoid:GetAttribute("Defense") or 0) * 0.5)
		local tag = targetHumanoid:FindFirstChild("creator")
	if not tag then
		tag = Instance.new("ObjectValue")
		tag.Name = "creator"
		tag.Parent = targetHumanoid
	end
	tag.Value = attacker

	targetHumanoid:TakeDamage(damage)

	local root = targetHumanoid.Parent and targetHumanoid.Parent:FindFirstChild("HumanoidRootPart") :: BasePart?
	local attackerChar = attacker.Character
	local attackerRoot = attackerChar and attackerChar:FindFirstChild("HumanoidRootPart") :: BasePart?

	if root and attackerRoot and knockback > 0 then
		local dir = (root.Position - attackerRoot.Position).Unit
		root.AssemblyLinearVelocity = dir * knockback * 8 + Vector3.new(0, knockback * 2, 0)
		RemoteSetup.GetEvent("ApplyKnockback"):FireAllClients(root, dir, knockback)
	end

	if stun > 0 then
		targetHumanoid.WalkSpeed = 0
		RemoteSetup.GetEvent("ApplyStun"):FireAllClients(targetHumanoid, stun)
		task.delay(stun, function()
			if targetHumanoid.Parent then
				targetHumanoid.WalkSpeed = targetHumanoid:GetAttribute("BaseWalkSpeed") or 16
			end
		end)
	end

	RemoteSetup.GetEvent("CombatHit"):FireAllClients(attacker.UserId, targetHumanoid.Parent, damage)
end

local function rateOk(player: Player, key: string, limit: number): boolean
	local t = os.clock()
	if lastAction[player] and t - lastAction[player] < limit then
		return false
	end
	lastAction[player] = t
	return true
end

local function validateDistance(player: Player, target: Instance): boolean
	local char = player.Character
	if not char then
		return false
	end
	local root = char:FindFirstChild("HumanoidRootPart") :: BasePart?
	local targetRoot = target:FindFirstAncestorOfClass("Model")
		and target:FindFirstAncestorOfClass("Model"):FindFirstChild("HumanoidRootPart") :: BasePart?
	if not root or not targetRoot then
		return false
	end
	return (root.Position - targetRoot.Position).Magnitude <= 20
end

function CombatService.HandleAction(player: Player, actionType: string, targetInstance: Instance?)
	if type(actionType) ~= "string" then
		return
	end
	if not rateOk(player, actionType, Constants.REMOTE_RATE_LIMIT.CombatAction) then
		return
	end

	local stats = HeroService.GetEquippedStats(player)
	if not stats or not targetInstance then
		return
	end
	if not validateDistance(player, targetInstance) then
		return
	end

	local hum = getHumanoid(targetInstance)
	if not hum or hum.Health <= 0 then
		return
	end

	if actionType == "Light" then
		comboIndex[player] = (comboIndex[player] or 0) % COMBO_MAX + 1
		local mult = LIGHT_DAMAGE_MULT[comboIndex[player]]
		applyDamage(player, hum, stats.Damage * mult, 2, 0)
	elseif actionType == "Heavy" then
		comboIndex[player] = 0
		applyDamage(player, hum, stats.Damage * HEAVY_DAMAGE_MULT, 10, 0.2)
	elseif actionType == "ResetCombo" then
		comboIndex[player] = 0
	end
end

function CombatService.HandleAbility(player: Player, abilityId: string, targetInstance: Instance?)
	if type(abilityId) ~= "string" then
		return
	end
	if not rateOk(player, abilityId, Constants.REMOTE_RATE_LIMIT.UseAbility) then
		return
	end

	local ability = AbilityRegistry.Get(abilityId)
	if not ability then
		return
	end

	local data = require(script.Parent.PlayerDataService).GetProfile(player)
	if not data or not data.EquippedHeroId then
		return
	end
	local hero = data.OwnedHeroes[data.EquippedHeroId]
	if not hero then
		return
	end

	local unlocked = false
	for _, id in hero.UnlockedAbilities do
		if id == abilityId then
			unlocked = true
			break
		end
	end
	if not unlocked then
		return
	end

	cooldowns[player] = cooldowns[player] or {}
	local now = os.clock()
	if cooldowns[player][abilityId] and now < cooldowns[player][abilityId] then
		return
	end
	cooldowns[player][abilityId] = now + ability.Cooldown

	if targetInstance then
		local hum = getHumanoid(targetInstance)
		if hum and validateDistance(player, targetInstance) then
			applyDamage(player, hum, ability.Damage, ability.Knockback, ability.StunDuration)
		end
	end

	QuestService.Track(player, "UseAbility", 1)
	RemoteSetup.GetEvent("AbilityUsed"):FireAllClients(player.UserId, abilityId)
end

function CombatService.Start()
	local combatRemote = RemoteSetup.GetEvent("CombatAction")
	combatRemote.OnServerEvent:Connect(function(player, actionType, target, abilityId)
		if actionType == "Ability" and type(abilityId) == "string" and typeof(target) == "Instance" then
			CombatService.HandleAbility(player, abilityId, target)
		elseif typeof(target) == "Instance" and type(actionType) == "string" then
			CombatService.HandleAction(player, actionType, target)
		end
	end)
end

return CombatService
