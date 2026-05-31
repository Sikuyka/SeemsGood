--!strict
--[[ UIController.lua — wires HUD buttons to systems. docs/modules/UIController.md ]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packets = require(ReplicatedStorage.Shared.Net.Packets)
local Constants = require(ReplicatedStorage.Shared.Constants)

local CaseController = require(script.Parent.CaseController)

local UIController = {}
local player = Players.LocalPlayer

local function updateHUD(profile: any)
	local gui = player:WaitForChild("PlayerGui"):FindFirstChild("SeemsGoodUI")
	if not gui or not profile then
		return
	end

	local coins = gui:FindFirstChild("CoinsLabel", true) :: TextLabel?
	if coins then
		coins.Text = `Coins: {profile.Coins}`
	end
	local premium = gui:FindFirstChild("PremiumLabel", true) :: TextLabel?
	if premium then
		premium.Text = `Premium: {profile.Premium}`
	end
	local level = gui:FindFirstChild("AccountLevelLabel", true) :: TextLabel?
	if level then
		level.Text = `Lv {profile.AccountLevel}`
	end
	local xpBar = gui:FindFirstChild("XPBarFill", true) :: Frame?
	if xpBar then
		local need = Constants.RequiredXP(profile.AccountLevel)
		local ratio = if need > 0 then math.clamp(profile.AccountXP / need, 0, 1) else 0
		xpBar.Size = UDim2.new(ratio, 0, 1, 0)
	end
	local heroLabel = gui:FindFirstChild("HeroLabel", true) :: TextLabel?
	if heroLabel then
		heroLabel.Text = profile.EquippedHeroId or "No hero"
	end
end

function UIController.Start()
	local remotes = ReplicatedStorage:WaitForChild(Packets.FolderName)
	remotes:WaitForChild(Packets.Events.ProfileUpdated).OnClientEvent:Connect(updateHUD)

	remotes:WaitForChild(Packets.Events.Notification).OnClientEvent:Connect(function(msg, _kind)
		local gui = player:WaitForChild("PlayerGui"):FindFirstChild("SeemsGoodUI")
		local toast = gui and gui:FindFirstChild("Toast", true) :: TextLabel?
		if toast then
			toast.Text = msg
			toast.Visible = true
			task.delay(3, function()
				toast.Visible = false
			end)
		end
	end)

	remotes:WaitForChild(Packets.Events.AchievementUnlocked).OnClientEvent:Connect(function(_id, name)
		local gui = player:WaitForChild("PlayerGui"):FindFirstChild("SeemsGoodUI")
		local toast = gui and gui:FindFirstChild("Toast", true) :: TextLabel?
		if toast then
			toast.Text = `Achievement: {name}`
			toast.Visible = true
		end
	end)

	task.defer(function()
		local profile = remotes:WaitForChild(Packets.Functions.GetProfile):InvokeServer()
		updateHUD(profile)
	end)

	local gui = player:WaitForChild("PlayerGui"):WaitForChild("SeemsGoodUI")
	local starterBtn = gui:FindFirstChild("OpenStarterCase", true)
	if starterBtn and starterBtn:IsA("TextButton") then
		starterBtn.MouseButton1Click:Connect(function()
			CaseController.RequestOpen("StarterCase")
		end)
	end
	local premiumBtn = gui:FindFirstChild("OpenPremiumCase", true)
	if premiumBtn and premiumBtn:IsA("TextButton") then
		premiumBtn.MouseButton1Click:Connect(function()
			CaseController.RequestOpen("PremiumCase")
		end)
	end
	local dailyBtn = gui:FindFirstChild("DailyRewardButton", true)
	if dailyBtn and dailyBtn:IsA("TextButton") then
		dailyBtn.MouseButton1Click:Connect(function()
			remotes:WaitForChild(Packets.Events.DailyRewardClaim):FireServer()
		end)
	end
	local pvpBtn = gui:FindFirstChild("PvPQueueButton", true)
	if pvpBtn and pvpBtn:IsA("TextButton") then
		pvpBtn.MouseButton1Click:Connect(function()
			remotes:WaitForChild(Packets.Events.PvPQueue):FireServer()
		end)
	end
end

return UIController
