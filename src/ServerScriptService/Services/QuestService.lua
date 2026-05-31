--!strict
--[[ QuestService.lua — daily quests. docs/modules/QuestService.md ]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local QuestTemplates = require(ReplicatedStorage.Config.Quests.QuestTemplates)
local Constants = require(ReplicatedStorage.Shared.Constants)
local EconomyService = require(script.Parent.EconomyService)
local HeroService = require(script.Parent.HeroService)
local PlayerDataService = require(script.Parent.PlayerDataService)
local RemoteSetup = require(script.Parent.RemoteSetup)
local CaseService -- lazy

local QuestService = {}

local function daySeed(): number
	return math.floor(os.time() / 86400)
end

local function ensureDailyQuests(player: Player)
	local seed = daySeed()
	PlayerDataService.Update(player, function(data)
		if data.Quests.DailySeed ~= seed then
			data.Quests.DailySeed = seed
			data.Quests.Progress = {}
			data.Quests.Claimed = {}
			local picked = {}
			local pool = table.clone(QuestTemplates)
			for i = 1, math.min(Constants.DAILY_QUEST_COUNT, #pool) do
				local idx = math.random(1, #pool)
				local q = table.remove(pool, idx)
				picked[q.Id] = q
				data.Quests.Progress[q.Id] = 0
			end
			data._activeDaily = picked
		end
	end)
end

function QuestService.Track(player: Player, questType: string, amount: number)
	ensureDailyQuests(player)
	PlayerDataService.Update(player, function(data)
		for _, template in QuestTemplates do
			if template.Type == questType then
				local id = template.Id
				if data.Quests.Progress[id] ~= nil and not data.Quests.Claimed[id] then
					data.Quests.Progress[id] = math.min(template.Target, (data.Quests.Progress[id] or 0) + amount)
				end
			end
		end
		if questType == "KillBandits" then
			data.Stats.BanditsKilled += amount
		elseif questType == "UseAbility" then
			data.Stats.AbilitiesUsed += amount
		end
	end)
	RemoteSetup.GetEvent("QuestUpdated"):FireClient(player, PlayerDataService.GetProfile(player))
end

function QuestService.Claim(player: Player, questId: string): boolean
	local template
	for _, q in QuestTemplates do
		if q.Id == questId then
			template = q
			break
		end
	end
	if not template then
		return false
	end

	local data = PlayerDataService.GetProfile(player)
	if not data or data.Quests.Claimed[questId] then
		return false
	end
	local progress = data.Quests.Progress[questId]
	if not progress or progress < template.Target then
		return false
	end

	PlayerDataService.Update(player, function(d)
		d.Quests.Claimed[questId] = true
	end)

	if template.Rewards.Coins then
		EconomyService.Add(player, "Coins", template.Rewards.Coins)
	end
	if template.Rewards.AccountXP then
		HeroService.AddAccountXP(player, template.Rewards.AccountXP)
	end
	if template.Rewards.StarterCase and template.Rewards.StarterCase > 0 then
		if not CaseService then
			CaseService = require(script.Parent.CaseService)
		end
		for _ = 1, template.Rewards.StarterCase do
			CaseService.Open(player, "StarterCase", true)
		end
	end

	return true
end

function QuestService.OnHeroLevelUp(player: Player)
	QuestService.Track(player, "HeroLevelUp", 1)
end

function QuestService.Start()
	local Players = game:GetService("Players")
	Players.PlayerAdded:Connect(function(player)
		task.defer(ensureDailyQuests, player)
	end)

	RemoteSetup.GetFunction("ClaimQuest").OnServerInvoke = function(player, questId)
		return QuestService.Claim(player, questId)
	end
end

return QuestService
