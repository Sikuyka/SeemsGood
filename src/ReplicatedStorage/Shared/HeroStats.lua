--!strict
--[[ HeroStats.lua — compute hero stats from level. docs/modules/HeroStats.md ]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Shared.Constants)
local HeroRegistry = require(ReplicatedStorage.Config.Heroes.HeroRegistry)

local HeroStats = {}

export type ComputedStats = {
	Health: number,
	Damage: number,
	Defense: number,
	Speed: number,
	Level: number,
}

function HeroStats.Compute(heroId: string, level: number): ComputedStats
	local def = HeroRegistry.Get(heroId)
	if not def then
		error(`Unknown hero: {heroId}`)
	end
	level = math.clamp(level, 1, Constants.MAX_HERO_LEVEL)
	return {
		Health = Constants.STAT_FORMULAS.Health(level, def.BaseHealth),
		Damage = Constants.STAT_FORMULAS.Damage(level, def.BaseDamage),
		Defense = Constants.STAT_FORMULAS.Defense(level, def.BaseDefense),
		Speed = Constants.STAT_FORMULAS.Speed(level, def.BaseSpeed),
		Level = level,
	}
end

function HeroStats.GetUnlockedAbilities(heroId: string, level: number): { string }
	local def = HeroRegistry.Get(heroId)
	local unlocked = {}
	for _, abilityId in def.AbilityIds do
		local ability = require(ReplicatedStorage.Config.Abilities.AbilityRegistry).Get(abilityId)
		if ability and level >= ability.UnlockLevel then
			table.insert(unlocked, abilityId)
		end
	end
	return unlocked
end

return HeroStats
