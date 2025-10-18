-- Pet Quest Legends - Quest UI
-- Handles display of daily quests, world quests, and achievements

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteManager = require(ReplicatedStorage.Modules.RemoteManager)
local QuestConfig = require(ReplicatedStorage.Config.QuestConfig)
local Utilities = require(ReplicatedStorage.Modules.Utilities)

local QuestUI = {}
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- UI References
local screenGui = nil
local currentTab = "Daily"
local playerQuests = {}

-- Colors
local COLORS = {
    Background = Color3.fromRGB(30, 30, 40),
    Header = Color3.fromRGB(40, 40, 50),
    Item = Color3.fromRGB(50, 50, 60),
    ItemHover = Color3.fromRGB(60, 60, 70),
    Complete = Color3.fromRGB(0, 170, 0),
    Incomplete = Color3.fromRGB(170, 170, 0),
    Claimed = Color3.fromRGB(100, 100, 100),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    ProgressBar = Color3.fromRGB(0, 150, 255),
    ProgressBg = Color3.fromRGB(40, 40, 50),
}

function QuestUI.Init()
    print("[QuestUI] Initialized")
    
    -- Listen for quest updates
    RemoteManager.GetRemote("QuestUpdate").OnClientEvent:Connect(function(quests)
        playerQuests = quests
        if screenGui then
            QuestUI.RefreshCurrentTab()
        end
    end)
end

function QuestUI.Show()
    if screenGui then
        screenGui:Destroy()
    end
    
    -- Request current quests from server
    -- TODO: Implement GetQuests remote
    -- RemoteManager.GetRemote("GetQuests"):InvokeServer()
    
    QuestUI.CreateMainUI()
end

function QuestUI.Hide()
    if screenGui then
        screenGui:Destroy()
        screenGui = nil
    end
end

function QuestUI.CreateMainUI()
    -- Main ScreenGui
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "QuestUI"
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
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = container
    
    -- Header
    QuestUI.CreateHeader(container)
    
    -- Tab buttons
    QuestUI.CreateTabs(container)
    
    -- Content area
    QuestUI.CreateContent(container)
    
    -- Load initial tab
    QuestUI.LoadTab("Daily")
end

function QuestUI.CreateHeader(parent)
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
    title.Text = "QUESTS"
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
    closeButton.Text = "X"
    closeButton.TextColor3 = COLORS.Text
    closeButton.TextSize = 28
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = header
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        QuestUI.Hide()
    end)
    
    -- Hover effect
    closeButton.MouseEnter:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
    end)
    closeButton.MouseLeave:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end)
end

function QuestUI.CreateTabs(parent)
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Size = UDim2.new(1, -40, 0, 50)
    tabContainer.Position = UDim2.new(0, 20, 0, 80)
    tabContainer.BackgroundTransparency = 1
    tabContainer.Parent = parent
    
    local tabs = {"Daily", "World", "Achievements"}
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
            QuestUI.LoadTab(tabName)
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

function QuestUI.CreateContent(parent)
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

function QuestUI.LoadTab(tabName)
    currentTab = tabName
    
    -- Update tab button colors
    local tabContainer = screenGui.Container.TabContainer
    for _, child in ipairs(tabContainer:GetChildren()) do
        if child:IsA("TextButton") then
            if child.Name == tabName .. "Tab" then
                child.BackgroundColor3 = COLORS.Complete
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
    if tabName == "Daily" then
        QuestUI.LoadDailyQuests(content)
    elseif tabName == "World" then
        QuestUI.LoadWorldQuests(content)
    elseif tabName == "Achievements" then
        QuestUI.LoadAchievements(content)
    end
end

function QuestUI.RefreshCurrentTab()
    if screenGui then
        QuestUI.LoadTab(currentTab)
    end
end

function QuestUI.LoadDailyQuests(parent)
    local yOffset = 0
    local dailyQuests = {}
    
    -- Filter daily quests
    for questId, questData in pairs(playerQuests) do
        local config = QuestConfig.DailyQuests[questId]
        if config then
            table.insert(dailyQuests, {
                Id = questId,
                Config = config,
                Data = questData
            })
        end
    end
    
    -- Sort by completion status
    table.sort(dailyQuests, function(a, b)
        return (a.Data.Completed and 1 or 0) < (b.Data.Completed and 1 or 0)
    end)
    
    if #dailyQuests == 0 then
        QuestUI.CreateEmptyMessage(parent, "No daily quests available!")
        return
    end
    
    for _, quest in ipairs(dailyQuests) do
        QuestUI.CreateQuestItem(parent, quest, yOffset)
        yOffset = yOffset + 130
    end
    
    parent.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

function QuestUI.LoadWorldQuests(parent)
    local yOffset = 0
    local worldQuests = {}
    
    -- Filter world quests
    for questId, questData in pairs(playerQuests) do
        local config = QuestConfig.WorldQuests[questId]
        if config then
            table.insert(worldQuests, {
                Id = questId,
                Config = config,
                Data = questData
            })
        end
    end
    
    -- Sort by world and completion
    table.sort(worldQuests, function(a, b)
        if a.Config.World == b.Config.World then
            return (a.Data.Completed and 1 or 0) < (b.Data.Completed and 1 or 0)
        end
        return a.Config.World < b.Config.World
    end)
    
    if #worldQuests == 0 then
        QuestUI.CreateEmptyMessage(parent, "No world quests available!")
        return
    end
    
    for _, quest in ipairs(worldQuests) do
        QuestUI.CreateQuestItem(parent, quest, yOffset)
        yOffset = yOffset + 130
    end
    
    parent.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

function QuestUI.LoadAchievements(parent)
    local yOffset = 0
    local achievements = {}
    
    -- Filter achievements
    for questId, questData in pairs(playerQuests) do
        local config = QuestConfig.Achievements[questId]
        if config then
            table.insert(achievements, {
                Id = questId,
                Config = config,
                Data = questData
            })
        end
    end
    
    -- Sort by completion
    table.sort(achievements, function(a, b)
        return (a.Data.Completed and 1 or 0) < (b.Data.Completed and 1 or 0)
    end)
    
    if #achievements == 0 then
        QuestUI.CreateEmptyMessage(parent, "No achievements available!")
        return
    end
    
    for _, quest in ipairs(achievements) do
        QuestUI.CreateQuestItem(parent, quest, yOffset)
        yOffset = yOffset + 130
    end
    
    parent.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

function QuestUI.CreateEmptyMessage(parent, message)
    local emptyLabel = Instance.new("TextLabel")
    emptyLabel.Size = UDim2.new(1, 0, 0, 100)
    emptyLabel.Position = UDim2.new(0, 0, 0, 50)
    emptyLabel.BackgroundTransparency = 1
    emptyLabel.Text = message
    emptyLabel.TextColor3 = COLORS.TextSecondary
    emptyLabel.TextSize = 20
    emptyLabel.Font = Enum.Font.Gotham
    emptyLabel.Parent = parent
end

function QuestUI.CreateQuestItem(parent, quest, yOffset)
    local config = quest.Config
    local data = quest.Data
    local progress = data.Progress or 0
    local target = config.Target
    local completed = data.Completed
    local claimed = data.Claimed
    
    -- Main item frame
    local item = Instance.new("Frame")
    item.Name = quest.Id
    item.Size = UDim2.new(1, -20, 0, 120)
    item.Position = UDim2.new(0, 10, 0, yOffset)
    item.BackgroundColor3 = COLORS.Item
    item.BorderSizePixel = 0
    item.Parent = parent
    
    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 10)
    itemCorner.Parent = item
    
    -- Quest name
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "NameLabel"
    nameLabel.Size = UDim2.new(0, 500, 0, 30)
    nameLabel.Position = UDim2.new(0, 15, 0, 10)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = config.Name
    nameLabel.TextColor3 = COLORS.Text
    nameLabel.TextSize = 20
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = item
    
    -- Quest description
    local descLabel = Instance.new("TextLabel")
    descLabel.Name = "DescLabel"
    descLabel.Size = UDim2.new(0, 500, 0, 25)
    descLabel.Position = UDim2.new(0, 15, 0, 40)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = config.Description
    descLabel.TextColor3 = COLORS.TextSecondary
    descLabel.TextSize = 14
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true
    descLabel.Parent = item
    
    -- Progress bar background
    local progressBg = Instance.new("Frame")
    progressBg.Name = "ProgressBg"
    progressBg.Size = UDim2.new(0, 500, 0, 20)
    progressBg.Position = UDim2.new(0, 15, 0, 75)
    progressBg.BackgroundColor3 = COLORS.ProgressBg
    progressBg.BorderSizePixel = 0
    progressBg.Parent = item
    
    local progressBgCorner = Instance.new("UICorner")
    progressBgCorner.CornerRadius = UDim.new(0, 10)
    progressBgCorner.Parent = progressBg
    
    -- Progress bar fill
    local progressPercent = math.min(progress / target, 1)
    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.Size = UDim2.new(progressPercent, 0, 1, 0)
    progressBar.BackgroundColor3 = COLORS.ProgressBar
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBg
    
    local progressBarCorner = Instance.new("UICorner")
    progressBarCorner.CornerRadius = UDim.new(0, 10)
    progressBarCorner.Parent = progressBar
    
    -- Progress text
    local progressText = Instance.new("TextLabel")
    progressText.Size = UDim2.new(1, 0, 1, 0)
    progressText.BackgroundTransparency = 1
    progressText.Text = progress .. " / " .. target
    progressText.TextColor3 = COLORS.Text
    progressText.TextSize = 14
    progressText.Font = Enum.Font.GothamBold
    progressText.Parent = progressBg
    
    -- Reward display
    local rewardLabel = Instance.new("TextLabel")
    rewardLabel.Size = UDim2.new(0, 200, 0, 25)
    rewardLabel.Position = UDim2.new(0, 15, 0, 100)
    rewardLabel.BackgroundTransparency = 1
    rewardLabel.Text = "Reward: " .. Utilities.FormatNumber(config.Reward.Coins) .. " Coins"
    rewardLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
    rewardLabel.TextSize = 14
    rewardLabel.Font = Enum.Font.GothamBold
    rewardLabel.TextXAlignment = Enum.TextXAlignment.Left
    rewardLabel.Parent = item
    
    -- Claim button
    local claimButton = Instance.new("TextButton")
    claimButton.Name = "ClaimButton"
    claimButton.Size = UDim2.new(0, 150, 0, 45)
    claimButton.Position = UDim2.new(1, -165, 0.5, -22.5)
    claimButton.BorderSizePixel = 0
    claimButton.TextSize = 16
    claimButton.Font = Enum.Font.GothamBold
    claimButton.Parent = item
    
    local claimCorner = Instance.new("UICorner")
    claimCorner.CornerRadius = UDim.new(0, 8)
    claimCorner.Parent = claimButton
    
    -- Set button state
    if claimed then
        claimButton.Text = "ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Â ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã¢â‚¬Â¦ÃƒÂ¢Ã¢â€šÂ¬Ã…â€œÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¬ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã‚Â¦ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã¢â‚¬Å“ CLAIMED"
        claimButton.BackgroundColor3 = COLORS.Claimed
        claimButton.TextColor3 = COLORS.TextSecondary
        claimButton.Active = false
    elseif completed then
        claimButton.Text = "ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Â ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â°ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¸ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€šÃ‚Â¦ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â½ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â CLAIM"
        claimButton.BackgroundColor3 = COLORS.Complete
        claimButton.TextColor3 = COLORS.Text
        claimButton.Active = true
        
        -- Claim functionality
        claimButton.MouseButton1Click:Connect(function()
            RemoteManager.GetRemote("ClaimQuestReward"):InvokeServer(quest.Id)
            claimButton.Text = "ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Â ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚ÂÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â³ Claiming..."
            claimButton.Active = false
        end)
        
        -- Hover effect
        claimButton.MouseEnter:Connect(function()
            claimButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            claimButton.Size = UDim2.new(0, 155, 0, 47)
        end)
        claimButton.MouseLeave:Connect(function()
            claimButton.BackgroundColor3 = COLORS.Complete
            claimButton.Size = UDim2.new(0, 150, 0, 45)
        end)
    else
        claimButton.Text = "ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã¢â‚¬Â ÃƒÂ¢Ã¢â€šÂ¬Ã¢â€žÂ¢ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â¢ÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚ÂÃƒÆ’Ã†â€™Ãƒâ€ Ã¢â‚¬â„¢ÃƒÆ’Ã‚Â¢ÃƒÂ¢Ã¢â‚¬Å¡Ã‚Â¬Ãƒâ€¦Ã‚Â¡ÃƒÆ’Ã†â€™ÃƒÂ¢Ã¢â€šÂ¬Ã…Â¡ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â³ IN PROGRESS"
        claimButton.BackgroundColor3 = COLORS.Incomplete
        claimButton.TextColor3 = COLORS.Text
        claimButton.Active = false
    end
    
    -- Item hover effect
    item.MouseEnter:Connect(function()
        item.BackgroundColor3 = COLORS.ItemHover
    end)
    item.MouseLeave:Connect(function()
        item.BackgroundColor3 = COLORS.Item
    end)
    
    return item
end

return QuestUI
