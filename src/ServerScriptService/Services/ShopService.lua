--!strict
--[[ ShopService.lua — skin catalog & ownership. docs/modules/ShopService.md ]]

local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SkinRegistry = require(ReplicatedStorage.Config.Skins.SkinRegistry)
local PlayerDataService = require(script.Parent.PlayerDataService)
local HeroService = require(script.Parent.HeroService)
local MonetizationService = require(script.Parent.MonetizationService)

local ShopService = {}

function ShopService.GrantSkin(player: Player, skinId: string): boolean
	local skin = SkinRegistry.Get(skinId)
	if not skin then
		return false
	end
	return PlayerDataService.Update(player, function(data)
		data.OwnedSkins[skinId] = true
	end)
end

function ShopService.ProcessReceipt(player: Player, productId: number): boolean
	for _, skin in SkinRegistry.GetAll() do
		if skin.ProductId == productId and skin.ProductId ~= 0 then
			ShopService.GrantSkin(player, skin.Id)
			HeroService.EquipSkin(player, skin.Id)
			MonetizationService.MarkSupporter(player)
			return true
		end
	end
	return false
end

function ShopService.Start()
	-- Developer products configured in Studio; map ProductId in SkinRegistry
	MarketplaceService.ProcessReceipt = function(receiptInfo)
		local player = game:GetService("Players"):GetPlayerByUserId(receiptInfo.PlayerId)
		if not player then
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end
		if ShopService.ProcessReceipt(player, receiptInfo.ProductId) then
			return Enum.ProductPurchaseDecision.PurchaseGranted
		end
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
end

return ShopService
