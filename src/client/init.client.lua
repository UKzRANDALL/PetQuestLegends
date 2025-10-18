-- Pet Quest Legends - Main Client Script
-- Initializes all client controllers

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

print("=== Pet Quest Legends - Client Starting ===")

local player = Players.LocalPlayer

-- Wait for character
local character = player.Character or player.CharacterAdded:Wait()

-- Wait for shared modules to load
local RemoteManager = require(ReplicatedStorage.Modules.RemoteManager)

-- Load main game controller
local GameController = require(script.Controllers.GameController)

-- Initialize game
GameController.Init()

-- Load dev commands (REMOVE BEFORE PUBLISHING!)
local DevCommands = require(script.Controllers.DevCommands)
DevCommands.Init()

print("=== Pet Quest Legends - Client Ready ===")
