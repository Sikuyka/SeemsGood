--!strict
--[[
	PlayerDataService.lua
	ProfileService session management.
	docs/modules/PlayerDataService.md
]]

local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ProfileService = require(ServerScriptService.Libraries.ProfileService)
local DefaultProfile = require(ReplicatedStorage.Shared.DefaultProfile)
local RemoteSetup = require(script.Parent.RemoteSetup)

local PlayerDataService = {}
local PROFILE_STORE_NAME = "SeemsGood_PlayerData_v1"
local profiles: { [Player]: any } = {}
local store = ProfileService.GetProfileStore(PROFILE_STORE_NAME, DefaultProfile.Get())

local profileUpdatedEvent: RemoteEvent

function PlayerDataService.Init()
	profileUpdatedEvent = RemoteSetup.GetEvent("ProfileUpdated")
end

function PlayerDataService.GetProfile(player: Player)
	local profile = profiles[player]
	if profile and profile:IsActive() then
		return profile.Data
	end
	return nil
end

function PlayerDataService.GetProfileObject(player: Player)
	return profiles[player]
end

local function replicate(player: Player)
	local data = PlayerDataService.GetProfile(player)
	if data then
		profileUpdatedEvent:FireClient(player, data)
	end
end

function PlayerDataService.Replicate(player: Player)
	replicate(player)
end

function PlayerDataService.Update(player: Player, mutator: (data: any) -> ())
	local profile = profiles[player]
	if not profile or not profile:IsActive() then
		return false
	end
	mutator(profile.Data)
	replicate(player)
	return true
end

local function onPlayerAdded(player: Player)
	local profile = store:LoadProfileAsync("Player_" .. player.UserId, "ForceLoad")
	if not profile then
		player:Kick("Data failed to load. Please rejoin.")
		return
	end

	profile:AddUserId(player.UserId)
	profile:Reconcile()

	profile:ListenToRelease(function()
		profiles[player] = nil
		player:Kick("Session released. Please rejoin.")
	end)

	if player:IsDescendantOf(Players) then
		profiles[player] = profile
		replicate(player)
	else
		profile:Release()
	end
end

local function onPlayerRemoving(player: Player)
	local profile = profiles[player]
	if profile then
		profile:Release()
	end
end

function PlayerDataService.Start()
	PlayerDataService.Init()
	Players.PlayerAdded:Connect(onPlayerAdded)
	Players.PlayerRemoving:Connect(onPlayerRemoving)
	for _, p in Players:GetPlayers() do
		task.spawn(onPlayerAdded, p)
	end

	RemoteSetup.GetFunction("GetProfile").OnServerInvoke = function(player)
		return PlayerDataService.GetProfile(player)
	end
end

return PlayerDataService
