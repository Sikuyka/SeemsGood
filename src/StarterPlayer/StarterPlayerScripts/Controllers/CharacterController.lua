--!strict
--[[ CharacterController.lua — apply equipped hero stats to character. docs/modules/CharacterController.md ]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packets = require(ReplicatedStorage.Shared.Net.Packets)
local HeroStats = require(ReplicatedStorage.Shared.HeroStats)

local CharacterController = {}
local player = Players.LocalPlayer

local function applyToCharacter()
	local data = nil
	pcall(function()
		data = ReplicatedStorage:WaitForChild(Packets.FolderName)
			:WaitForChild(Packets.Functions.GetProfile)
			:InvokeServer()
	end)
	if not data or not data.EquippedHeroId then
		return
	end
	local hero = data.OwnedHeroes[data.EquippedHeroId]
	if not hero then
		return
	end
	local stats = HeroStats.Compute(data.EquippedHeroId, hero.Level)
	local char = player.Character
	if not char then
		return
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.MaxHealth = stats.Health
		hum.Health = stats.Health
		hum.WalkSpeed = stats.Speed
	end
end

function CharacterController.Start()
	player.CharacterAdded:Connect(function()
		task.wait(0.2)
		applyToCharacter()
	end)

	ReplicatedStorage:WaitForChild(Packets.FolderName)
		:WaitForChild(Packets.Events.ProfileUpdated).OnClientEvent:Connect(function()
		applyToCharacter()
	end)
end

return CharacterController
