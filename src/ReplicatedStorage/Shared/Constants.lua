--!strict
--[[
	Constants.lua
	Global tuning values. See docs/modules/Constants.md
]]

local Constants = {}

Constants.GAME_NAME = "SeemsGood"
Constants.MAX_HERO_LEVEL = 100
Constants.MAX_ACCOUNT_LEVEL = 100

Constants.STAT_FORMULAS = {
	Health = function(level: number, base: number): number
		return base + (level * 15)
	end,
	Damage = function(level: number, base: number): number
		return base + (level * 2)
	end,
	Defense = function(level: number, base: number): number
		return base + (level * 1)
	end,
	Speed = function(level: number, base: number): number
		return base + (level * 0.5)
	end,
}

function Constants.RequiredXP(level: number): number
	return math.floor(100 * (level ^ 1.5))
end

Constants.ABILITY_UNLOCK_LEVELS = { 1, 2, 5, 10 }

Constants.RARITY_COLORS = {
	Common = Color3.fromRGB(180, 180, 180),
	Rare = Color3.fromRGB(80, 140, 255),
	Epic = Color3.fromRGB(170, 80, 255),
	Legendary = Color3.fromRGB(255, 180, 40),
	Mythic = Color3.fromRGB(255, 60, 120),
}

Constants.CASE_COSTS = {
	StarterCase = { Currency = "Coins", Amount = 0 },
	PremiumCase = { Currency = "Premium", Amount = 1 },
}

Constants.PVP_BASE_RATING = 1000
Constants.DAILY_QUEST_COUNT = 3

Constants.REMOTE_RATE_LIMIT = {
	CombatAction = 0.08,
	OpenCase = 2,
	UseAbility = 0.15,
}

return Constants
