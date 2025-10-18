-- Pet Quest Legends - Shop UI
-- Handles display and purchase of gamepasses, eggs, boosts, and skins

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

local RemoteManager = require(ReplicatedStorage.Modules.RemoteManager)
local GamepassConfig = require(ReplicatedStorage.Config.GamepassConfig)
local Utilities = require(ReplicatedStorage.Modules.Utilities)

local ShopUI = {}
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- UI References
local screenGui = nil
local currentTab = "Gamepasses"

-- Colors
local COLORS = {
    Background = Color3.fromRGB(30, 30, 40),
    Header = Color3.fromRGB(40, 40, 50),
    Item = Color3.fromRGB(50, 50, 60),
    ItemHover = Color3.fromRGB(60, 60, 70),
    Button = Color3.fromRGB(0, 170, 0),
    ButtonHover = Color3.fromRGB(0, 200, 0),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    Owned = Color3.fromRGB(100, 100, 100),
}

function ShopUI.Init()
    print("[ShopUI] Initialized")
end

function ShopUI.Show()
    if screenGui then
        screenGui:Destroy()
    end
    
    ShopUI.CreateMainUI()
end

function ShopUI.Hide()
    if screenGui then
        screenGui:Destroy()
        screenGui = nil
    end
end

function ShopUI.CreateMainUI()
    -- Main ScreenGui
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ShopUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui
    
    -- Background overlay
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.BorderSizePixel = 0
    overlay.Parent = screenGui
    
    -- Main container
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(0, 900, 0, 650)
    container.Position = UDim2.new(0.5, -450, 0.5, -325)
    container.BackgroundColor3 = COLORS.Background
    container.BorderSizePixel = 0
    container.Parent = screenGui
    
    -- Add rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = container
    
    -- Header
    ShopUI.CreateHeader(container)
    
    -- Tab buttons
    ShopUI.CreateTabs(container)
    
    -- Content area
    ShopUI.CreateContent(container)
    
    -- Load initial tab
    ShopUI.LoadTab("Gamepasses")
end

function ShopUI.CreateHeader(parent)
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 70)
    header.BackgroundColor3 = COLORS.Header
    header.BorderSizePixel = 0
    header.Parent = parent
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 12)
    headerCorner.Parent = header
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(0, 400, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🛒 SHOP"
    title.TextColor3 = COLORS.Text
    title.TextSize = 36
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Close button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 50, 0, 50)
    closeButton.Position = UDim2.new(1, -60, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "✕"
    closeButton.TextColor3 = COLORS.Text
    closeButton.TextSize = 28
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = header
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        ShopUI.Hide()
    end)
    
    -- Hover effect
    closeButton.MouseEnter:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
    end)
    closeButton.MouseLeave:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end)
end

function ShopUI.CreateTabs(parent)
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, -40, 0, 50)
    tabContainer.Position = UDim2.new(0, 20, 0, 80)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = parent
    
    local tabs = {"Gamepasses", "Premium Eggs", "Boosts", "Pet Skins"}
    local tabWidth = 1 / #tabs
    
    for i, tabName in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName .. "Tab"
        tabButton.Size = UDim2.new(tabWidth, -10, 1, 0)
        tabButton.Position = UDim2.new(tabWidth * (i - 1), 5, 0, 0)
        tabButton.BackgroundColor3 = COLORS.Item
        tabButton.BorderSizePixel = 0
        tabButton.Text = tabName
        tabButton.TextColor3 = COLORS.Text
        tabButton.TextSize = 18
        tabButton.Font = Enum.Font.GothamBold
        tabButton.Parent = tabContainer
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabButton
        
        tabButton.MouseButton1Click:Connect(function()
            ShopUI.LoadTab(tabName)
        end)
        
        -- Hover effects
        tabButton.MouseEnter:Connect(function()
            if currentTab ~= tabName then
                tabButton.BackgroundColor3 = COLORS.ItemHover
            end
        end)
        tabButton.MouseLeave:Connect(function()
            if currentTab ~= tabName then
                tabButton.BackgroundColor3 = COLORS.Item
            end
        end)
    end
end

function ShopUI.CreateContent(parent)
    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -40, 1, -160)
    content.Position = UDim2.new(0, 20, 0, 140)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 8
    content.ScrollBarImageColor3 = COLORS.Text
    content.Parent = parent
end

function ShopUI.LoadTab(tabName)
    currentTab = tabName
    
    -- Update tab button colors
    local tabContainer = screenGui.Container.TabContainer
    for _, child in ipairs(tabContainer:GetChildren()) do
        if child:IsA("TextButton") then
            if child.Name == tabName .. "Tab" then
                child.BackgroundColor3 = COLORS.Button
            else
                child.BackgroundColor3 = COLORS.Item
            end
        end
    end
    
    -- Clear content
    local content = screenGui.Container.Content
    for _, child in ipairs(content:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
    
    -- Load appropriate content
    if tabName == "Gamepasses" then
        ShopUI.LoadGamepasses(content)
    elseif tabName == "Premium Eggs" then
        ShopUI.LoadPremiumEggs(content)
    elseif tabName == "Boosts" then
        ShopUI.LoadBoosts(content)
    elseif tabName == "Pet Skins" then
        ShopUI.LoadPetSkins(content)
    end
end

function ShopUI.CreateTabs(parent)
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, -40, 0, 50)
    tabContainer.Position = UDim2.new(0, 20, 0, 80)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = parent
    
    local tabs = {"Gamepasses", "Premium Eggs", "Boosts", "Pet Skins"}
    local tabWidth = 1 / #tabs
    
    for i, tabName in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName .. "Tab"
        tabButton.Size = UDim2.new(tabWidth, -10, 1, 0)
        tabButton.Position = UDim2.new(tabWidth * (i - 1), 5, 0, 0)
        tabButton.BackgroundColor3 = COLORS.Item
        tabButton.BorderSizePixel = 0
        tabButton.Text = tabName
        tabButton.TextColor3 = COLORS.Text
        tabButton.TextSize = 18
        tabButton.Font = Enum.Font.GothamBold
        tabButton.Parent = tabContainer
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 8)
        tabCorner.Parent = tabButton
        
        tabButton.MouseButton1Click:Connect(function()
            ShopUI.LoadTab(tabName)
        end)
        
        -- Hover effects
        tabButton.MouseEnter:Connect(function()
            if currentTab ~= tabName then
                tabButton.BackgroundColor3 = COLORS.ItemHover
            end
        end)
        tabButton.MouseLeave:Connect(function()
            if currentTab ~= tabName then
                tabButton.BackgroundColor3 = COLORS.Item
            end
        end)
    end
end

function ShopUI.CreateContent(parent)
    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -40, 1, -160)
    content.Position = UDim2.new(0, 20, 0, 140)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 8
    content.ScrollBarImageColor3 = COLORS.Text
    content.Parent = parent
end

function ShopUI.LoadTab(tabName)
    currentTab = tabName
    
    -- Update tab button colors
    local tabContainer = screenGui.Container.TabContainer
    for _, child in ipairs(tabContainer:GetChildren()) do
        if child:IsA("TextButton") then
            if child.Name == tabName .. "Tab" then
                child.BackgroundColor3 = COLORS.Button
            else
                child.BackgroundColor3 = COLORS.Item
            end
        end
    end
    
    -- Clear content
    local content = screenGui.Container.Content
    for _, child in ipairs(content:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
    
    -- Load appropriate content
    if tabName == "Gamepasses" then
        ShopUI.LoadGamepasses(content)
    elseif tabName == "Premium Eggs" then
        ShopUI.LoadPremiumEggs(content)
    elseif tabName == "Boosts" then
        ShopUI.LoadBoosts(content)
    elseif tabName == "Pet Skins" then
        ShopUI.LoadPetSkins(content)
    end
end

function ShopUI.LoadGamepasses(parent)
    local yOffset = 0
    
    for name, data in pairs(GamepassConfig.Gamepasses) do
        local item = ShopUI.CreateShopItem(parent, {
            Name = data.Name,
            Description = data.Description,
            Price = data.Price,
            Icon = data.Icon or "rbxassetid://0",
            ProductId = data.Id,
            ProductType = "Gamepass",
            YOffset = yOffset
        })
        
        yOffset = yOffset + 120
    end
    
    parent.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

function ShopUI.LoadPremiumEggs(parent)
    local yOffset = 0
    
    for name, data in pairs(GamepassConfig.PremiumEggs) do
        local item = ShopUI.CreateShopItem(parent, {
            Name = data.Name,
            Description = data.Description,
            Price = data.Price,
            Icon = data.Icon or "rbxassetid://0",
            ProductId = data.Id,
            ProductType = "Product",
            YOffset = yOffset
        })
        
        yOffset = yOffset + 120
    end
    
    parent.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

function ShopUI.LoadBoosts(parent)
    local yOffset = 0
    
    for name, data in pairs(GamepassConfig.Boosts) do
        local item = ShopUI.CreateShopItem(parent, {
            Name = data.Name,
            Description = data.Description,
            Price = data.Price,
            Icon = data.Icon or "rbxassetid://0",
            ProductId = data.Id,
            ProductType = "Product",
            YOffset = yOffset
        })
        
        yOffset = yOffset + 120
    end
    
    parent.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

function ShopUI.LoadPetSkins(parent)
    local yOffset = 0
    
    for name, data in pairs(GamepassConfig.PetSkins) do
        local item = ShopUI.CreateShopItem(parent, {
            Name = data.Name,
            Description = data.Description,
            Price = data.Price,
            Icon = data.Icon or "rbxassetid://0",
            ProductId = data.Id,
            ProductType = "Product",
            YOffset = yOffset
        })
        
        yOffset = yOffset + 120
    end
    
    parent.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

function ShopUI.CreateShopItem(parent, config)
    local item = Instance.new("Frame")
    item.Name = config.Name
    item.Size = UDim2.new(1, -20, 0, 110)
    item.Position = UDim2.new(0, 10, 0, config.YOffset)
    item.BackgroundColor3 = COLORS.Item
    item.BorderSizePixel = 0
    item.Parent = parent
    
    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 10)
    itemCorner.Parent = item
    
    -- Icon
    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 80, 0, 80)
    icon.Position = UDim2.new(0, 15, 0, 15)
    icon.BackgroundColor3 = COLORS.Background
    icon.BorderSizePixel = 0
    icon.Image = config.Icon
    icon.Parent = item
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 8)
    iconCorner.Parent = icon
    
    -- Name
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(0, 450, 0, 30)
    nameLabel.Position = UDim2.new(0, 110, 0, 15)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = config.Name
    nameLabel.TextColor3 = COLORS.Text
    nameLabel.TextSize = 22
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = item
    
    -- Description
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "DescLabel"
    descLabel.Size = UDim2.new(0, 450, 0, 50)
    descLabel.Position = UDim2.new(0, 110, 0, 45)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = config.Description
    descLabel.TextColor3 = COLORS.TextSecondary
    descLabel.TextSize = 16
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true
    descLabel.Parent = item
    
    -- Buy button
    local buyButton = Instance.new("TextButton")
    buyButton.Name = "BuyButton"
    buyButton.Size = UDim2.new(0, 180, 0, 50)
    buyButton.Position = UDim2.new(1, -195, 0.5, -25)
    buyButton.BackgroundColor3 = COLORS.Button
    buyButton.BorderSizePixel = 0
    buyButton.Text = "💎 Buy for " .. config.Price .. " R$"
    buyButton.TextColor3 = COLORS.Text
    buyButton.TextSize = 18
    buyButton.Font = Enum.Font.GothamBold
    buyButton.Parent = item
    
    local buyCorner = Instance.new("UICorner")
    buyCorner.CornerRadius = UDim.new(0, 8)
    buyCorner.Parent = buyButton
    
    -- Check if owned (for gamepasses)
    if config.ProductType == "Gamepass" then
        local success, owned = pcall(function()
            return MarketplaceService:UserOwnsGamePassAsync(player.UserId, config.ProductId)
        end)
        
        if success and owned then
            buyButton.Text = "✓ OWNED"
            buyButton.BackgroundColor3 = COLORS.Owned
            buyButton.Active = false
        end
    end
    
    -- Purchase logic
    buyButton.MouseButton1Click:Connect(function()
        if config.ProductType == "Gamepass" then
            MarketplaceService:PromptGamePassPurchase(player, config.ProductId)
        elseif config.ProductType == "Product" then
            MarketplaceService:PromptProductPurchase(player, config.ProductId)
        end
    end)
    
    -- Hover effects
    buyButton.MouseEnter:Connect(function()
        if buyButton.Text ~= "✓ OWNED" then
            buyButton.BackgroundColor3 = COLORS.ButtonHover
            buyButton.Size = UDim2.new(0, 185, 0, 52)
        end
    end)
    buyButton.MouseLeave:Connect(function()
        if buyButton.Text ~= "✓ OWNED" then
            buyButton.BackgroundColor3 = COLORS.Button
            buyButton.Size = UDim2.new(0, 180, 0, 50)
        end
    end)
    
    -- Item hover effect
    item.MouseEnter:Connect(function()
        item.BackgroundColor3 = COLORS.ItemHover
    end)
    item.MouseLeave:Connect(function()
        item.BackgroundColor3 = COLORS.Item
    end)
    
    return item
end

return ShopUI
