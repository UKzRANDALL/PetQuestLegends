-- Pet Quest Legends - Game Controller
-- Main client-side game logic controller

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local RemoteManager = require(ReplicatedStorage.Modules.RemoteManager)
local Utilities = require(ReplicatedStorage.Modules.Utilities)

local GameController = {}
GameController.PlayerData = nil
GameController.IsLoaded = false

-- Initialize controller
function GameController.Init()
	local player = Players.LocalPlayer
	
	-- Wait for player data
	RemoteManager.OnClientEvent("PlayerDataLoaded", function(data)
		GameController.PlayerData = data
		GameController.IsLoaded = true
		GameController.OnDataLoaded()
	end)
	
	-- Request player data
	GameController.PlayerData = RemoteManager.InvokeServer("GetPlayerData")
	if GameController.PlayerData then
		GameController.IsLoaded = true
		GameController.OnDataLoaded()
	end
	
	-- Setup event listeners
	GameController.SetupEventListeners()
	
	print("[GameController] Initialized")
end

-- Called when player data is loaded
function GameController.OnDataLoaded()
	print("[GameController] Player data loaded")
	
	-- Initialize UI
	local UIController = require(script.Parent.UIController)
	UIController.Init()
	
	-- Initialize pet display
	local PetDisplayController = require(script.Parent.PetDisplayController)
	PetDisplayController.Init()
	
	-- Initialize coin collection
	local CoinController = require(script.Parent.CoinController)
	CoinController.Init()
end

-- Setup event listeners
function GameController.SetupEventListeners()
	-- Coin collected
	RemoteManager.OnClientEvent("CoinCollected", function(amount, newTotal)
		GameController.PlayerData.Coins = newTotal
		GameController.OnCoinCollected(amount, newTotal)
	end)
	
	-- Pet hatched
	RemoteManager.OnClientEvent("PetHatched", function(pet, petData)
		GameController.OnPetHatched(pet, petData)
	end)
	
	-- Pet merged
	RemoteManager.OnClientEvent("PetMerged", function(mergedPet)
		GameController.OnPetMerged(mergedPet)
	end)
	
	-- Pet equipped
	RemoteManager.OnClientEvent("PetEquipped", function(petUniqueId)
		GameController.OnPetEquipped(petUniqueId)
	end)
	
	-- Pet unequipped
	RemoteManager.OnClientEvent("PetUnequipped", function(petUniqueId)
		GameController.OnPetUnequipped(petUniqueId)
	end)
	
	-- Level up
	RemoteManager.OnClientEvent("LevelUp", function(newLevel)
		GameController.PlayerData.Level = newLevel
		GameController.OnLevelUp(newLevel)
	end)
	
	-- World unlocked
	RemoteManager.OnClientEvent("WorldUnlocked", function(worldId)
		table.insert(GameController.PlayerData.UnlockedWorlds, worldId)
		GameController.OnWorldUnlocked(worldId)
	end)
	
	-- Quest completed
	RemoteManager.OnClientEvent("QuestCompleted", function(questId)
		GameController.OnQuestCompleted(questId)
	end)
	
	-- Boost activated
	RemoteManager.OnClientEvent("BoostActivated", function(boostName, duration)
		GameController.OnBoostActivated(boostName, duration)
	end)
	
	-- Notification
	RemoteManager.OnClientEvent("NotificationSent", function(notification)
		GameController.ShowNotification(notification)
	end)
	
	-- Trading events
	RemoteManager.OnClientEvent("TradeRequest", function(data)
		GameController.OnTradeRequest(data)
	end)
	
	RemoteManager.OnClientEvent("TradeAccepted", function(data)
		GameController.OnTradeAccepted(data)
	end)
	
	RemoteManager.OnClientEvent("TradeCancelled", function(data)
		GameController.OnTradeCancelled(data)
	end)
	
	RemoteManager.OnClientEvent("TradeCompleted", function(data)
		GameController.OnTradeCompleted(data)
	end)
	
	RemoteManager.OnClientEvent("TradeUpdated", function(data)
		GameController.OnTradeUpdated(data)
	end)
	
	-- Guild events
	RemoteManager.OnClientEvent("GuildJoined", function(guildData)
		GameController.OnGuildJoined(guildData)
	end)
	
	RemoteManager.OnClientEvent("GuildLeft", function()
		GameController.OnGuildLeft()
	end)
end

-- Event handlers
function GameController.OnCoinCollected(amount, newTotal)
	-- Update UI
	local UIController = require(script.Parent.UIController)
	UIController.UpdateCoins(newTotal)
	
	-- Show floating text
	GameController.ShowFloatingText("+" .. Utilities.FormatNumber(amount), Color3.fromRGB(255, 215, 0))
end

function GameController.OnPetHatched(pet, petData)
	-- Show hatch animation
	local UIController = require(script.Parent.UIController)
	UIController.ShowHatchResult(pet, petData)
end

function GameController.OnPetMerged(mergedPet)
	-- Show merge animation
	local UIController = require(script.Parent.UIController)
	UIController.ShowMergeResult(mergedPet)
end

function GameController.OnPetEquipped(petUniqueId)
	-- Update pet display
	local PetDisplayController = require(script.Parent.PetDisplayController)
	PetDisplayController.UpdateEquippedPets()
end

function GameController.OnPetUnequipped(petUniqueId)
	-- Update pet display
	local PetDisplayController = require(script.Parent.PetDisplayController)
	PetDisplayController.UpdateEquippedPets()
end

function GameController.OnLevelUp(newLevel)
	-- Show level up animation
	GameController.ShowNotification({
		Title = "Level Up!",
		Message = "You reached level " .. newLevel .. "!",
		Type = "Success"
	})
end

function GameController.OnWorldUnlocked(worldId)
	-- Show unlock animation
	GameController.ShowNotification({
		Title = "World Unlocked!",
		Message = "You unlocked a new world!",
		Type = "Success"
	})
end

function GameController.OnQuestCompleted(questId)
	-- Show quest completion
	GameController.ShowNotification({
		Title = "Quest Completed!",
		Message = "You completed a quest!",
		Type = "Success"
	})
end

function GameController.OnBoostActivated(boostName, duration)
	-- Show boost notification
	GameController.ShowNotification({
		Title = "Boost Activated!",
		Message = boostName .. " for " .. Utilities.FormatTime(duration),
		Type = "Info"
	})
end

function GameController.OnTradeRequest(data)
	-- Show trade request UI
	local UIController = require(script.Parent.UIController)
	UIController.ShowTradeRequest(data)
end

function GameController.OnTradeAccepted(data)
	-- Open trading UI
	local UIController = require(script.Parent.UIController)
	UIController.OpenTradingUI(data)
end

function GameController.OnTradeCancelled(data)
	-- Close trading UI
	local UIController = require(script.Parent.UIController)
	UIController.CloseTradingUI()
	
	GameController.ShowNotification({
		Title = "Trade Cancelled",
		Message = data.Reason or "Trade was cancelled",
		Type = "Warning"
	})
end

function GameController.OnTradeCompleted(data)
	-- Close trading UI
	local UIController = require(script.Parent.UIController)
	UIController.CloseTradingUI()
	
	GameController.ShowNotification({
		Title = "Trade Completed!",
		Message = "Trade was successful!",
		Type = "Success"
	})
end

function GameController.OnTradeUpdated(data)
	-- Update trading UI
	local UIController = require(script.Parent.UIController)
	UIController.UpdateTradingUI(data)
end

function GameController.OnGuildJoined(guildData)
	GameController.ShowNotification({
		Title = "Guild Joined!",
		Message = "You joined " .. guildData.Name,
		Type = "Success"
	})
end

function GameController.OnGuildLeft()
	GameController.ShowNotification({
		Title = "Guild Left",
		Message = "You left your guild",
		Type = "Info"
	})
end

-- Show notification
function GameController.ShowNotification(notification)
	local UIController = require(script.Parent.UIController)
	UIController.ShowNotification(notification)
end

-- Show floating text
function GameController.ShowFloatingText(text, color)
	-- This would create a floating text effect above the player
	-- Implementation depends on your UI system
end

-- Get player data
function GameController.GetPlayerData()
	return GameController.PlayerData
end

-- Update player data
function GameController.UpdatePlayerData(key, value)
	if GameController.PlayerData then
		GameController.PlayerData[key] = value
	end
end

return GameController