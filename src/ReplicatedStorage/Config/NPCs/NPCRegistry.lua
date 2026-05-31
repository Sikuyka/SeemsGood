--!strict
--[[ NPCRegistry.lua — PvE bandit types. docs/modules/NPCRegistry.md ]]

local NPCRegistry = {
	Thug = {
		Id = "Thug",
		DisplayName = "Thug",
		Health = 80,
		Damage = 8,
		Defense = 2,
		Speed = 14,
		CoinReward = 15,
		XPReward = 25,
		Scale = 1,
	},
	Veteran = {
		Id = "Veteran",
		DisplayName = "Veteran",
		Health = 150,
		Damage = 14,
		Defense = 5,
		Speed = 13,
		CoinReward = 35,
		XPReward = 55,
		Scale = 1.1,
	},
	Elite = {
		Id = "Elite",
		DisplayName = "Elite",
		Health = 280,
		Damage = 22,
		Defense = 10,
		Speed = 12,
		CoinReward = 75,
		XPReward = 120,
		Scale = 1.25,
	},
	Boss = {
		Id = "Boss",
		DisplayName = "Bandit Boss",
		Health = 800,
		Damage = 35,
		Defense = 18,
		Speed = 10,
		CoinReward = 250,
		XPReward = 400,
		Scale = 1.8,
	},
}

return NPCRegistry
