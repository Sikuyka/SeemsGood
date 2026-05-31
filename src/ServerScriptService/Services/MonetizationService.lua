--!strict
--[[ MonetizationService.lua — Robux products & Supporter. docs/modules/MonetizationService.md ]]

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local EconomyService = require(script.Parent.EconomyService)
local PlayerDataService = require(script.Parent.PlayerDataService)

local MonetizationService = {}

-- Map product IDs in Roblox Studio Developer Products
local PRODUCT_MAP = {
	-- [productId] = { Type = "Premium", Amount = 10 }
}

function MonetizationService.MarkSupporter(player: Player)
	PlayerDataService.Update(player, function(data)
		data.Flags.IsSupporter = true
	end)
end

function MonetizationService.Start()
	MarketplaceService.PromptProductPurchaseFinished:Connect(function(player, productId, purchased)
		if not purchased then
			return
		end
		local reward = PRODUCT_MAP[productId]
		if reward and reward.Type == "Premium" then
			EconomyService.Add(player, "Premium", reward.Amount)
			MonetizationService.MarkSupporter(player)
		end
	end)

	-- Game Pass example: Supporter badge
	for _, passId in {} do
		MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, id, purchased)
			if purchased and id == passId then
				MonetizationService.MarkSupporter(player)
			end
		end)
	end
end

return MonetizationService
