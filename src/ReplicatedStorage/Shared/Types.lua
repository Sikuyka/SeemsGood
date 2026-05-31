--!strict
--[[
	Types.lua
	Shared type definitions for SeemsGood.
	See docs/modules/Types.md
]]

export type Rarity = "Common" | "Rare" | "Epic" | "Legendary" | "Mythic"

export type CurrencyId = "Coins" | "Premium"

export type HeroId = string
export type AbilityId = string
export type CaseId = "StarterCase" | "PremiumCase"
export type SkinId = string
export type QuestId = string

export type HeroDefinition = {
	Id: HeroId,
	DisplayName: string,
	Archetype: string,
	Rarity: Rarity,
	BaseHealth: number,
	BaseDamage: number,
	BaseSpeed: number,
	BaseDefense: number,
	AbilityIds: { AbilityId },
	StarterPool: boolean,
	PremiumExclusive: boolean?,
	DefaultSkinId: SkinId,
}

export type AbilityDefinition = {
	Id: AbilityId,
	DisplayName: string,
	Slot: number,
	UnlockLevel: number,
	Damage: number,
	Cooldown: number,
	Range: number,
	Knockback: number,
	StunDuration: number,
	AnimationKey: string,
	VFXKey: string,
	SFXKey: string,
}

export type OwnedHero = {
	Level: number,
	XP: number,
	EquippedSkinId: SkinId,
	UnlockedAbilities: { AbilityId },
}

export type PlayerProfile = {
	Version: number,
	Coins: number,
	Premium: number,
	AccountLevel: number,
	AccountXP: number,
	OwnedHeroes: { [HeroId]: OwnedHero },
	OwnedSkins: { [SkinId]: boolean },
	EquippedHeroId: HeroId?,
	CasePity: { [CaseId]: number },
	Quests: {
		DailySeed: number,
		Progress: { [QuestId]: number },
		Claimed: { [QuestId]: boolean },
	},
	Retention: {
		LastLoginDay: number,
		LoginStreak: number,
		DailyRewardClaimed: boolean,
		SeasonXP: number,
		SeasonTier: number,
	},
	Achievements: { [string]: boolean },
	Stats: {
		PvPWins: number,
		PvPLosses: number,
		PvPRating: number,
		BanditsKilled: number,
		CasesOpened: number,
		AbilitiesUsed: number,
	},
	Flags: {
		HasStarterCase: boolean,
		IsSupporter: boolean,
		ReferralCode: string?,
	},
}

export type CaseRollResult = {
	HeroId: HeroId,
	Rarity: Rarity,
	IsNew: boolean,
	ShardsAwarded: number,
	Seed: number,
}

return {}
