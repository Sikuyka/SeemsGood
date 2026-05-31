--!strict
--[[ QuestTemplates.lua — daily quest templates. docs/modules/QuestTemplates.md ]]

local QuestTemplates = {
	{
		Id = "kill_10_bandits",
		DisplayName = "Defeat 10 Bandits",
		Type = "KillBandits",
		Target = 10,
		Rewards = { Coins = 100, AccountXP = 50, StarterCase = 0 },
	},
	{
		Id = "kill_25_bandits",
		DisplayName = "Defeat 25 Bandits",
		Type = "KillBandits",
		Target = 25,
		Rewards = { Coins = 250, AccountXP = 120, StarterCase = 1 },
	},
	{
		Id = "use_ability_50",
		DisplayName = "Use Abilities 50 Times",
		Type = "UseAbility",
		Target = 50,
		Rewards = { Coins = 150, AccountXP = 80 },
	},
	{
		Id = "open_case",
		DisplayName = "Open a Case",
		Type = "OpenCase",
		Target = 1,
		Rewards = { Coins = 75, AccountXP = 40 },
	},
	{
		Id = "gain_level",
		DisplayName = "Level Up a Hero",
		Type = "HeroLevelUp",
		Target = 1,
		Rewards = { Coins = 200, AccountXP = 100, Premium = 0 },
	},
}

return QuestTemplates
