--!strict
--[[ CreateUI.client.lua — builds SeemsGood HUD. docs/modules/CreateUI.md ]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("SeemsGoodUI") then
	return
end

local gui = Instance.new("ScreenGui")
gui.Name = "SeemsGoodUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local function label(name, text, pos, size, parent)
	local l = Instance.new("TextLabel")
	l.Name = name
	l.BackgroundTransparency = 0.3
	l.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
	l.TextColor3 = Color3.new(1, 1, 1)
	l.Font = Enum.Font.GothamBold
	l.TextSize = 16
	l.Text = text
	l.Position = pos
	l.Size = size
	l.Parent = parent
	return l
end

local function button(name, text, pos, parent)
	local b = Instance.new("TextButton")
	b.Name = name
	b.BackgroundColor3 = Color3.fromRGB(60, 100, 255)
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.Text = text
	b.Position = pos
	b.Size = UDim2.new(0, 140, 0, 36)
	b.Parent = parent
	return b
end

-- Top bar
local top = Instance.new("Frame")
top.Name = "TopBar"
top.BackgroundTransparency = 1
top.Size = UDim2.new(1, 0, 0, 80)
top.Parent = gui

label("CoinsLabel", "Coins: 0", UDim2.new(0, 10, 0, 10), UDim2.new(0, 160, 0, 28), top)
label("PremiumLabel", "Premium: 0", UDim2.new(0, 180, 0, 10), UDim2.new(0, 160, 0, 28), top)
label("AccountLevelLabel", "Lv 1", UDim2.new(0, 350, 0, 10), UDim2.new(0, 80, 0, 28), top)
label("HeroLabel", "Hero: —", UDim2.new(0, 440, 0, 10), UDim2.new(0, 200, 0, 28), top)

local xpBack = Instance.new("Frame")
xpBack.Name = "XPBarBack"
xpBack.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
xpBack.Position = UDim2.new(0, 10, 0, 44)
xpBack.Size = UDim2.new(0, 300, 0, 14)
xpBack.Parent = top

local xpFill = Instance.new("Frame")
xpFill.Name = "XPBarFill"
xpFill.BackgroundColor3 = Color3.fromRGB(80, 200, 120)
xpFill.Size = UDim2.new(0, 0, 1, 0)
xpFill.Parent = xpBack

-- Side actions
local side = Instance.new("Frame")
side.Name = "SidePanel"
side.BackgroundTransparency = 1
side.Position = UDim2.new(1, -160, 0.3, 0)
side.Size = UDim2.new(0, 150, 0, 220)
side.Parent = gui

button("OpenStarterCase", "Starter Case", UDim2.new(0, 0, 0, 0), side)
button("OpenPremiumCase", "Premium Case", UDim2.new(0, 0, 0, 44), side)
button("DailyRewardButton", "Daily Reward", UDim2.new(0, 0, 0, 88), side)
button("PvPQueueButton", "PvP Queue", UDim2.new(0, 0, 0, 132), side)

-- Case reveal overlay
local reveal = Instance.new("Frame")
reveal.Name = "CaseReveal"
reveal.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
reveal.BackgroundTransparency = 0.4
reveal.Size = UDim2.new(1, 0, 1, 0)
reveal.Visible = false
reveal.Parent = gui

local glow = Instance.new("Frame")
glow.Name = "GlowBar"
glow.Size = UDim2.new(0.6, 0, 0, 8)
glow.Position = UDim2.new(0.2, 0, 0.45, 0)
glow.Parent = reveal

label("ResultText", "...", UDim2.new(0.2, 0, 0.5, 0), UDim2.new(0.6, 0, 0, 40), reveal)

-- Collection panel
local collection = Instance.new("Frame")
collection.Name = "CollectionPanel"
collection.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
collection.BackgroundTransparency = 0.1
collection.Position = UDim2.new(0, 10, 1, -120)
collection.Size = UDim2.new(0, 400, 0, 100)
collection.Parent = gui
label("CollectionTitle", "Collection - see profile for heroes", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 24), collection)

-- Toast
local toast = Instance.new("TextLabel")
toast.Name = "Toast"
toast.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
toast.TextColor3 = Color3.new(1, 1, 1)
toast.Text = ""
toast.Visible = false
toast.Position = UDim2.new(0.5, -150, 0.8, 0)
toast.Size = UDim2.new(0, 300, 0, 40)
toast.Parent = gui

-- Controls hint
label("ControlsHint", "LMB Light | R Heavy | 1-4 Skills", UDim2.new(0, 10, 1, -30), UDim2.new(0, 320, 0, 24), gui)
