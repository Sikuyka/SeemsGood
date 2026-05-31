--!strict
--[[ DefaultProfile.lua — new player data template. docs/modules/DefaultProfile.md ]]

local function deepCopy(t)
	local c = {}
	for k, v in t do
		if type(v) == "table" then
			c[k] = deepCopy(v)
		else
			c[k] = v
		end
	end
	return c
end

local template = {
	Version = 1,
	Coins = 500,
	Premium = 0,
	AccountLevel = 1,
	AccountXP = 0,
	OwnedHeroes = {},
	OwnedSkins = {},
	EquippedHeroId = nil,
	CasePity = {
		StarterCase = 0,
		PremiumCase = 0,
	},
	Quests = {
		DailySeed = 0,
		Progress = {},
		Claimed = {},
	},
	Retention = {
		LastLoginDay = 0,
		LoginStreak = 0,
		DailyRewardClaimed = false,
		SeasonXP = 0,
		SeasonTier = 0,
	},
	Achievements = {},
	Stats = {
		PvPWins = 0,
		PvPLosses = 0,
		PvPRating = 1000,
		BanditsKilled = 0,
		CasesOpened = 0,
		AbilitiesUsed = 0,
	},
	Flags = {
		HasStarterCase = false,
		IsSupporter = false,
		ReferralCode = nil,
	},
}

return {
	Get = function()
		return deepCopy(template)
	end,
}
