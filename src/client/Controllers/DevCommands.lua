-- Pet Quest Legends - Dev Commands (FOR TESTING ONLY)
-- Remove this before publishing!

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local DevCommands = {}

function DevCommands.Init()
local player = Players.LocalPlayer

-- Listen for F1 key to open dev menu
UserInputService.InputBegan:Connect(function(input, gameProcessed)
if gameProcessed then return end

if input.KeyCode == Enum.KeyCode.F1 then
-- Give coins
local remote = ReplicatedStorage.DevRemotes:FindFirstChild("DevGiveCoins")
if remote then
remote:FireServer(10000)
print("Added 10,000 coins (DEV)")
end
elseif input.KeyCode == Enum.KeyCode.F2 then
-- Give random pet
local remote = ReplicatedStorage.DevRemotes:FindFirstChild("DevGivePet")
if remote then
remote:FireServer()
print("Added random pet (DEV)")
end
elseif input.KeyCode == Enum.KeyCode.F3 then
-- Max level
local remote = ReplicatedStorage.DevRemotes:FindFirstChild("DevMaxLevel")
if remote then
remote:FireServer()
print("Set max level (DEV)")
end
elseif input.KeyCode == Enum.KeyCode.F4 then
-- Refresh data
print("Refreshing player data...")
local RemoteManager = require(ReplicatedStorage.Modules.RemoteManager)
local newData = RemoteManager.InvokeServer("GetPlayerData")
local GameController = require(script.Parent.GameController)
GameController.PlayerData = newData
print("Data refreshed! You have " .. #newData.Pets .. " pets")
elseif input.KeyCode == Enum.KeyCode.F3 then
-- Max level
local remote = ReplicatedStorage.DevRemotes:FindFirstChild("DevMaxLevel")
if remote then
remote:FireServer()
print("Set max level (DEV)")
end
end
end)

print("DEV COMMANDS LOADED:")
print("F1 = Add 10,000 coins")
print("F2 = Add random pet")
print("F3 = Set level to 50")
print("F4 = Refresh player data")
end

return DevCommands

