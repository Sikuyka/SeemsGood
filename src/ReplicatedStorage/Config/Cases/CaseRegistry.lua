--!strict
--[[ CaseRegistry.lua — drop tables for Starter and Premium cases. docs/modules/CaseRegistry.md ]]

local CaseRegistry = {}

CaseRegistry.Cases = {
	StarterCase = {
		Id = "StarterCase",
		DisplayName = "Starter Case",
		RarityWeights = {
			Common = 70,
			Rare = 20,
			Epic = 8,
			Legendary = 2,
		},
		UseStarterPool = true,
		PityLegendaryEvery = 0,
	},
	PremiumCase = {
		Id = "PremiumCase",
		DisplayName = "Premium Case",
		RarityWeights = {
			Common = 40,
			Rare = 35,
			Epic = 18,
			Legendary = 6,
			Mythic = 1,
		},
		UseStarterPool = false,
		PityMythicEvery = 120,
	},
}

return CaseRegistry
