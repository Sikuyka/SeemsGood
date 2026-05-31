--[[ Main.client.lua — client bootstrap. docs/modules/Main.client.md ]]

local Controllers = script.Parent.Controllers
local CombatController = require(Controllers.CombatController)
local CaseController = require(Controllers.CaseController)
local UIController = require(Controllers.UIController)
local VFXController = require(Controllers.VFXController)
local CharacterController = require(Controllers.CharacterController)

CombatController.Start()
CaseController.Start()
UIController.Start()
VFXController.Start()
CharacterController.Start()

print("[SeemsGood] Client ready.")
