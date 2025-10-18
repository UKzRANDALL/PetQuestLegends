-- Pet Quest Legends - Pet Inventory UI
-- Handles viewing, equipping, and managing pets

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local RemoteManager = require(ReplicatedStorage.Modules.RemoteManager)
local Utilities = require(ReplicatedStorage.Modules.Utilities)
local PetConfig = require(ReplicatedStorage.Config.PetConfig)

local PetInventoryUI = {}
PetInventoryUI.IsOpen = false
PetInventoryUI.SelectedPets = {}

function PetInventoryUI.Create(parent)
local container = Instance.new("Frame")
container.Name = "PetInventoryUI"
container.Size = UDim2.new(1, 0, 1, 0)
container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
container.BackgroundTransparency = 0.5
container.BorderSizePixel = 0
container.Visible = false
container.ZIndex = 10
container.Parent = parent

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0, 800, 0, 600)
panel.Position = UDim2.new(0.5, -400, 0.5, -300)
panel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
panel.BorderSizePixel = 0
panel.Parent = container

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 16)
panelCorner.Parent = panel

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -40, 0, 50)
title.Position = UDim2.new(0, 20, 0, 20)
title.BackgroundTransparency = 1
title.Text = "My Pets"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 32
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = panel

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
PetInventoryUI.Close()
end)

local filterFrame = Instance.new("Frame")
filterFrame.Name = "FilterFrame"
filterFrame.Size = UDim2.new(1, -40, 0, 40)
filterFrame.Position = UDim2.new(0, 20, 0, 80)
filterFrame.BackgroundTransparency = 1
filterFrame.Parent = panel

local filterLayout = Instance.new("UIListLayout")
filterLayout.FillDirection = Enum.FillDirection.Horizontal
filterLayout.Padding = UDim.new(0, 10)
filterLayout.Parent = filterFrame

PetInventoryUI.CreateFilterButton(filterFrame, "All", true)
PetInventoryUI.CreateFilterButton(filterFrame, "Equipped", false)
PetInventoryUI.CreateFilterButton(filterFrame, "Common", false)
PetInventoryUI.CreateFilterButton(filterFrame, "Rare", false)
PetInventoryUI.CreateFilterButton(filterFrame, "Epic", false)
PetInventoryUI.CreateFilterButton(filterFrame, "Legendary", false)
PetInventoryUI.CreateFilterButton(filterFrame, "Mythical", false)

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Name = "PetScroll"
scrollFrame.Size = UDim2.new(1, -40, 1, -220)
scrollFrame.Position = UDim2.new(0, 20, 0, 130)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 8
scrollFrame.Parent = panel

local layout = Instance.new("UIGridLayout")
layout.CellSize = UDim2.new(0, 150, 0, 180)
layout.CellPadding = UDim2.new(0, 10, 0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
layout.Parent = scrollFrame

local actionFrame = Instance.new("Frame")
actionFrame.Name = "ActionFrame"
actionFrame.Size = UDim2.new(1, -40, 0, 60)
actionFrame.Position = UDim2.new(0, 20, 1, -80)
actionFrame.BackgroundTransparency = 1
actionFrame.Parent = panel

local actionLayout = Instance.new("UIListLayout")
actionLayout.FillDirection = Enum.FillDirection.Horizontal
actionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
actionLayout.Padding = UDim.new(0, 20)
actionLayout.Parent = actionFrame

local mergeBtn = Instance.new("TextButton")
mergeBtn.Name = "MergeButton"
mergeBtn.Size = UDim2.new(0, 200, 0, 50)
mergeBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 200)
mergeBtn.BorderSizePixel = 0
mergeBtn.Text = "MERGE (Select 2)"
mergeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
mergeBtn.TextSize = 18
mergeBtn.Font = Enum.Font.GothamBold
mergeBtn.Parent = actionFrame

local mergeBtnCorner = Instance.new("UICorner")
mergeBtnCorner.CornerRadius = UDim.new(0, 10)
mergeBtnCorner.Parent = mergeBtn

mergeBtn.MouseButton1Click:Connect(function()
PetInventoryUI.MergeSelectedPets()
end)

local equipAllBtn = Instance.new("TextButton")
equipAllBtn.Name = "EquipAllButton"
equipAllBtn.Size = UDim2.new(0, 200, 0, 50)
equipAllBtn.BackgroundColor3 = Color3.fromRGB(100, 150, 250)
equipAllBtn.BorderSizePixel = 0
equipAllBtn.Text = "EQUIP BEST"
equipAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
equipAllBtn.TextSize = 18
equipAllBtn.Font = Enum.Font.GothamBold
equipAllBtn.Parent = actionFrame

local equipAllBtnCorner = Instance.new("UICorner")
equipAllBtnCorner.CornerRadius = UDim.new(0, 10)
equipAllBtnCorner.Parent = equipAllBtn

equipAllBtn.MouseButton1Click:Connect(function()
PetInventoryUI.EquipBestPets()
end)

return container
end

function PetInventoryUI.CreateFilterButton(parent, filterName, isActive)
local button = Instance.new("TextButton")
button.Name = filterName .. "Filter"
button.Size = UDim2.new(0, 80, 0, 35)
button.BackgroundColor3 = isActive and Color3.fromRGB(100, 150, 250) or Color3.fromRGB(60, 60, 60)
button.BorderSizePixel = 0
button.Text = filterName
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.TextSize = 14
button.Font = Enum.Font.GothamBold
button.Parent = parent

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = button

button.MouseButton1Click:Connect(function()
PetInventoryUI.ApplyFilter(filterName)

for _, btn in ipairs(parent:GetChildren()) do
if btn:IsA("TextButton") then
btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
end
end
button.BackgroundColor3 = Color3.fromRGB(100, 150, 250)
end)

return button
end

function PetInventoryUI.Open()
local GameController = require(script.Parent.GameController)
local playerData = GameController.GetPlayerData()
if not playerData then return end

local container = Players.LocalPlayer.PlayerGui.PetQuestLegendsUI:FindFirstChild("PetInventoryUI")
if not container then
container = PetInventoryUI.Create(Players.LocalPlayer.PlayerGui.PetQuestLegendsUI)
end

PetInventoryUI.SelectedPets = {}
PetInventoryUI.RefreshPetList("All")

container.Visible = true
PetInventoryUI.IsOpen = true

container.Panel.Position = UDim2.new(0.5, -400, 1, 0)
TweenService:Create(container.Panel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
Position = UDim2.new(0.5, -400, 0.5, -300)
}):Play()
end

function PetInventoryUI.RefreshPetList(filter)
local GameController = require(script.Parent.GameController)
local playerData = GameController.GetPlayerData()
if not playerData then return end

local container = Players.LocalPlayer.PlayerGui.PetQuestLegendsUI:FindFirstChild("PetInventoryUI")
if not container then return end

local scrollFrame = container.Panel.PetScroll

for _, child in ipairs(scrollFrame:GetChildren()) do
if child:IsA("Frame") then
child:Destroy()
end
end

local filteredPets = {}
for _, pet in ipairs(playerData.Pets) do
local petData = PetConfig.GetPetData(pet.PetId)
if petData then
local shouldShow = false

if filter == "All" then
shouldShow = true
elseif filter == "Equipped" then
shouldShow = pet.Equipped
else
shouldShow = petData.Rarity == filter
end

if shouldShow then
table.insert(filteredPets, {Pet = pet, PetData = petData})
end
end
end

table.sort(filteredPets, function(a, b)
local rarityOrder = {Common = 1, Rare = 2, Epic = 3, Legendary = 4, Mythical = 5}
if rarityOrder[a.PetData.Rarity] ~= rarityOrder[b.PetData.Rarity] then
return rarityOrder[a.PetData.Rarity] > rarityOrder[b.PetData.Rarity]
end
return a.Pet.MergeLevel > b.Pet.MergeLevel
end)

for _, petInfo in ipairs(filteredPets) do
PetInventoryUI.CreatePetCard(scrollFrame, petInfo.Pet, petInfo.PetData)
end

scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollFrame.UIGridLayout.AbsoluteContentSize.Y + 20)
end

function PetInventoryUI.CreatePetCard(parent, pet, petData)
local card = Instance.new("Frame")
card.Name = pet.Id
card.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
card.BorderSizePixel = 0

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = card

local rarityData = PetConfig.Rarities[petData.Rarity]
local border = Instance.new("UIStroke")
border.Color = rarityData.Color
border.Thickness = 3
border.Parent = card

if pet.Equipped then
local equippedBadge = Instance.new("Frame")
equippedBadge.Size = UDim2.new(0, 60, 0, 20)
equippedBadge.Position = UDim2.new(0, 5, 0, 5)
equippedBadge.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
equippedBadge.BorderSizePixel = 0
equippedBadge.ZIndex = 2
equippedBadge.Parent = card

local badgeCorner = Instance.new("UICorner")
badgeCorner.CornerRadius = UDim.new(0, 4)
badgeCorner.Parent = equippedBadge

local badgeText = Instance.new("TextLabel")
badgeText.Size = UDim2.new(1, 0, 1, 0)
badgeText.BackgroundTransparency = 1
badgeText.Text = "EQUIPPED"
badgeText.TextColor3 = Color3.fromRGB(255, 255, 255)
badgeText.TextSize = 10
badgeText.Font = Enum.Font.GothamBold
badgeText.Parent = equippedBadge
end

local petDisplay = Instance.new("Frame")
petDisplay.Size = UDim2.new(0, 80, 0, 80)
petDisplay.Position = UDim2.new(0.5, -40, 0, 10)
petDisplay.BackgroundColor3 = rarityData.Color
petDisplay.BorderSizePixel = 0
petDisplay.Parent = card

local petCorner = Instance.new("UICorner")
petCorner.CornerRadius = UDim.new(1, 0)
petCorner.Parent = petDisplay

if pet.MergeLevel > 0 then
local mergeLabel = Instance.new("TextLabel")
mergeLabel.Size = UDim2.new(1, 0, 1, 0)
mergeLabel.BackgroundTransparency = 1
mergeLabel.Text = "+" .. pet.MergeLevel
mergeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
mergeLabel.TextSize = 24
mergeLabel.Font = Enum.Font.GothamBold
mergeLabel.TextStrokeTransparency = 0.5
mergeLabel.Parent = petDisplay
end

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, -10, 0, 20)
nameLabel.Position = UDim2.new(0, 5, 0, 95)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = petData.Name
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.TextSize = 12
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
nameLabel.Parent = card

local rarityLabel = Instance.new("TextLabel")
rarityLabel.Size = UDim2.new(1, -10, 0, 15)
rarityLabel.Position = UDim2.new(0, 5, 0, 115)
rarityLabel.BackgroundTransparency = 1
rarityLabel.Text = petData.Rarity
rarityLabel.TextColor3 = rarityData.Color
rarityLabel.TextSize = 10
rarityLabel.Font = Enum.Font.Gotham
rarityLabel.Parent = card

local actionBtn = Instance.new("TextButton")
actionBtn.Size = UDim2.new(0.9, 0, 0, 30)
actionBtn.Position = UDim2.new(0.05, 0, 1, -35)
actionBtn.BorderSizePixel = 0
actionBtn.TextSize = 12
actionBtn.Font = Enum.Font.GothamBold
actionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
actionBtn.Parent = card

local actionCorner = Instance.new("UICorner")
actionCorner.CornerRadius = UDim.new(0, 6)
actionCorner.Parent = actionBtn

if pet.Equipped then
actionBtn.Text = "UNEQUIP"
actionBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
actionBtn.MouseButton1Click:Connect(function()
PetInventoryUI.UnequipPet(pet.Id)
end)
else
actionBtn.Text = "EQUIP"
actionBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
actionBtn.MouseButton1Click:Connect(function()
PetInventoryUI.EquipPet(pet.Id)
end)
end

local selectBtn = Instance.new("TextButton")
selectBtn.Size = UDim2.new(0, 30, 0, 30)
selectBtn.Position = UDim2.new(1, -35, 0, 5)
selectBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
selectBtn.BorderSizePixel = 0
selectBtn.Text = ""
selectBtn.ZIndex = 2
selectBtn.Parent = card

local selectCorner = Instance.new("UICorner")
selectCorner.CornerRadius = UDim.new(1, 0)
selectCorner.Parent = selectBtn

local checkmark = Instance.new("TextLabel")
checkmark.Size = UDim2.new(1, 0, 1, 0)
checkmark.BackgroundTransparency = 1
checkmark.Text = ""
checkmark.TextColor3 = Color3.fromRGB(255, 255, 255)
checkmark.TextSize = 20
checkmark.Font = Enum.Font.GothamBold
checkmark.Parent = selectBtn

selectBtn.MouseButton1Click:Connect(function()
PetInventoryUI.ToggleSelection(pet.Id, selectBtn, checkmark)
end)

card.Parent = parent
end

function PetInventoryUI.ToggleSelection(petId, button, checkmark)
local index = table.find(PetInventoryUI.SelectedPets, petId)

if index then
table.remove(PetInventoryUI.SelectedPets, index)
button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
checkmark.Text = ""
else
if #PetInventoryUI.SelectedPets < 2 then
table.insert(PetInventoryUI.SelectedPets, petId)
button.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
checkmark.Text = "?"
else
local UIController = require(script.Parent.UIController)
UIController.ShowNotification({
Title = "Selection Limit",
Message = "You can only select 2 pets to merge!",
Type = "Warning"
})
end
end
end

function PetInventoryUI.EquipPet(petId)
local result = RemoteManager.InvokeServer("EquipPet", petId)
if result and result.Success then
PetInventoryUI.RefreshPetList("All")
else
local UIController = require(script.Parent.UIController)
UIController.ShowNotification({
Title = "Cannot Equip",
Message = result.Error or "Failed to equip pet",
Type = "Error"
})
end
end

function PetInventoryUI.UnequipPet(petId)
local result = RemoteManager.InvokeServer("UnequipPet", petId)
if result and result.Success then
PetInventoryUI.RefreshPetList("All")
else
local UIController = require(script.Parent.UIController)
UIController.ShowNotification({
Title = "Cannot Unequip",
Message = "Failed to unequip pet",
Type = "Error"
})
end
end

function PetInventoryUI.MergeSelectedPets()
if #PetInventoryUI.SelectedPets ~= 2 then
local UIController = require(script.Parent.UIController)
UIController.ShowNotification({
Title = "Select 2 Pets",
Message = "You must select exactly 2 pets to merge!",
Type = "Warning"
})
return
end

local result = RemoteManager.InvokeServer("MergePets", PetInventoryUI.SelectedPets[1], PetInventoryUI.SelectedPets[2])

if result and result.Success then
PetInventoryUI.SelectedPets = {}
PetInventoryUI.RefreshPetList("All")

local UIController = require(script.Parent.UIController)
UIController.ShowNotification({
Title = "Pets Merged!",
Message = "Your pets have been merged successfully!",
Type = "Success"
})
else
local UIController = require(script.Parent.UIController)
UIController.ShowNotification({
Title = "Merge Failed",
Message = result.Error or "Failed to merge pets",
Type = "Error"
})
end
end

function PetInventoryUI.EquipBestPets()
local GameController = require(script.Parent.GameController)
local playerData = GameController.GetPlayerData()
if not playerData then return end

local sortedPets = {}
for _, pet in ipairs(playerData.Pets) do
local petData = PetConfig.GetPetData(pet.PetId)
if petData and not pet.Equipped then
local value = PetConfig.CalculatePetValue(pet.PetId, pet.MergeLevel)
table.insert(sortedPets, {Pet = pet, Value = value})
end
end

table.sort(sortedPets, function(a, b)
return a.Value > b.Value
end)

local maxSlots = playerData.MaxEquippedPets or 8
local equipped = 0

for _, petInfo in ipairs(sortedPets) do
if equipped >= maxSlots then break end

local result = RemoteManager.InvokeServer("EquipPet", petInfo.Pet.Id)
if result and result.Success then
equipped = equipped + 1
end
end

PetInventoryUI.RefreshPetList("All")

local UIController = require(script.Parent.UIController)
UIController.ShowNotification({
Title = "Equipped Best Pets",
Message = "Equipped " .. equipped .. " of your best pets!",
Type = "Success"
})
end

function PetInventoryUI.ApplyFilter(filter)
PetInventoryUI.RefreshPetList(filter)
end

function PetInventoryUI.Close()
local container = Players.LocalPlayer.PlayerGui.PetQuestLegendsUI:FindFirstChild("PetInventoryUI")
if container then
TweenService:Create(container.Panel, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
Position = UDim2.new(0.5, -400, 1, 0)
}):Play()
task.wait(0.3)
container.Visible = false
PetInventoryUI.IsOpen = false
PetInventoryUI.SelectedPets = {}
end
end

return PetInventoryUI
