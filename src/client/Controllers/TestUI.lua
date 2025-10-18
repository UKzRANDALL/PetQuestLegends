-- MINIMAL TEST UI
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TestUI = {}

function TestUI.Open()
local player = Players.LocalPlayer
local gui = player.PlayerGui:FindFirstChild("PetQuestLegendsUI")
if not gui then return end

-- Create simple test frame
local test = Instance.new("Frame")
test.Name = "TestFrame"
test.Size = UDim2.new(0, 400, 0, 300)
test.Position = UDim2.new(0.5, -200, 0.5, -150)
test.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
test.ZIndex = 1000
test.Parent = gui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 1, 0)
label.BackgroundTransparency = 1
label.Text = "TEST UI - If you see this, UI system works!"
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.TextSize = 24
label.Font = Enum.Font.GothamBold
label.TextWrapped = true
label.Parent = test

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 100, 0, 50)
closeBtn.Position = UDim2.new(0.5, -50, 0.7, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.Text = "CLOSE"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = test

closeBtn.MouseButton1Click:Connect(function()
test:Destroy()
end)

print("TEST UI OPENED")
end

function TestUI.Close()
local player = Players.LocalPlayer
local gui = player.PlayerGui:FindFirstChild("PetQuestLegendsUI")
if gui then
local test = gui:FindFirstChild("TestFrame")
if test then
test:Destroy()
end
end
end

return TestUI
