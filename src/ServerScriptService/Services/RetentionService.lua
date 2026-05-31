--!strict
--[[ RetentionService.lua — daily login, rewards, achievements, season. docs/modules/RetentionService.md ]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local EconomyService = require(script.Parent.EconomyService)
local HeroService = require(script.Parent.HeroService)
local CaseService = require(script.Parent.CaseService)
local PlayerDataService = require(script.Parent.PlayerDataService)
local RemoteSetup = require(script.Parent.RemoteSetup)

local RetentionService = {}

local DAILY_REWARDS = {
	{ Coins = 100 },
	{ Coins = 150 },
	{ Coins = 200, AccountXP = 50 },
	{ Coins = 250, Premium = 0 },
	{ Coins = 300, StarterCase = true },
	{ Coins = 400, AccountXP = 100 },
	{ Coins = 500, Premium = 1 },
}

local ACHIEVEMENTS = {
	first_login = { Name = "Welcome Hero", Coins = 50 },
	kill_100 = { Name = "Bandit Hunter", Coins = 200, Stat = "BanditsKilled", Target = 100 },
	open_10_cases = { Name = "Collector", Coins = 150, Stat = "CasesOpened", Target = 10 },
	pvp_win_5 = { Name = "Arena Fighter", Coins = 300, Stat = "PvPWins", Target = 5 },
}

local function dayIndex(): number
	return math.floor(os.time() / 86400)
end

function RetentionService.ProcessLogin(player: Player)
	local today = dayIndex()
	PlayerDataService.Update(player, function(data)
		if data.Retention.LastLoginDay == today then
			return
		end
		if data.Retention.LastLoginDay == today - 1 then
			data.Retention.LoginStreak += 1
		else
			data.Retention.LoginStreak = 1
		end
		data.Retention.LastLoginDay = today
		data.Retention.DailyRewardClaimed = false
	end)

	if not PlayerDataService.GetProfile(player).Flags.HasStarterCase then
		CaseService.GrantStarterCase(player)
	end

	RetentionService.CheckAchievements(player)
end

function RetentionService.ClaimDailyReward(player: Player): boolean
	local data = PlayerDataService.GetProfile(player)
	if not data or data.Retention.DailyRewardClaimed then
		return false
	end

	local streak = math.clamp(data.Retention.LoginStreak, 1, #DAILY_REWARDS)
	local reward = DAILY_REWARDS[streak]

	PlayerDataService.Update(player, function(d)
		d.Retention.DailyRewardClaimed = true
		d.Retention.SeasonXP += 10
		if d.Retention.SeasonXP >= 100 then
			d.Retention.SeasonXP -= 100
			d.Retention.SeasonTier += 1
		end
	end)

	if reward.Coins then
		EconomyService.Add(player, "Coins", reward.Coins)
	end
	if reward.AccountXP then
		HeroService.AddAccountXP(player, reward.AccountXP)
	end
	if reward.Premium then
		EconomyService.Add(player, "Premium", reward.Premium)
	end
	if reward.StarterCase then
		CaseService.Open(player, "StarterCase", true)
	end

	RemoteSetup.GetEvent("Notification"):FireClient(player, "Daily reward claimed!", "success")
	return true
end

function RetentionService.UnlockAchievement(player: Player, id: string)
	local ach = ACHIEVEMENTS[id]
	if not ach then
		return
	end
	local data = PlayerDataService.GetProfile(player)
	if not data or data.Achievements[id] then
		return
	end

	PlayerDataService.Update(player, function(d)
		d.Achievements[id] = true
	end)
	if ach.Coins then
		EconomyService.Add(player, "Coins", ach.Coins)
	end
	RemoteSetup.GetEvent("AchievementUnlocked"):FireClient(player, id, ach.Name)
end

function RetentionService.CheckAchievements(player: Player)
	local data = PlayerDataService.GetProfile(player)
	if not data then
		return
	end

	if not data.Achievements.first_login then
		RetentionService.UnlockAchievement(player, "first_login")
	end

	for id, ach in ACHIEVEMENTS do
		if ach.Stat and ach.Target and (data.Stats[ach.Stat] or 0) >= ach.Target then
			RetentionService.UnlockAchievement(player, id)
		end
	end
end

function RetentionService.RedeemPromo(player: Player, code: string): boolean
	if type(code) ~= "string" then
		return false
	end
	code = string.lower(code)
	if code == "seemsgood" or code == "launch" then
		CaseService.Open(player, "StarterCase", true)
		return true
	end
	return false
end

function RetentionService.Start()
	local Players = game:GetService("Players")
	Players.PlayerAdded:Connect(function(player)
		task.wait(2)
		RetentionService.ProcessLogin(player)
	end)

	RemoteSetup.GetEvent("DailyRewardClaim").OnServerEvent:Connect(function(player)
		RetentionService.ClaimDailyReward(player)
	end)

	RemoteSetup.GetFunction("RedeemPromo").OnServerInvoke = function(player, code)
		return RetentionService.RedeemPromo(player, code)
	end
end

return RetentionService
