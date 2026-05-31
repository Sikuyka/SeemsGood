--!strict
--[[ VFXStubs.lua — client VFX factory placeholders. docs/modules/VFXStubs.md ]]

local VFXStubs = {}

function VFXStubs.Spawn(key: string, position: Vector3, parent: Instance?)
	local part = Instance.new("Part")
	part.Name = "VFX_" .. key
	part.Size = Vector3.new(1, 1, 1)
	part.Anchored = true
	part.CanCollide = false
	part.Material = Enum.Material.Neon
	part.Color = Color3.fromRGB(255, 200, 80)
	part.Position = position
	part.Parent = parent or workspace
	task.delay(0.5, function()
		part:Destroy()
	end)
	return part
end

return VFXStubs
