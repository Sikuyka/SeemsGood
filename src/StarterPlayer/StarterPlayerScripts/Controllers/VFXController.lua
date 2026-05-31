--!strict
--[[ VFXController.lua — listens for combat VFX events. docs/modules/VFXController.md ]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packets = require(ReplicatedStorage.Shared.Net.Packets)
local VFXStubs = require(ReplicatedStorage.Assets.VFXStubs)

local VFXController = {}
local remotes = ReplicatedStorage:WaitForChild(Packets.FolderName)

function VFXController.Start()
	remotes:WaitForChild(Packets.Events.CombatHit).OnClientEvent:Connect(function(_userId, targetModel, _damage)
		if targetModel and targetModel:FindFirstChild("HumanoidRootPart") then
			VFXStubs.Spawn("HitSpark", targetModel.HumanoidRootPart.Position)
		end
	end)

	remotes:WaitForChild(Packets.Events.AbilityUsed).OnClientEvent:Connect(function(_userId, abilityId)
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			VFXStubs.Spawn(abilityId, char.HumanoidRootPart.Position + Vector3.new(0, 2, 0))
		end
	end)
end

return VFXController
