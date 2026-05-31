--!strict
--[[ PvPService.lua — arena queue & rating. docs/modules/PvPService.md ]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Shared.Constants)
local EconomyService = require(script.Parent.EconomyService)
local HeroService = require(script.Parent.HeroService)
local PlayerDataService = require(script.Parent.PlayerDataService)
local RemoteSetup = require(script.Parent.RemoteSetup)

local PvPService = {}
local queue: { Player } = {}
local inMatch: { [Player]: Player } = {}

local function accountLevel(player: Player): number
	local data = PlayerDataService.GetProfile(player)
	return data and data.AccountLevel or 1
end

local function tryMatch()
	if #queue < 2 then
		return
	end

	table.sort(queue, function(a, b)
		return accountLevel(a) < accountLevel(b)
	end)

	for i = 1, #queue - 1 do
		local p1 = queue[i]
		local p2 = queue[i + 1]
		if math.abs(accountLevel(p1) - accountLevel(p2)) <= 10 then
			table.remove(queue, i + 1)
			table.remove(queue, i)
			PvPService.StartMatch(p1, p2)
			return
		end
	end

	if #queue >= 2 then
		local p1 = table.remove(queue, 1)
		local p2 = table.remove(queue, 1)
		PvPService.StartMatch(p1, p2)
	end
end

function PvPService.StartMatch(p1: Player, p2: Player)
	inMatch[p1] = p2
	inMatch[p2] = p1

	local spawnFolder = workspace:FindFirstChild("PvPArena")
	local s1 = spawnFolder and spawnFolder:FindFirstChild("SpawnA") :: BasePart?
	local s2 = spawnFolder and spawnFolder:FindFirstChild("SpawnB") :: BasePart?

	local function tp(player: Player, part: BasePart?)
		local char = player.Character
		if char and char:FindFirstChild("HumanoidRootPart") and part then
			char.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
		end
	end

	tp(p1, s1)
	tp(p2, s2)

	RemoteSetup.GetEvent("PvPMatchStart"):FireClient(p1, p2.UserId)
	RemoteSetup.GetEvent("PvPMatchStart"):FireClient(p2, p1.UserId)

	local function watch(player: Player, opponent: Player)
		local char = player.Character or player.CharacterAdded:Wait()
		local hum = char:WaitForChild("Humanoid") :: Humanoid
		hum.Died:Once(function()
			PvPService.EndMatch(opponent, player)
		end)
	end

	watch(p1, p2)
	watch(p2, p1)
end

function PvPService.EndMatch(winner: Player, loser: Player)
	inMatch[winner] = nil
	inMatch[loser] = nil

	PlayerDataService.Update(winner, function(data)
		data.Stats.PvPWins += 1
		data.Stats.PvPRating = math.min(3000, data.Stats.PvPRating + 25)
	end)
	PlayerDataService.Update(loser, function(data)
		data.Stats.PvPLosses += 1
		data.Stats.PvPRating = math.max(0, data.Stats.PvPRating - 15)
	end)

	EconomyService.Add(winner, "Coins", 100)
	EconomyService.Add(loser, "Coins", 35)
	HeroService.AddAccountXP(winner, 60)
	HeroService.AddAccountXP(loser, 25)

	RemoteSetup.GetEvent("PvPMatchEnd"):FireClient(winner, true, 100)
	RemoteSetup.GetEvent("PvPMatchEnd"):FireClient(loser, false, 35)
end

function PvPService.Enqueue(player: Player)
	if inMatch[player] then
		return
	end
	for _, p in queue do
		if p == player then
			return
		end
	end
	table.insert(queue, player)
	tryMatch()
end

function PvPService.Start()
	RemoteSetup.GetEvent("PvPQueue").OnServerEvent:Connect(function(player)
		PvPService.Enqueue(player)
	end)

	local arena = workspace:FindFirstChild("PvPArena")
	if not arena then
		arena = Instance.new("Folder")
		arena.Name = "PvPArena"
		arena.Parent = workspace
		for name, pos in { SpawnA = Vector3.new(-40, 5, 0), SpawnB = Vector3.new(40, 5, 0) } do
			local p = Instance.new("Part")
			p.Name = name
			p.Anchored = true
			p.Size = Vector3.new(6, 1, 6)
			p.Position = pos
			p.BrickColor = BrickColor.new("Bright red")
			p.Parent = arena
		end
	end
end

return PvPService
