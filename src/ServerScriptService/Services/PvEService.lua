--!strict
--[[ PvEService.lua — NPC bandits spawn & rewards. docs/modules/PvEService.md ]]

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local NPCRegistry = require(ReplicatedStorage.Config.NPCs.NPCRegistry)
local EconomyService = require(script.Parent.EconomyService)
local HeroService = require(script.Parent.HeroService)
local QuestService = require(script.Parent.QuestService)
local PlayerDataService = require(script.Parent.PlayerDataService)
local RemoteSetup = require(script.Parent.RemoteSetup)

local PvEService = {}
local activeNPCs: { [Model]: { Type: string, Health: number } } = {}
local SPAWN_FOLDER_NAME = "PvEZone"

local function createNPC(npcType: string, position: Vector3): Model?
	local def = NPCRegistry[npcType]
	if not def then
		return nil
	end

	local model = Instance.new("Model")
	model.Name = def.DisplayName

	local root = Instance.new("Part")
	root.Name = "HumanoidRootPart"
	root.Size = Vector3.new(2, 2, 1) * def.Scale
	root.Position = position
	root.Anchored = false
	root.CanCollide = true
	root.Parent = model

	local hum = Instance.new("Humanoid")
	hum.MaxHealth = def.Health
	hum.Health = def.Health
	hum.WalkSpeed = def.Speed
	hum:SetAttribute("BaseWalkSpeed", def.Speed)
	hum:SetAttribute("Defense", def.Defense)
	hum:SetAttribute("NPCType", npcType)
	hum.Parent = model

	local head = Instance.new("Part")
	head.Name = "Head"
	head.Size = Vector3.new(1.5, 1.5, 1.5) * def.Scale
	head.Position = position + Vector3.new(0, 2 * def.Scale, 0)
	head.Parent = model

	model.PrimaryPart = root
	model:SetAttribute("Damage", def.Damage)
	model.Parent = Workspace:FindFirstChild(SPAWN_FOLDER_NAME) or Workspace

	activeNPCs[model] = { Type = npcType, Health = def.Health }
	RemoteSetup.GetEvent("PvEEnemySpawned"):FireAllClients(model, npcType)
	return model
end

local function onNPCDied(model: Model, killer: Player?)
	local data = activeNPCs[model]
	if not data then
		return
	end
	activeNPCs[model] = nil

	local def = NPCRegistry[data.Type]
	if killer and def then
		EconomyService.Add(killer, "Coins", def.CoinReward)
		local profile = PlayerDataService.GetProfile(killer)
		if profile and profile.EquippedHeroId then
			HeroService.AddHeroXP(killer, profile.EquippedHeroId, def.XPReward)
		end
		HeroService.AddAccountXP(killer, math.floor(def.XPReward * 0.5))
		QuestService.Track(killer, "KillBandits", 1)
	end

	RemoteSetup.GetEvent("PvEEnemyDied"):FireAllClients(model, killer and killer.UserId or 0)
	task.delay(2, function()
		model:Destroy()
	end)
end

local function hookNPC(model: Model)
	local hum = model:FindFirstChildOfClass("Humanoid")
	if not hum then
		return
	end
	hum.Died:Connect(function()
		local killer: Player? = nil
		local tag = hum:FindFirstChild("creator")
		if tag and tag:IsA("ObjectValue") and tag.Value and tag.Value:IsA("Player") then
			killer = tag.Value
		end
		onNPCDied(model, killer)
	end)
end

function PvEService.SpawnWave()
	local folder = Workspace:FindFirstChild(SPAWN_FOLDER_NAME)
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = SPAWN_FOLDER_NAME
		folder.Parent = Workspace
	end

	local base = folder:FindFirstChild("SpawnCenter") :: BasePart?
	local pos = base and base.Position or Vector3.new(0, 5, 50)

	local types = { "Thug", "Thug", "Thug", "Veteran", "Elite" }
	for i, npcType in types do
		local offset = Vector3.new((i - 3) * 8, 0, math.random(-5, 5))
		local m = createNPC(npcType, pos + offset)
		if m then
			hookNPC(m)
		end
	end

	task.delay(120, function()
		if #folder:GetChildren() < 3 then
			PvEService.SpawnBoss()
		end
	end)
end

function PvEService.SpawnBoss()
	local folder = Workspace:FindFirstChild(SPAWN_FOLDER_NAME)
	local pos = Vector3.new(0, 5, 80)
	if folder and folder:FindFirstChild("BossSpawn") then
		pos = (folder.BossSpawn :: BasePart).Position
	end
	local m = createNPC("Boss", pos)
	if m then
		hookNPC(m)
	end
end

function PvEService.Start()
	local folder = Workspace:FindFirstChild(SPAWN_FOLDER_NAME)
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = SPAWN_FOLDER_NAME
		folder.Parent = Workspace
	end
	if not folder:FindFirstChild("SpawnCenter") then
		local p = Instance.new("Part")
		p.Name = "SpawnCenter"
		p.Anchored = true
		p.Transparency = 1
		p.Size = Vector3.new(4, 1, 4)
		p.Position = Vector3.new(0, 5, 50)
		p.Parent = folder
	end

	task.spawn(function()
		while true do
			PvEService.SpawnWave()
			task.wait(90)
		end
	end)
end

return PvEService
