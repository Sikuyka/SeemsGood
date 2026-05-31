--!strict
--[[ HeroRegistry.lua — hero roster (original IP). docs/modules/HeroRegistry.md ]]

local heroes: { [string]: any } = {}

local function reg(h)
	heroes[h.Id] = h
end

-- Starter pool (ordinary supers/fighters)
reg({
	Id = "street_brawler",
	DisplayName = "Street Brawler",
	Archetype = "Fighter",
	Rarity = "Common",
	BaseHealth = 100,
	BaseDamage = 10,
	BaseSpeed = 16,
	BaseDefense = 5,
	AbilityIds = { "punch_combo", "power_slam", "energy_burst", "ultimate_strike" },
	StarterPool = true,
	DefaultSkinId = "street_brawler_default",
})
reg({
	Id = "cape_rookie",
	DisplayName = "Cape Rookie",
	Archetype = "FlyingLeader",
	Rarity = "Common",
	BaseHealth = 95,
	BaseDamage = 11,
	BaseSpeed = 17,
	BaseDefense = 4,
	AbilityIds = { "punch_combo", "power_slam", "energy_burst", "ultimate_strike" },
	StarterPool = true,
	DefaultSkinId = "cape_rookie_default",
})
reg({
	Id = "shock_runner",
	DisplayName = "Shock Runner",
	Archetype = "Speedster",
	Rarity = "Rare",
	BaseHealth = 90,
	BaseDamage = 12,
	BaseSpeed = 22,
	BaseDefense = 4,
	AbilityIds = { "punch_combo", "power_slam", "energy_burst", "ultimate_strike" },
	StarterPool = true,
	DefaultSkinId = "shock_runner_default",
})
reg({
	Id = "tide_guard",
	DisplayName = "Tide Guard",
	Archetype = "SeaHero",
	Rarity = "Rare",
	BaseHealth = 110,
	BaseDamage = 10,
	BaseSpeed = 15,
	BaseDefense = 7,
	AbilityIds = { "punch_combo", "power_slam", "energy_burst", "ultimate_strike" },
	StarterPool = true,
	DefaultSkinId = "tide_guard_default",
})
reg({
	Id = "shadow_strike",
	DisplayName = "Shadow Strike",
	Archetype = "Assassin",
	Rarity = "Epic",
	BaseHealth = 85,
	BaseDamage = 14,
	BaseSpeed = 20,
	BaseDefense = 3,
	AbilityIds = { "punch_combo", "power_slam", "energy_burst", "ultimate_strike" },
	StarterPool = true,
	DefaultSkinId = "shadow_strike_default",
})
reg({
	Id = "solar_knight",
	DisplayName = "Solar Knight",
	Archetype = "LightHero",
	Rarity = "Epic",
	BaseHealth = 100,
	BaseDamage = 13,
	BaseSpeed = 16,
	BaseDefense = 6,
	AbilityIds = { "punch_combo", "power_slam", "energy_burst", "ultimate_strike" },
	StarterPool = true,
	DefaultSkinId = "solar_knight_default",
})
reg({
	Id = "iron_colossus",
	DisplayName = "Iron Colossus",
	Archetype = "Tank",
	Rarity = "Legendary",
	BaseHealth = 140,
	BaseDamage = 9,
	BaseSpeed = 12,
	BaseDefense = 12,
	AbilityIds = { "punch_combo", "power_slam", "energy_burst", "ultimate_strike" },
	StarterPool = true,
	DefaultSkinId = "iron_colossus_default",
})

-- Premium-only extras
reg({
	Id = "platinum_sentinel",
	DisplayName = "Platinum Sentinel",
	Archetype = "FlyingLeader",
	Rarity = "Legendary",
	BaseHealth = 120,
	BaseDamage = 14,
	BaseSpeed = 18,
	BaseDefense = 8,
	AbilityIds = { "punch_combo", "power_slam", "energy_burst", "ultimate_strike" },
	StarterPool = false,
	DefaultSkinId = "platinum_sentinel_default",
})
reg({
	Id = "ember_fury",
	DisplayName = "Ember Fury",
	Archetype = "FireHero",
	Rarity = "Legendary",
	BaseHealth = 105,
	BaseDamage = 15,
	BaseSpeed = 17,
	BaseDefense = 5,
	AbilityIds = { "punch_combo", "power_slam", "energy_burst", "ultimate_strike" },
	StarterPool = false,
	DefaultSkinId = "ember_fury_default",
})
reg({
	Id = "void_sovereign",
	DisplayName = "Void Sovereign",
	Archetype = "Controller",
	Rarity = "Mythic",
	BaseHealth = 115,
	BaseDamage = 18,
	BaseSpeed = 16,
	BaseDefense = 7,
	AbilityIds = { "punch_combo", "power_slam", "energy_burst", "ultimate_strike" },
	StarterPool = false,
	PremiumExclusive = true,
	DefaultSkinId = "void_sovereign_default",
})
reg({
	Id = "pulse_medic",
	DisplayName = "Pulse Medic",
	Archetype = "Support",
	Rarity = "Rare",
	BaseHealth = 100,
	BaseDamage = 8,
	BaseSpeed = 16,
	BaseDefense = 6,
	AbilityIds = { "punch_combo", "power_slam", "energy_burst", "ultimate_strike" },
	StarterPool = false,
	DefaultSkinId = "pulse_medic_default",
})
reg({
	Id = "volt_titan",
	DisplayName = "Volt Titan",
	Archetype = "Electric",
	Rarity = "Epic",
	BaseHealth = 98,
	BaseDamage = 14,
	BaseSpeed = 19,
	BaseDefense = 5,
	AbilityIds = { "punch_combo", "power_slam", "energy_burst", "ultimate_strike" },
	StarterPool = false,
	DefaultSkinId = "volt_titan_default",
})

local HeroRegistry = {}

function HeroRegistry.Get(id: string)
	return heroes[id]
end

function HeroRegistry.GetAll()
	return heroes
end

function HeroRegistry.GetByRarity(rarity: string): { any }
	local list = {}
	for _, h in heroes do
		if h.Rarity == rarity then
			table.insert(list, h)
		end
	end
	return list
end

function HeroRegistry.GetStarterPool(): { any }
	local list = {}
	for _, h in heroes do
		if h.StarterPool then
			table.insert(list, h)
		end
	end
	return list
end

function HeroRegistry.GetPremiumPool(): { any }
	local list = {}
	for _, h in heroes do
		table.insert(list, h)
	end
	return list
end

return HeroRegistry
