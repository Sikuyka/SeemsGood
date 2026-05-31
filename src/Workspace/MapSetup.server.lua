--[[ MapSetup.server.lua — world placeholders. docs/modules/MapSetup.md ]]

local Workspace = game:GetService("Workspace")

if not Workspace:FindFirstChild("SpawnLocation") then
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "SpawnLocation"
	spawn.Size = Vector3.new(12, 1, 12)
	spawn.Position = Vector3.new(0, 3, 0)
	spawn.Anchored = true
	spawn.Parent = Workspace
end

if not Workspace:FindFirstChild("LobbyFloor") then
	local floor = Instance.new("Part")
	floor.Name = "LobbyFloor"
	floor.Size = Vector3.new(200, 1, 200)
	floor.Position = Vector3.new(0, 0, 0)
	floor.Anchored = true
	floor.BrickColor = BrickColor.new("Dark stone grey")
	floor.Parent = Workspace
end
