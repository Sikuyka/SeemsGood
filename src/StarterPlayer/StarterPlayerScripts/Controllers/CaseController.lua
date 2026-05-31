--!strict
--[[ CaseController.lua — case open UX. docs/modules/CaseController.md ]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Packets = require(ReplicatedStorage.Shared.Net.Packets)
local Constants = require(ReplicatedStorage.Shared.Constants)
local SFXStubs = require(ReplicatedStorage.Assets.SFXStubs)

local CaseController = {}
local remotes = ReplicatedStorage:WaitForChild(Packets.FolderName)

function CaseController.RequestOpen(caseId: string)
	remotes:WaitForChild(Packets.Events.CaseOpenRequest):FireServer(caseId)
end

local function playReveal(caseId: string, result: any)
	local player = game.Players.LocalPlayer
	local gui = player:WaitForChild("PlayerGui"):FindFirstChild("SeemsGoodUI")
	local frame = gui and gui:FindFirstChild("CaseReveal")
	if not frame then
		return
	end

	frame.Visible = true
	local label = frame:FindFirstChild("ResultText") :: TextLabel?
	local bar = frame:FindFirstChild("GlowBar") :: Frame?
	local rarityColor = Constants.RARITY_COLORS[result.Rarity] or Color3.new(1, 1, 1)

	if bar then
		bar.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
		TweenService:Create(bar, TweenInfo.new(1.2, Enum.EasingStyle.Quad), {
			BackgroundColor3 = rarityColor,
			Size = UDim2.new(1, 0, 0, 12),
		}):Play()
	end

	task.wait(1.2)
	if label then
		label.Text = `{result.Rarity} — {result.HeroId}`
		label.TextColor3 = rarityColor
	end

	task.delay(2.5, function()
		frame.Visible = false
	end)
end

function CaseController.Start()
	remotes:WaitForChild(Packets.Events.CaseOpenResult).OnClientEvent:Connect(function(caseId, result)
		playReveal(caseId, result)
	end)
end

return CaseController
