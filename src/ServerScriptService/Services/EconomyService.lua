--!strict
--[[ EconomyService.lua — Coins & Premium. docs/modules/EconomyService.md ]]

local PlayerDataService = require(script.Parent.PlayerDataService)

local EconomyService = {}

function EconomyService.Get(player: Player, currency: string): number
	local data = PlayerDataService.GetProfile(player)
	if not data then
		return 0
	end
	if currency == "Coins" then
		return data.Coins
	elseif currency == "Premium" then
		return data.Premium
	end
	return 0
end

function EconomyService.CanAfford(player: Player, currency: string, amount: number): boolean
	return EconomyService.Get(player, currency) >= amount
end

function EconomyService.Add(player: Player, currency: string, amount: number): boolean
	if amount <= 0 then
		return false
	end
	return PlayerDataService.Update(player, function(data)
		if currency == "Coins" then
			data.Coins += amount
		elseif currency == "Premium" then
			data.Premium += amount
		end
	end)
end

function EconomyService.TrySpend(player: Player, currency: string, amount: number): boolean
	if amount <= 0 then
		return true
	end
	local data = PlayerDataService.GetProfile(player)
	if not data then
		return false
	end
	if currency == "Coins" and data.Coins < amount then
		return false
	end
	if currency == "Premium" and data.Premium < amount then
		return false
	end
	return PlayerDataService.Update(player, function(d)
		if currency == "Coins" then
			d.Coins -= amount
		elseif currency == "Premium" then
			d.Premium -= amount
		end
	end)
end

return EconomyService
