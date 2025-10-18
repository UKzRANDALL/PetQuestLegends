-- Pet Quest Legends - Main Server Script
-- Initializes all server services

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("=== Pet Quest Legends - Server Starting ===")

-- Wait for shared modules to load
local RemoteManager = require(ReplicatedStorage.Modules.RemoteManager)

-- Load all services
local DataService = require(script.Services.DataService)
local PetService = require(script.Services.PetService)
local CoinService = require(script.Services.CoinService)
local QuestService = require(script.Services.QuestService)
local GuildService = require(script.Services.GuildService)
local TradingService = require(script.Services.TradingService)

-- Initialize services in order
DataService.Init()
task.wait(0.5)

PetService.Init()
CoinService.Init()
QuestService.Init()
GuildService.Init()
TradingService.Init()

-- Load dev commands (REMOVE BEFORE PUBLISHING!)
local DevCommands = require(script.Services.DevCommands)
DevCommands.Init()

print("=== Pet Quest Legends - Server Ready ===")

-- Cleanup on shutdown
game:BindToClose(function()
print("=== Pet Quest Legends - Server Shutting Down ===")

-- Save all player data
DataService.SaveAllPlayers()

-- Wait for saves to complete
task.wait(3)

print("=== Pet Quest Legends - Server Shutdown Complete ===")
end)
