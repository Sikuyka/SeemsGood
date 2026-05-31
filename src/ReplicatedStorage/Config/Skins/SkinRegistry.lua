--!strict
--[[ SkinRegistry.lua — cosmetic skins (Robux). docs/modules/SkinRegistry.md ]]

local SkinRegistry = {}

local skins = {}

local function add(s)
	skins[s.Id] = s
end

-- Example skins per hero (placeholders for models/VFX/icons in Studio)
add({
	Id = "street_brawler_default",
	HeroId = "street_brawler",
	DisplayName = "Default",
	RobuxPrice = 0,
	ModelKey = "StreetBrawler_Default",
	VFXKey = "DefaultVFX",
	IconKey = "rbxassetid://0",
})
add({
	Id = "street_brawler_neon",
	HeroId = "street_brawler",
	DisplayName = "Neon Fighter",
	RobuxPrice = 149,
	ProductId = 0,
	ModelKey = "StreetBrawler_Neon",
	VFXKey = "NeonTrail",
	IconKey = "rbxassetid://0",
})
add({
	Id = "void_sovereign_default",
	HeroId = "void_sovereign",
	DisplayName = "Void Form",
	RobuxPrice = 0,
	ModelKey = "VoidSovereign_Default",
	VFXKey = "VoidAura",
	IconKey = "rbxassetid://0",
})
add({
	Id = "void_sovereign_eclipse",
	HeroId = "void_sovereign",
	DisplayName = "Eclipse Skin",
	RobuxPrice = 299,
	ProductId = 0,
	ModelKey = "VoidSovereign_Eclipse",
	VFXKey = "EclipseBurst",
	IconKey = "rbxassetid://0",
})

function SkinRegistry.Get(id: string)
	return skins[id]
end

function SkinRegistry.GetForHero(heroId: string): { any }
	local list = {}
	for _, s in skins do
		if s.HeroId == heroId then
			table.insert(list, s)
		end
	end
	return list
end

function SkinRegistry.GetAll()
	return skins
end

return SkinRegistry
