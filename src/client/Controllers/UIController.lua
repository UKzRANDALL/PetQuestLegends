-- Pet Quest Legends - UI Controller
-- Manages all UI elements and interactions

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local RemoteManager = require(ReplicatedStorage.Modules.RemoteManager)
local Utilities = require(ReplicatedStorage.Modules.Utilities)
local PetConfig = require(ReplicatedStorage.Config.PetConfig)
local WorldConfig = require(ReplicatedStorage.Config.WorldConfig)
local QuestConfig = require(ReplicatedStorage.Config.QuestConfig)
local GamepassConfig = require(ReplicatedStorage.Config.GamepassConfig)

local UIController = {}
UIController.ScreenGui = nil
UIController.CurrentUI = nil
UIController.CurrentOpenUI = nil

-- Initialize UI
function UIController.Init()
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main ScreenGui
UIController.ScreenGui = Instance.new("ScreenGui")
UIController.ScreenGui.Name = "PetQuestLegendsUI"
UIController.ScreenGui.ResetOnSpawn = false
UIController.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
UIController.ScreenGui.Parent = playerGui

-- Create main HUD
UIController.CreateMainHUD()

-- Create notification system
UIController.CreateNotificationSystem()

print("[UIController] Initialized")
end

-- Create main HUD
function UIController.CreateMainHUD()
local hud = Instance.new("Frame")
hud.Name = "MainHUD"
hud.Size = UDim2.new(1, 0, 1, 0)
hud.BackgroundTransparency = 1
hud.Parent = UIController.ScreenGui

-- Top bar
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(0, 400, 0, 50)
topBar.Position = UDim2.new(0, 10, 0, 10)
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topBar.BorderSizePixel = 0
topBar.BackgroundTransparency = 0.3
topBar.Parent = hud

-- Add gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
})
gradient.Rotation = 90
gradient.Parent = topBar

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 12)
topBarCorner.Parent = topBar

-- Coins display
local coinsFrame = Instance.new("Frame")
coinsFrame.Name = "CoinsFrame"
coinsFrame.Size = UDim2.new(0, 180, 0, 35)
coinsFrame.Position = UDim2.new(0, 10, 0.5, -17.5)
coinsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
coinsFrame.BorderSizePixel = 0
coinsFrame.Parent = topBar

local coinsCorner = Instance.new("UICorner")
coinsCorner.CornerRadius = UDim.new(0, 8)
coinsCorner.Parent = coinsFrame

local coinsIcon = Instance.new("TextLabel")
coinsIcon.Name = "Icon"
coinsIcon.Size = UDim2.new(0, 30, 0, 30)
coinsIcon.Position = UDim2.new(0, 5, 0.5, -15)
coinsIcon.BackgroundTransparency = 1
coinsIcon.Text = "💰"
coinsIcon.TextSize = 20
coinsIcon.Parent = coinsFrame

local coinsLabel = Instance.new("TextLabel")
coinsLabel.Name = "Amount"
coinsLabel.Size = UDim2.new(1, -40, 1, 0)
coinsLabel.Position = UDim2.new(0, 40, 0, 0)
coinsLabel.BackgroundTransparency = 1
coinsLabel.Text = "0"
coinsLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
coinsLabel.TextSize = 18
coinsLabel.Font = Enum.Font.GothamBold
coinsLabel.TextXAlignment = Enum.TextXAlignment.Left
coinsLabel.Parent = coinsFrame

-- Level display
local levelFrame = Instance.new("Frame")
levelFrame.Name = "LevelFrame"
levelFrame.Size = UDim2.new(0, 150, 0, 35)
levelFrame.Position = UDim2.new(0, 200, 0.5, -17.5)
levelFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
levelFrame.BorderSizePixel = 0
levelFrame.Parent = topBar

local levelCorner = Instance.new("UICorner")
levelCorner.CornerRadius = UDim.new(0, 8)
levelCorner.Parent = levelFrame

local levelLabel = Instance.new("TextLabel")
levelLabel.Name = "Level"
levelLabel.Size = UDim2.new(1, 0, 1, 0)
levelLabel.BackgroundTransparency = 1
levelLabel.Text = "Level 1"
levelLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
levelLabel.TextSize = 18
levelLabel.Font = Enum.Font.GothamBold
levelLabel.Parent = levelFrame

-- Bottom buttons
local buttonContainer = Instance.new("Frame")
buttonContainer.Name = "ButtonContainer"
buttonContainer.Size = UDim2.new(0, 500, 0, 80)
buttonContainer.Position = UDim2.new(0.5, -250, 1, -90)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = hud

local buttonLayout = Instance.new("UIListLayout")
buttonLayout.FillDirection = Enum.FillDirection.Horizontal
buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
buttonLayout.Padding = UDim.new(0, 10)
buttonLayout.Parent = buttonContainer

-- Create buttons
UIController.CreateButton(buttonContainer, "Pets", "🐾", function()
UIController.OpenPetsUI()
end)

UIController.CreateButton(buttonContainer, "Hatch", "🥚", function()
UIController.OpenHatchUI()
end)

UIController.CreateButton(buttonContainer, "Quests", "📜", function()
UIController.OpenQuestsUI()
end)

UIController.CreateButton(buttonContainer, "Shop", "🛒", function()
UIController.OpenShopUI()
end)

UIController.CreateButton(buttonContainer, "Guild", "🏰", function()
UIController.OpenGuildUI()
end)
end

-- Create button
function UIController.CreateButton(parent, name, icon, callback)
local button = Instance.new("TextButton")
button.Name = name .. "Button"
button.Size = UDim2.new(0, 90, 0, 70)
button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
button.BorderSizePixel = 0
button.Text = ""
button.AutoButtonColor = false
button.Parent = parent

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = button

local iconLabel = Instance.new("TextLabel")
iconLabel.Size = UDim2.new(1, 0, 0.6, 0)
iconLabel.Position = UDim2.new(0, 0, 0, 0)
iconLabel.BackgroundTransparency = 1
iconLabel.Text = icon
iconLabel.TextSize = 28
iconLabel.Parent = button

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
nameLabel.Position = UDim2.new(0, 0, 0.6, 0)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = name
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.TextSize = 14
nameLabel.Font = Enum.Font.GothamBold
nameLabel.Parent = button

-- Hover effect
button.MouseEnter:Connect(function()
TweenService:Create(button, TweenInfo.new(0.2), {
BackgroundColor3 = Color3.fromRGB(80, 80, 80)
}):Play()
end)

button.MouseLeave:Connect(function()
TweenService:Create(button, TweenInfo.new(0.2), {
BackgroundColor3 = Color3.fromRGB(60, 60, 60)
}):Play()
end)

button.MouseButton1Click:Connect(callback)

return button
end

-- Create notification system
function UIController.CreateNotificationSystem()
local container = Instance.new("Frame")
container.Name = "NotificationContainer"
container.Size = UDim2.new(0, 300, 0, 400)
container.Position = UDim2.new(1, -310, 0, 70)
container.BackgroundTransparency = 1
container.Parent = UIController.ScreenGui

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 10)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = container
end

-- Show notification
function UIController.ShowNotification(notification)
local container = UIController.ScreenGui:FindFirstChild("NotificationContainer")
if not container then return end

local notif = Instance.new("Frame")
notif.Size = UDim2.new(1, 0, 0, 80)
notif.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
notif.BorderSizePixel = 0
notif.Parent = container

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = notif

-- Color based on type
local accentColor = Color3.fromRGB(100, 100, 100)
if notification.Type == "Success" then
accentColor = Color3.fromRGB(0, 200, 0)
elseif notification.Type == "Error" then
accentColor = Color3.fromRGB(200, 0, 0)
elseif notification.Type == "Warning" then
accentColor = Color3.fromRGB(255, 165, 0)
elseif notification.Type == "Info" then
accentColor = Color3.fromRGB(0, 150, 255)
end

local accent = Instance.new("Frame")
accent.Size = UDim2.new(0, 4, 1, 0)
accent.BackgroundColor3 = accentColor
accent.BorderSizePixel = 0
accent.Parent = notif

local accentCorner = Instance.new("UICorner")
accentCorner.CornerRadius = UDim.new(0, 8)
accentCorner.Parent = accent

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 25)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = notification.Title
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = notif

local message = Instance.new("TextLabel")
message.Size = UDim2.new(1, -20, 0, 45)
message.Position = UDim2.new(0, 10, 0, 30)
message.BackgroundTransparency = 1
message.Text = notification.Message
message.TextColor3 = Color3.fromRGB(200, 200, 200)
message.TextSize = 14
message.Font = Enum.Font.Gotham
message.TextXAlignment = Enum.TextXAlignment.Left
message.TextYAlignment = Enum.TextYAlignment.Top
message.TextWrapped = true
message.Parent = notif

-- Animate in
notif.Position = UDim2.new(1, 0, 0, 0)
TweenService:Create(notif, TweenInfo.new(0.3), {
Position = UDim2.new(0, 0, 0, 0)
}):Play()

-- Auto-remove after 5 seconds
task.delay(5, function()
TweenService:Create(notif, TweenInfo.new(0.3), {
Position = UDim2.new(1, 0, 0, 0)
}):Play()
task.wait(0.3)
notif:Destroy()
end)
end

-- Update coins display
function UIController.UpdateCoins(amount)
local coinsLabel = UIController.ScreenGui:FindFirstChild("MainHUD")
and UIController.ScreenGui.MainHUD:FindFirstChild("TopBar")
and UIController.ScreenGui.MainHUD.TopBar:FindFirstChild("CoinsFrame")
and UIController.ScreenGui.MainHUD.TopBar.CoinsFrame:FindFirstChild("Amount")

if coinsLabel then
coinsLabel.Text = Utilities.FormatNumber(amount)
end
end

-- Update level display
function UIController.UpdateLevel(level)
local levelLabel = UIController.ScreenGui:FindFirstChild("MainHUD")
and UIController.ScreenGui.MainHUD:FindFirstChild("TopBar")
and UIController.ScreenGui.MainHUD.TopBar:FindFirstChild("LevelFrame")
and UIController.ScreenGui.MainHUD.TopBar.LevelFrame:FindFirstChild("Level")

if levelLabel then
levelLabel.Text = "Level " .. level
end
end

-- Open Pets UI
function UIController.OpenPetsUI()
	if UIController.CurrentOpenUI then
		UIController.CurrentOpenUI.Close()
	end
	local PetInventoryUI = require(script.Parent.PetInventoryUI)
	PetInventoryUI.Open()
	UIController.CurrentOpenUI = PetInventoryUI
end

-- Open Hatch UI
function UIController.OpenHatchUI()
    if UIController.CurrentOpenUI then
    UIController.CurrentOpenUI.Close()
end
    local EggHatchUI = require(script.Parent.EggHatchUI)
    EggHatchUI.Open()
    UIController.CurrentOpenUI = EggHatchUI
end

-- Open Quests UI
function UIController.OpenQuestsUI()
print("Opening Quests UI")
UIController.ShowNotification({
Title = "Quests",
Message = "Quest UI coming soon!",
Type = "Info"
})
end

-- Open Shop UI
function UIController.OpenShopUI()
print("Opening Shop UI")
UIController.ShowNotification({
Title = "Shop",
Message = "Shop UI coming soon!",
Type = "Info"
})
end

-- Open Guild UI
function UIController.OpenGuildUI()
print("Opening Guild UI")
UIController.ShowNotification({
Title = "Guild",
Message = "Guild UI coming soon!",
Type = "Info"
})
end

-- Show hatch result
function UIController.ShowHatchResult(pet, petData)
print("Showing hatch result:", petData.Name)
end

-- Show merge result
function UIController.ShowMergeResult(mergedPet)
print("Showing merge result")
UIController.ShowNotification({
Title = "Pet Merged!",
Message = "Your pets have been merged successfully!",
Type = "Success"
})
end

-- Show trade request
function UIController.ShowTradeRequest(data)
print("Showing trade request from:", data.FromPlayer)
UIController.ShowNotification({
Title = "Trade Request",
Message = data.FromPlayer .. " wants to trade with you!",
Type = "Info"
})
end

-- Open trading UI
function UIController.OpenTradingUI(data)
print("Opening trading UI")
UIController.ShowNotification({
Title = "Trading",
Message = "Trading UI coming soon!",
Type = "Info"
})
end

-- Close trading UI
function UIController.CloseTradingUI()
print("Closing trading UI")
end

-- Update trading UI
function UIController.UpdateTradingUI(data)
print("Updating trading UI")
end

return UIController