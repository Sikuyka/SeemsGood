--!strict
--[[
	Packets.lua
	Remote names and payload contracts. Server creates instances in Remotes folder.
	docs/modules/Packets.md
]]

local Packets = {}

Packets.FolderName = "Remotes"

Packets.Events = {
	-- Data sync
	ProfileUpdated = "ProfileUpdated",
	Notification = "Notification",

	-- Combat
	CombatAction = "CombatAction",
	CombatHit = "CombatHit",
	AbilityUsed = "AbilityUsed",
	ApplyKnockback = "ApplyKnockback",
	ApplyStun = "ApplyStun",

	-- Cases
	CaseOpenRequest = "CaseOpenRequest",
	CaseOpenResult = "CaseOpenResult",

	-- Quests / retention
	QuestUpdated = "QuestUpdated",
	DailyRewardClaim = "DailyRewardClaim",
	AchievementUnlocked = "AchievementUnlocked",

	-- PvP
	PvPQueue = "PvPQueue",
	PvPMatchStart = "PvPMatchStart",
	PvPMatchEnd = "PvPMatchEnd",

	-- PvE
	PvEEnemySpawned = "PvEEnemySpawned",
	PvEEnemyDied = "PvEEnemyDied",
}

Packets.Functions = {
	GetProfile = "GetProfile",
	ClaimQuest = "ClaimQuest",
	EquipHero = "EquipHero",
	EquipSkin = "EquipSkin",
	RedeemPromo = "RedeemPromo",
}

return Packets
