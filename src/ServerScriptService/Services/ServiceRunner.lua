--!strict
--[[ ServiceRunner.lua — boots all server services. docs/modules/ServiceRunner.md ]]

local ServerScriptService = game:GetService("ServerScriptService")
local RemoteSetup = require(script.Parent.RemoteSetup)
local PlayerDataService = require(script.Parent.PlayerDataService)
local HeroService = require(script.Parent.HeroService)
local CaseService = require(script.Parent.CaseService)
local QuestService = require(script.Parent.QuestService)
local CombatService = require(script.Parent.CombatService)
local PvEService = require(script.Parent.PvEService)
local PvPService = require(script.Parent.PvPService)
local RetentionService = require(script.Parent.RetentionService)
local ShopService = require(script.Parent.ShopService)
local MonetizationService = require(script.Parent.MonetizationService)

local ServiceRunner = {}

function ServiceRunner.Start()
	RemoteSetup.Init()
	PlayerDataService.Start()
	HeroService.Start()
	QuestService.Start()
	CaseService.Start()
	CombatService.Start()
	PvEService.Start()
	PvPService.Start()
	RetentionService.Start()
	ShopService.Start()
	MonetizationService.Start()
	print("[SeemsGood] All services started.")
end

return ServiceRunner
