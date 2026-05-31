--!strict
--[[ AbilityRegistry.lua — all ability definitions. docs/modules/AbilityRegistry.md ]]

local AbilityRegistry = {}
local abilities: { [string]: any } = {}

local function register(a)
	abilities[a.Id] = a
end

register({
	Id = "punch_combo",
	DisplayName = "Rapid Strikes",
	Slot = 1,
	UnlockLevel = 1,
	Damage = 12,
	Cooldown = 2,
	Range = 8,
	Knockback = 2,
	StunDuration = 0,
	AnimationKey = "Skill1",
	VFXKey = "HitSpark",
	SFXKey = "Punch",
})

register({
	Id = "power_slam",
	DisplayName = "Power Slam",
	Slot = 2,
	UnlockLevel = 2,
	Damage = 22,
	Cooldown = 4,
	Range = 6,
	Knockback = 8,
	StunDuration = 0.3,
	AnimationKey = "Skill2",
	VFXKey = "GroundSlam",
	SFXKey = "Slam",
})

register({
	Id = "energy_burst",
	DisplayName = "Energy Burst",
	Slot = 3,
	UnlockLevel = 5,
	Damage = 35,
	Cooldown = 8,
	Range = 12,
	Knockback = 5,
	StunDuration = 0.5,
	AnimationKey = "Skill3",
	VFXKey = "EnergyBurst",
	SFXKey = "Burst",
})

register({
	Id = "ultimate_strike",
	DisplayName = "Ultimate Strike",
	Slot = 4,
	UnlockLevel = 10,
	Damage = 80,
	Cooldown = 20,
	Range = 14,
	Knockback = 15,
	StunDuration = 1,
	AnimationKey = "Skill4",
	VFXKey = "Ultimate",
	SFXKey = "Ultimate",
})

function AbilityRegistry.Get(id: string)
	return abilities[id]
end

function AbilityRegistry.GetAll()
	return abilities
end

return AbilityRegistry
