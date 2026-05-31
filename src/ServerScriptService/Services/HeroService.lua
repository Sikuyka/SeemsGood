--!strict
--[[ HeroService.lua — collection, XP, equip. docs/modules/HeroService.md ]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constants = require(ReplicatedStorage.Shared.Constants)
local HeroRegistry = require(ReplicatedStorage.Config.Heroes.HeroRegistry)
local HeroStats = require(ReplicatedStorage.Shared.HeroStats)
local PlayerDataService = require(script.Parent.PlayerDataService)
local RemoteSetup = require(script.Parent.RemoteSetup)

local HeroService = {}

function HeroService.GrantHero(player: Player, heroId: string): (boolean, boolean)
	local def = HeroRegistry.Get(heroId)
	if not def then
		return false, false
	end

	local isNew = false
	PlayerDataService.Update(player, function(data)
		if not data.OwnedHeroes[heroId] then
			isNew = true
			data.OwnedHeroes[heroId] = {
				Level = 1,
				XP = 0,
				EquippedSkinId = def.DefaultSkinId,
				UnlockedAbilities = HeroStats.GetUnlockedAbilities(heroId, 1),
			}
			data.OwnedSkins[def.DefaultSkinId] = true
			if not data.EquippedHeroId then
				data.EquippedHeroId = heroId
			end
		end
	end)
	return true, isNew
end

function HeroService.AddHeroXP(player: Player, heroId: string, xp: number)
	PlayerDataService.Update(player, function(data)
		local hero = data.OwnedHeroes[heroId]
		if not hero then
			return
		end
		if hero.Level >= Constants.MAX_HERO_LEVEL then
			return
		end

		hero.XP += xp
		while hero.Level < Constants.MAX_HERO_LEVEL do
			local need = Constants.RequiredXP(hero.Level)
			if hero.XP < need then
				break
			end
			hero.XP -= need
			hero.Level += 1
			hero.UnlockedAbilities = HeroStats.GetUnlockedAbilities(heroId, hero.Level)
		end
	end)
end

function HeroService.AddAccountXP(player: Player, xp: number)
	PlayerDataService.Update(player, function(data)
		if data.AccountLevel >= Constants.MAX_ACCOUNT_LEVEL then
			return
		end
		data.AccountXP += xp
		while data.AccountLevel < Constants.MAX_ACCOUNT_LEVEL do
			local need = Constants.RequiredXP(data.AccountLevel)
			if data.AccountXP < need then
				break
			end
			data.AccountXP -= need
			data.AccountLevel += 1
		end
	end)
end

function HeroService.EquipHero(player: Player, heroId: string): boolean
	local data = PlayerDataService.GetProfile(player)
	if not data or not data.OwnedHeroes[heroId] then
		return false
	end
	return PlayerDataService.Update(player, function(d)
		d.EquippedHeroId = heroId
	end)
end

function HeroService.EquipSkin(player: Player, skinId: string): boolean
	local data = PlayerDataService.GetProfile(player)
	if not data or not data.OwnedSkins[skinId] then
		return false
	end
	local skin = require(ReplicatedStorage.Config.Skins.SkinRegistry).Get(skinId)
	if not skin then
		return false
	end
	local hero = data.OwnedHeroes[skin.HeroId]
	if not hero then
		return false
	end
	return PlayerDataService.Update(player, function(d)
		d.OwnedHeroes[skin.HeroId].EquippedSkinId = skinId
	end)
end

function HeroService.GetEquippedStats(player: Player)
	local data = PlayerDataService.GetProfile(player)
	if not data or not data.EquippedHeroId then
		return nil
	end
	local hero = data.OwnedHeroes[data.EquippedHeroId]
	if not hero then
		return nil
	end
	return HeroStats.Compute(data.EquippedHeroId, hero.Level)
end

function HeroService.Start()
	RemoteSetup.GetFunction("EquipHero").OnServerInvoke = function(player, heroId)
		return HeroService.EquipHero(player, heroId)
	end
	RemoteSetup.GetFunction("EquipSkin").OnServerInvoke = function(player, skinId)
		return HeroService.EquipSkin(player, skinId)
	end
end

return HeroService
