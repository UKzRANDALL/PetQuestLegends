-- Pet Quest Legends - Egg Hatch UI
-- Handles egg selection and hatching interface

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local RemoteManager = require(ReplicatedStorage.Modules.RemoteManager)
local Utilities = require(ReplicatedStorage.Modules.Utilities)
local PetConfig = require(ReplicatedStorage.Config.PetConfig)
local WorldConfig = require(ReplicatedStorage.Config.WorldConfig)

local EggHatchUI = {}
EggHatchUI.IsOpen = false
EggHatchUI.IsHatching = false

function EggHatchUI.Create(parent)
-- Main container
local container = Instance.new("Frame")
container.Name = "EggHatchUI"
container.Size = UDim2.new(1, 0, 1, 0)
container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
container.BackgroundTransparency = 0.3
container.BorderSizePixel = 0
container.Visible = false
container.ZIndex = 100

-- Hide main HUD buttons while UI is open
local mainHUD = parent:FindFirstChild("MainHUD")
if mainHUD then
local buttonContainer = mainHUD:FindFirstChild("ButtonContainer")
if buttonContainer then
buttonContainer.Visible = false
end
end
container.Parent = parent

-- Main panel
local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, 600, 0, 500)
panel.Position = UDim2.new(0.5, -300, 0.5, -250)
panel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
panel.BorderSizePixel = 0
panel.Parent = container

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 16)
panelCorner.Parent = panel

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -40, 0, 50)
title.Position = UDim2.new(0, 20, 0, 20)
title.BackgroundTransparency = 1
title.Text = "Hatch Eggs"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 32
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -60, 0, 20)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 24
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = panel

local closeBtnCorner = Instance.new("UICorner")
closeBtnCorner.CornerRadius = UDim.new(0, 8)
closeBtnCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
EggHatchUI.Close()
end)

-- Egg selection scroll frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "EggScroll"
scrollFrame.Size = UDim2.new(1, -40, 1, -100)
scrollFrame.Position = UDim2.new(0, 20, 0, 80)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 8
scrollFrame.Parent = panel

local layout = Instance.new("UIGridLayout")
layout.CellSize = UDim2.new(0, 250, 0, 150)
layout.CellPadding = UDim2.new(0, 10, 0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = scrollFrame

return container
end

function EggHatchUI.Open()
local GameController = require(script.Parent.GameController)
local playerData = GameController.GetPlayerData()
if not playerData then return end

local container = Players.LocalPlayer.PlayerGui.PetQuestLegendsUI:FindFirstChild("EggHatchUI")
if not container then
container = EggHatchUI.Create(Players.LocalPlayer.PlayerGui.PetQuestLegendsUI)
end

-- Clear existing eggs
local scrollFrame = container.Panel.EggScroll
for _, child in ipairs(scrollFrame:GetChildren()) do
if child:IsA("Frame") then
child:Destroy()
end
end

-- Add eggs based on unlocked worlds
for _, worldId in ipairs(playerData.UnlockedWorlds) do
local worldData = WorldConfig.GetWorldData(worldId)
if worldData then
for _, eggId in ipairs(worldData.AvailableEggs) do
local eggData = WorldConfig.GetEggData(eggId)
if eggData and not eggData.Premium then
EggHatchUI.CreateEggButton(scrollFrame, eggData, playerData)
end
end
end
end

-- Update scroll canvas size
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollFrame.UIGridLayout.AbsoluteContentSize.Y + 20)

container.Visible = true
EggHatchUI.IsOpen = true

-- Animate in
container.Panel.Position = UDim2.new(0.5, -300, 1, 0)
TweenService:Create(container.Panel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
Position = UDim2.new(0.5, -300, 0.5, -250)
}):Play()
end

function EggHatchUI.CreateEggButton(parent, eggData, playerData, isPremium)
local button = Instance.new("Frame")
button.Name = eggData.Name
button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
button.BorderSizePixel = 0

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = button

-- Egg name
local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, -10, 0, 25)
nameLabel.Position = UDim2.new(0, 5, 0, 10)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = eggData.Name
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.TextSize = 16
nameLabel.Font = Enum.Font.GothamBold
nameLabel.Parent = button

-- Cost/Status
local costLabel = Instance.new("TextLabel")
costLabel.Size = UDim2.new(1, -10, 0, 20)
costLabel.Position = UDim2.new(0, 5, 0, 40)
costLabel.BackgroundTransparency = 1
costLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
costLabel.TextSize = 14
costLabel.Font = Enum.Font.Gotham
costLabel.Parent = button

if isPremium then
costLabel.Text = "Premium Egg"
costLabel.TextColor3 = Color3.fromRGB(255, 100, 255)
else
costLabel.Text = "Cost: " .. Utilities.FormatNumber(eggData.Cost)
end

-- Hatch button
local hatchBtn = Instance.new("TextButton")
hatchBtn.Size = UDim2.new(0.8, 0, 0, 30)
hatchBtn.Position = UDim2.new(0.1, 0, 1, -40)
hatchBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
hatchBtn.BorderSizePixel = 0
hatchBtn.Text = "HATCH"
hatchBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
hatchBtn.TextSize = 16
hatchBtn.Font = Enum.Font.GothamBold
hatchBtn.Parent = button

local hatchCorner = Instance.new("UICorner")
hatchCorner.CornerRadius = UDim.new(0, 8)
hatchCorner.Parent = hatchBtn

-- Check if can afford
if not isPremium and playerData.Coins < eggData.Cost then
hatchBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
hatchBtn.Text = "NOT ENOUGH COINS"
hatchBtn.TextSize = 12
else
hatchBtn.MouseButton1Click:Connect(function()
if not EggHatchUI.IsHatching then
EggHatchUI.HatchEgg(eggData)
end
end)

-- Hover effect
hatchBtn.MouseEnter:Connect(function()
TweenService:Create(hatchBtn, TweenInfo.new(0.2), {
BackgroundColor3 = Color3.fromRGB(120, 220, 120)
}):Play()
end)

hatchBtn.MouseLeave:Connect(function()
TweenService:Create(hatchBtn, TweenInfo.new(0.2), {
BackgroundColor3 = Color3.fromRGB(100, 200, 100)
}):Play()
end)
end

button.Parent = parent
end

function EggHatchUI.HatchEgg(eggData)
EggHatchUI.IsHatching = true

-- Close egg selection
local container = Players.LocalPlayer.PlayerGui.PetQuestLegendsUI:FindFirstChild("EggHatchUI")
if container then
container.Panel.Visible = false
end

-- Create hatching animation screen
local hatchScreen = Instance.new("Frame")
hatchScreen.Name = "HatchScreen"
hatchScreen.Size = UDim2.new(1, 0, 1, 0)
hatchScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
hatchScreen.BackgroundTransparency = 0.3
hatchScreen.BorderSizePixel = 0
hatchScreen.ZIndex = 100
hatchScreen.Parent = container

-- Egg display
local eggDisplay = Instance.new("TextLabel")
eggDisplay.Name = "Egg"
eggDisplay.Size = UDim2.new(0, 200, 0, 200)
eggDisplay.Position = UDim2.new(0.5, -100, 0.5, -100)
eggDisplay.BackgroundTransparency = 1
eggDisplay.Text = "??"
eggDisplay.TextSize = 120
eggDisplay.Parent = hatchScreen

-- Hatching text
local hatchText = Instance.new("TextLabel")
hatchText.Size = UDim2.new(0, 400, 0, 50)
hatchText.Position = UDim2.new(0.5, -200, 0.5, 150)
hatchText.BackgroundTransparency = 1
hatchText.Text = "Hatching..."
hatchText.TextColor3 = Color3.fromRGB(255, 255, 255)
hatchText.TextSize = 32
hatchText.Font = Enum.Font.GothamBold
hatchText.Parent = hatchScreen

-- Animate egg shaking
local shakeCount = 0
local function shakeEgg()
shakeCount = shakeCount + 1
local rotation = math.random(-15, 15)
local shakeTween = TweenService:Create(eggDisplay, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
Rotation = rotation
})
shakeTween:Play()
shakeTween.Completed:Connect(function()
if shakeCount < 10 then
task.wait(0.1)
shakeEgg()
end
end)
end

shakeEgg()

-- Request hatch from server
local eggId = eggData.Name:gsub(" ", "")
local result = RemoteManager.InvokeServer("HatchEgg", eggId)

task.wait(1.5)

if result and result.Success then
EggHatchUI.ShowHatchResult(hatchScreen, result.Pet, result.PetData)
else
hatchText.Text = result and result.Error or "Failed to hatch egg"
hatchText.TextColor3 = Color3.fromRGB(255, 100, 100)
task.wait(2)
hatchScreen:Destroy()
EggHatchUI.IsHatching = false
if container then
container.Panel.Visible = true
end
end
end

function EggHatchUI.ShowHatchResult(hatchScreen, pet, petData)
-- Clear egg
local eggDisplay = hatchScreen:FindFirstChild("Egg")
if eggDisplay then
TweenService:Create(eggDisplay, TweenInfo.new(0.3), {
TextTransparency = 1,
Size = UDim2.new(0, 250, 0, 250)
}):Play()
task.wait(0.3)
eggDisplay:Destroy()
end

-- Create result panel
local resultPanel = Instance.new("Frame")
resultPanel.Name = "ResultPanel"
resultPanel.Size = UDim2.new(0, 500, 0, 400)
resultPanel.Position = UDim2.new(0.5, -250, 0.5, -200)
resultPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
resultPanel.BorderSizePixel = 0
resultPanel.Parent = hatchScreen

local resultCorner = Instance.new("UICorner")
resultCorner.CornerRadius = UDim.new(0, 16)
resultCorner.Parent = resultPanel

-- Rarity color border
local rarityData = PetConfig.Rarities[petData.Rarity]
local border = Instance.new("UIStroke")
border.Color = rarityData.Color
border.Thickness = 4
border.Parent = resultPanel

-- Congratulations text
local congrats = Instance.new("TextLabel")
congrats.Size = UDim2.new(1, 0, 0, 60)
congrats.Position = UDim2.new(0, 0, 0, 20)
congrats.BackgroundTransparency = 1
congrats.Text = "*** YOU HATCHED! ***"
congrats.TextColor3 = Color3.fromRGB(255, 255, 255)
congrats.TextSize = 28
congrats.Font = Enum.Font.GothamBold
congrats.Parent = resultPanel

-- Pet display
local petDisplay = Instance.new("Frame")
petDisplay.Size = UDim2.new(0, 150, 0, 150)
petDisplay.Position = UDim2.new(0.5, -75, 0, 90)
petDisplay.BackgroundColor3 = rarityData.Color
petDisplay.BorderSizePixel = 0
petDisplay.Parent = resultPanel

local petCorner = Instance.new("UICorner")
petCorner.CornerRadius = UDim.new(1, 0)
petCorner.Parent = petDisplay

-- Pet name
local petName = Instance.new("TextLabel")
petName.Size = UDim2.new(1, -40, 0, 40)
petName.Position = UDim2.new(0, 20, 0, 250)
petName.BackgroundTransparency = 1
petName.Text = petData.Name
petName.TextColor3 = rarityData.Color
petName.TextSize = 24
petName.Font = Enum.Font.GothamBold
petName.Parent = resultPanel

-- Rarity
local rarityLabel = Instance.new("TextLabel")
rarityLabel.Size = UDim2.new(1, -40, 0, 25)
rarityLabel.Position = UDim2.new(0, 20, 0, 290)
rarityLabel.BackgroundTransparency = 1
rarityLabel.Text = petData.Rarity
rarityLabel.TextColor3 = rarityData.Color
rarityLabel.TextSize = 18
rarityLabel.Font = Enum.Font.Gotham
rarityLabel.Parent = resultPanel

-- Continue button
local continueBtn = Instance.new("TextButton")
continueBtn.Size = UDim2.new(0, 200, 0, 45)
continueBtn.Position = UDim2.new(0.5, -100, 1, -65)
continueBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
continueBtn.BorderSizePixel = 0
continueBtn.Text = "CONTINUE"
continueBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
continueBtn.TextSize = 18
continueBtn.Font = Enum.Font.GothamBold
continueBtn.Parent = resultPanel

local continueCorner = Instance.new("UICorner")
continueCorner.CornerRadius = UDim.new(0, 10)
continueCorner.Parent = continueBtn

continueBtn.MouseButton1Click:Connect(function()
hatchScreen:Destroy()
EggHatchUI.IsHatching = false
EggHatchUI.Open()
end)

-- Animate in
resultPanel.Size = UDim2.new(0, 0, 0, 0)
resultPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
TweenService:Create(resultPanel, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
Size = UDim2.new(0, 500, 0, 400),
Position = UDim2.new(0.5, -250, 0.5, -200)
}):Play()
end

function EggHatchUI.Close()
local container = Players.LocalPlayer.PlayerGui.PetQuestLegendsUI:FindFirstChild("EggHatchUI")
if container then
TweenService:Create(container.Panel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
Position = UDim2.new(0.5, -300, 1, 0)
}):Play()
task.wait(0.3)
container.Visible = false
EggHatchUI.IsOpen = false

-- Show main HUD buttons again
local parent = container.Parent
if parent then
local mainHUD = parent:FindFirstChild("MainHUD")
if mainHUD then
local buttonContainer = mainHUD:FindFirstChild("ButtonContainer")
if buttonContainer then
buttonContainer.Visible = true
end
end
end

-- Show main HUD buttons again
local parent = container.Parent
if parent then
local mainHUD = parent:FindFirstChild("MainHUD")
if mainHUD then
local buttonContainer = mainHUD:FindFirstChild("ButtonContainer")
if buttonContainer then
buttonContainer.Visible = true
end
end
end
end
end

return EggHatchUI



