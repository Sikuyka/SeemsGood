--[[ Main.server.lua — entry point. docs/modules/Main.server.md ]]
local ServerScriptService = game:GetService("ServerScriptService")
local ServiceRunner = require(ServerScriptService.Services.ServiceRunner)
ServiceRunner.Start()
