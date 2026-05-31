--!strict
--[[ CaseService.lua — Starter & Premium case rolls. docs/modules/CaseService.md ]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CaseRegistry = require(ReplicatedStorage.Config.Cases.CaseRegistry)
local HeroRegistry = require(ReplicatedStorage.Config.Heroes.HeroRegistry)
local Constants = require(ReplicatedStorage.Shared.Constants)
local EconomyService = require(script.Parent.EconomyService)
local HeroService = require(script.Parent.HeroService)
local PlayerDataService = require(script.Parent.PlayerDataService)
local QuestService = require(script.Parent.QuestService)
local RemoteSetup = require(script.Parent.RemoteSetup)

local CaseService = {}
local lastOpen: { [Player]: number } = {}

local function weightedRarity(weights: { [string]: number }): string
	local total = 0
	for _, w in weights do
		total += w
	end
	local roll = math.random(1, total)
	local acc = 0
	for rarity, w in weights do
		acc += w
		if roll <= acc then
			return rarity
		end
	end
	return "Common"
end

local function pickHeroFromRarity(caseId: string, rarity: string): string?
	local caseDef = CaseRegistry.Cases[caseId]
	local pool = if caseDef.UseStarterPool then HeroRegistry.GetStarterPool() else HeroRegistry.GetPremiumPool()
	local candidates = {}
	for _, h in pool do
		if h.Rarity == rarity then
			table.insert(candidates, h.Id)
		end
	end
	if #candidates == 0 then
		for _, h in pool do
			table.insert(candidates, h.Id)
		end
	end
	if #candidates == 0 then
		return nil
	end
	return candidates[math.random(1, #candidates)]
end

local function rollCase(player: Player, caseId: string)
	local caseDef = CaseRegistry.Cases[caseId]
	if not caseDef then
		return nil
	end

	local rarity = weightedRarity(caseDef.RarityWeights)

	if caseId == "PremiumCase" and caseDef.PityMythicEvery and caseDef.PityMythicEvery > 0 then
		PlayerDataService.Update(player, function(data)
			data.CasePity.PremiumCase = (data.CasePity.PremiumCase or 0) + 1
			if data.CasePity.PremiumCase >= caseDef.PityMythicEvery then
				rarity = "Mythic"
				data.CasePity.PremiumCase = 0
			end
		end)
	end

	local heroId = pickHeroFromRarity(caseId, rarity)
	if not heroId then
		return nil
	end

	local _, isNew = HeroService.GrantHero(player, heroId)
	local shards = if isNew then 0 else 50

	if shards > 0 then
		EconomyService.Add(player, "Coins", shards)
	end

	PlayerDataService.Update(player, function(data)
		data.Stats.CasesOpened += 1
	end)

	QuestService.Track(player, "OpenCase", 1)

	return {
		HeroId = heroId,
		Rarity = rarity,
		IsNew = isNew,
		ShardsAwarded = shards,
		Seed = math.random(1, 999999),
	}
end

function CaseService.Open(player: Player, caseId: string, free: boolean?): any
	local now = os.clock()
	if lastOpen[player] and now - lastOpen[player] < Constants.REMOTE_RATE_LIMIT.OpenCase then
		return nil
	end
	lastOpen[player] = now

	local caseDef = CaseRegistry.Cases[caseId]
	if not caseDef then
		return nil
	end

	if caseId == "StarterCase" and free then
		-- free open allowed
	elseif caseId == "PremiumCase" then
		if not EconomyService.TrySpend(player, "Premium", 1) then
			return nil
		end
	else
		if not EconomyService.TrySpend(player, "Coins", 250) then
			return nil
		end
	end

	return rollCase(player, caseId)
end

function CaseService.GrantStarterCase(player: Player)
	local data = PlayerDataService.GetProfile(player)
	if not data or data.Flags.HasStarterCase then
		return
	end
	PlayerDataService.Update(player, function(d)
		d.Flags.HasStarterCase = true
	end)
	return CaseService.Open(player, "StarterCase", true)
end

function CaseService.Start()
	local openResult = RemoteSetup.GetEvent("CaseOpenResult")
	local openRequest = RemoteSetup.GetEvent("CaseOpenRequest")

	openRequest.OnServerEvent:Connect(function(player, caseId: string)
		if type(caseId) ~= "string" then
			return
		end
		local result = CaseService.Open(player, caseId, false)
		if result then
			openResult:FireClient(player, caseId, result)
		end
	end)
end

return CaseService
