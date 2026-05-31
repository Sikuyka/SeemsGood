--!strict
--[[ RemoteSetup.lua — creates RemoteEvents/Functions. docs/modules/RemoteSetup.md ]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packets = require(ReplicatedStorage.Shared.Net.Packets)

local RemoteSetup = {}
local folder: Folder

function RemoteSetup.Init()
	folder = ReplicatedStorage:FindFirstChild(Packets.FolderName) :: Folder
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = Packets.FolderName
		folder.Parent = ReplicatedStorage
	end

	for _, name in Packets.Events do
		if not folder:FindFirstChild(name) then
			local re = Instance.new("RemoteEvent")
			re.Name = name
			re.Parent = folder
		end
	end

	for _, name in Packets.Functions do
		if not folder:FindFirstChild(name) then
			local rf = Instance.new("RemoteFunction")
			rf.Name = name
			rf.Parent = folder
		end
	end
end

function RemoteSetup.GetEvent(name: string): RemoteEvent
	return folder:WaitForChild(name) :: RemoteEvent
end

function RemoteSetup.GetFunction(name: string): RemoteFunction
	return folder:WaitForChild(name) :: RemoteFunction
end

return RemoteSetup
