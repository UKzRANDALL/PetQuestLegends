-- Pet Quest Legends - Data Service
-- Handles all player data management with ProfileService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- Note: ProfileService should be installed via Wally or manually added to ServerScriptService
-- For this template, we'll create a mock version that can be replaced with the real ProfileService
local ProfileService = require(script.Parent.ProfileServiceMock)

local RemoteManager = require(ReplicatedStorage.Modules.RemoteManager)
local Utilities = require(ReplicatedStorage.Modules.Utilities)

local DataService = {}
DataService.Profiles = {}
DataService.ProfileStore = nil

-- Default player data template
local DEFAULT_DATA = {
	-- Currency
	Coins = 0,
	Robux = 0,
	
	-- Player Stats
	Level = 1,
	Experience = 0,
	TotalCoinsEarned = 0,
	PrestigeLevel = 0,
	
	-- Pets
	Pets = {}, -- {PetId, MergeLevel, Equipped, Skin}
	EquippedPets = {},
	MaxEquippedPets = 8,
	
	-- Worlds
	UnlockedWorlds = {"StarterForest"},
	CurrentWorld = "StarterForest",
	
	-- Quests
	CompletedQuests = {},
	QuestProgress = {},
	DailyQuestsLastReset = 0,
	
	-- Guild
	GuildId = nil,
	GuildRank = nil,
	GuildContributions = 0,
	
	-- Trading
	TradeHistory = {},
	TotalTrades = 0,
	
	-- Gamepasses
	OwnedGamepasses = {},
	
	-- Boosts
	ActiveBoosts = {},
	
	-- Pet Skins
	OwnedSkins = {},
	
	-- Statistics
	Stats = {
		EggsHatched = 0,
		PetsMerged = 0,
		QuestsCompleted = 0,
		TradesCompleted = 0,
		TotalPlayTime = 0,
		LastLogin = 0
	},
	
	-- Settings
	Settings = {
		MusicEnabled = true,
		SFXEnabled = true,
		NotificationsEnabled = true,
		AutoEquipPets = false
	},
	
	-- Inventory
	Inventory = {
		PremiumEggs = {}
	}
}

-- Initialize ProfileStore
function DataService.Init()
	DataService.ProfileStore = ProfileService.GetProfileStore(
		"PlayerData_v1",
		DEFAULT_DATA
	)
	
	-- Handle player joining
	Players.PlayerAdded:Connect(function(player)
		DataService.LoadPlayerData(player)
	end)
	
	-- Handle player leaving
	Players.PlayerRemoving:Connect(function(player)
		DataService.SavePlayerData(player)
	end)
	
	-- Auto-save every 5 minutes
	task.spawn(function()
		while true do
			task.wait(300) -- 5 minutes
			DataService.SaveAllPlayers()
		end
	end)
	
	print("[DataService] Initialized")
end

-- Load player data
function DataService.LoadPlayerData(player)
	local profile = DataService.ProfileStore:LoadProfileAsync(
		"Player_" .. player.UserId,
		"ForceLoad"
	)
	
	if profile then
		profile:AddUserId(player.UserId)
		profile:Reconcile()
		
		profile:ListenToRelease(function()
			DataService.Profiles[player] = nil
			player:Kick("Data session released")
		end)
		
		if player:IsDescendantOf(Players) then
			DataService.Profiles[player] = profile
			
			-- Update last login
			profile.Data.Stats.LastLogin = os.time()
			
			-- Send data to client
			RemoteManager.FireClient(player, "PlayerDataLoaded", profile.Data)
			
			print("[DataService] Loaded data for", player.Name)
		else
			profile:Release()
		end
	else
		player:Kick("Failed to load data. Please rejoin.")
	end
end

-- Save player data
function DataService.SavePlayerData(player)
	local profile = DataService.Profiles[player]
	if profile then
		profile:Release()
		DataService.Profiles[player] = nil
		print("[DataService] Saved data for", player.Name)
	end
end

-- Save all players
function DataService.SaveAllPlayers()
	for player, profile in pairs(DataService.Profiles) do
		if Utilities.IsPlayerValid(player) then
			-- Data is automatically saved by ProfileService
			print("[DataService] Auto-saved data for", player.Name)
		end
	end
end

-- Get player profile
function DataService.GetProfile(player)
	return DataService.Profiles[player]
end

-- Get player data
function DataService.GetData(player)
	local profile = DataService.GetProfile(player)
	return profile and profile.Data
end

-- Update player data
function DataService.UpdateData(player, key, value)
	local profile = DataService.GetProfile(player)
	if profile then
		profile.Data[key] = value
		return true
	end
	return false
end

-- Add coins
function DataService.AddCoins(player, amount)
	local profile = DataService.GetProfile(player)
	if profile then
		profile.Data.Coins = profile.Data.Coins + amount
		profile.Data.TotalCoinsEarned = profile.Data.TotalCoinsEarned + amount
		RemoteManager.FireClient(player, "CoinCollected", amount, profile.Data.Coins)
		return true
	end
	return false
end

-- Remove coins
function DataService.RemoveCoins(player, amount)
	local profile = DataService.GetProfile(player)
	if profile and profile.Data.Coins >= amount then
		profile.Data.Coins = profile.Data.Coins - amount
		return true
	end
	return false
end

-- Add experience
function DataService.AddExperience(player, amount)
	local profile = DataService.GetProfile(player)
	if profile then
		profile.Data.Experience = profile.Data.Experience + amount
		
		-- Check for level up
		local requiredExp = DataService.GetRequiredExperience(profile.Data.Level)
		while profile.Data.Experience >= requiredExp do
			profile.Data.Experience = profile.Data.Experience - requiredExp
			profile.Data.Level = profile.Data.Level + 1
			RemoteManager.FireClient(player, "LevelUp", profile.Data.Level)
			requiredExp = DataService.GetRequiredExperience(profile.Data.Level)
		end
		
		return true
	end
	return false
end

-- Calculate required experience for level
function DataService.GetRequiredExperience(level)
	return math.floor(100 * (level ^ 1.5))
end

-- Add pet to inventory
function DataService.AddPet(player, petId, mergeLevel)
	local profile = DataService.GetProfile(player)
	if profile then
		local petData = {
			Id = Utilities.GenerateId(),
			PetId = petId,
			MergeLevel = mergeLevel or 0,
			Equipped = false,
			Skin = nil,
			ObtainedAt = os.time()
		}
		table.insert(profile.Data.Pets, petData)
		return petData
	end
	return nil
end

-- Remove pet from inventory
function DataService.RemovePet(player, petUniqueId)
	local profile = DataService.GetProfile(player)
	if profile then
		for i, pet in ipairs(profile.Data.Pets) do
			if pet.Id == petUniqueId then
				table.remove(profile.Data.Pets, i)
				return true
			end
		end
	end
	return false
end

-- Equip pet
function DataService.EquipPet(player, petUniqueId)
	local profile = DataService.GetProfile(player)
	if profile then
		-- Check if already equipped
		if table.find(profile.Data.EquippedPets, petUniqueId) then
			return false, "Pet already equipped"
		end
		
		-- Check max equipped pets
		if #profile.Data.EquippedPets >= profile.Data.MaxEquippedPets then
			return false, "Maximum pets equipped"
		end
		
		-- Find pet
		for _, pet in ipairs(profile.Data.Pets) do
			if pet.Id == petUniqueId then
				pet.Equipped = true
				table.insert(profile.Data.EquippedPets, petUniqueId)
				return true
			end
		end
	end
	return false, "Pet not found"
end

-- Unequip pet
function DataService.UnequipPet(player, petUniqueId)
	local profile = DataService.GetProfile(player)
	if profile then
		local index = table.find(profile.Data.EquippedPets, petUniqueId)
		if index then
			table.remove(profile.Data.EquippedPets, index)
			
			-- Update pet data
			for _, pet in ipairs(profile.Data.Pets) do
				if pet.Id == petUniqueId then
					pet.Equipped = false
					break
				end
			end
			return true
		end
	end
	return false
end

-- Unlock world
function DataService.UnlockWorld(player, worldId)
	local profile = DataService.GetProfile(player)
	if profile then
		if not table.find(profile.Data.UnlockedWorlds, worldId) then
			table.insert(profile.Data.UnlockedWorlds, worldId)
			RemoteManager.FireClient(player, "WorldUnlocked", worldId)
			return true
		end
	end
	return false
end

-- Update quest progress
function DataService.UpdateQuestProgress(player, questId, progress)
	local profile = DataService.GetProfile(player)
	if profile then
		profile.Data.QuestProgress[questId] = progress
		return true
	end
	return false
end

-- Complete quest
function DataService.CompleteQuest(player, questId)
	local profile = DataService.GetProfile(player)
	if profile then
		if not table.find(profile.Data.CompletedQuests, questId) then
			table.insert(profile.Data.CompletedQuests, questId)
			profile.Data.Stats.QuestsCompleted = profile.Data.Stats.QuestsCompleted + 1
			RemoteManager.FireClient(player, "QuestCompleted", questId)
			return true
		end
	end
	return false
end

-- Add gamepass
function DataService.AddGamepass(player, gamepassName)
	local profile = DataService.GetProfile(player)
	if profile then
		profile.Data.OwnedGamepasses[gamepassName] = true
		return true
	end
	return false
end

-- Activate boost
function DataService.ActivateBoost(player, boostName, duration)
	local profile = DataService.GetProfile(player)
	if profile then
		profile.Data.ActiveBoosts[boostName] = os.time() + duration
		RemoteManager.FireClient(player, "BoostActivated", boostName, duration)
		return true
	end
	return false
end

-- Check if boost is active
function DataService.IsBoostActive(player, boostName)
	local profile = DataService.GetProfile(player)
	if profile then
		local expireTime = profile.Data.ActiveBoosts[boostName]
		if expireTime and os.time() < expireTime then
			return true
		else
			profile.Data.ActiveBoosts[boostName] = nil
		end
	end
	return false
end

-- Setup remote callbacks
RemoteManager.SetCallback("GetPlayerData", function(player)
	return DataService.GetData(player)
end)

return DataService
