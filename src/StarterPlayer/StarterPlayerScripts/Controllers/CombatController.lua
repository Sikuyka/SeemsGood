--!strict
--[[ CombatController.lua — input & combat remotes. docs/modules/CombatController.md ]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Packets = require(ReplicatedStorage.Shared.Net.Packets)
local AnimationStubs = require(ReplicatedStorage.Assets.AnimationStubs)

local CombatController = {}
local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild(Packets.FolderName)
local combatRemote = remotes:WaitForChild(Packets.Events.CombatAction) :: RemoteEvent
local combo = 0

local function getTarget(): Instance?
	local mouse = player:GetMouse()
	if mouse and mouse.Target then
		return mouse.Target
	end
	return nil
end

local function playAnim(key: string)
	local char = player.Character
	if not char then
		return
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then
		return
	end
	local id = AnimationStubs[key]
	if id and id ~= "rbxassetid://0" then
		local anim = Instance.new("Animation")
		anim.AnimationId = id
		local track = hum:LoadAnimation(anim)
		track:Play()
	end
end

function CombatController.SendLight()
	local target = getTarget()
	if not target then
		return
	end
	combo = (combo % 4) + 1
	playAnim("Light" .. math.min(combo, 3))
	combatRemote:FireServer("Light", target)
end

function CombatController.SendHeavy()
	local target = getTarget()
	if not target then
		return
	end
	combo = 0
	playAnim("Heavy")
	combatRemote:FireServer("Heavy", target)
end

function CombatController.SendAbility(abilityId: string)
	local target = getTarget()
	if not target then
		return
	end
	playAnim("Skill1")
	combatRemote:FireServer("Ability", target, abilityId)
end

function CombatController.Start()
	UserInputService.InputBegan:Connect(function(input, processed)
		if processed then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			CombatController.SendLight()
		elseif input.KeyCode == Enum.KeyCode.R then
			CombatController.SendHeavy()
		elseif input.KeyCode == Enum.KeyCode.One then
			CombatController.SendAbility("punch_combo")
		elseif input.KeyCode == Enum.KeyCode.Two then
			CombatController.SendAbility("power_slam")
		elseif input.KeyCode == Enum.KeyCode.Three then
			CombatController.SendAbility("energy_burst")
		elseif input.KeyCode == Enum.KeyCode.Four then
			CombatController.SendAbility("ultimate_strike")
		end
	end)

	remotes:WaitForChild(Packets.Events.CombatHit).OnClientEvent:Connect(function()
		combo = math.min(combo + 1, 4)
	end)
end

return CombatController
