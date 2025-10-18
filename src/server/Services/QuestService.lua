-- Pet Quest Legends - Quest Service
-- Handles quest tracking and completion

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataService = require(script.Parent.DataService)
local RemoteManager = require(ReplicatedStorage.Modules.RemoteManager)
local Utilities = require(ReplicatedStorage.Modules.Utilities)
local QuestConfig = require(ReplicatedStorage.Config.QuestConfig)
local PetConfig = require(ReplicatedStorage.Config.PetConfig)

local QuestService = {}

-- Initialize service
function QuestService.Init()
	-- Setup remote callbacks
	RemoteManager.SetCallback("ClaimQuestReward", function(player, questId)
		return QuestService.ClaimQuestReward(player, questId)
	end)
	
	-- Check daily quest reset every minute
	task.spawn(function()
		while true do
			task.wait(60)
			QuestService.CheckDailyQuestReset()
		end
	end)
	
	print("[QuestService] Initialized")
end

-- Track quest progress
function QuestService.TrackProgress(player, progressType, amount, additionalData)
	local profile = DataService.GetProfile(player)
	if not profile then return end
	
	-- Get all active quests
	local activeQuests = QuestService.GetActiveQuests(player)
	
	for _, quest in ipairs(activeQuests) do
		if quest.Requirement.Type == progressType then
			-- Check additional requirements
			local meetsRequirements = true
			
			if quest.Requirement.World and additionalData then
				if additionalData.World ~= quest.Requirement.World then
					meetsRequirements = false
				end
			end
			
			if quest.Requirement.EggType and additionalData then
				if additionalData.EggType ~= quest.Requirement.EggType then
					meetsRequirements = false
				end
			end
			
			if quest.Requirement.Rarity and additionalData then
				if additionalData.Rarity ~= quest.Requirement.Rarity then
					meetsRequirements = false
				end
			end
			
			if meetsRequirements then
				-- Update progress
				local currentProgress = profile.Data.QuestProgress[quest.Id] or 0
				local newProgress = currentProgress + (amount or 1)
				
				DataService.UpdateQuestProgress(player, quest.Id, newProgress)
				
				-- Check if quest is complete
				if newProgress >= quest.Requirement.Amount then
					QuestService.CompleteQuest(player, quest.Id)
				end
			end
		end
	end
end

-- Get active quests for player
function QuestService.GetActiveQuests(player)
	local profile = DataService.GetProfile(player)
	if not profile then return {} end
	
	local activeQuests = {}
	
	-- Add daily quests
	for _, quest in ipairs(QuestConfig.DailyQuests) do
		if not table.find(profile.Data.CompletedQuests, quest.Id) then
			table.insert(activeQuests, quest)
		end
	end
	
	-- Add world quests
	for _, quest in ipairs(QuestConfig.WorldQuests) do
		if not table.find(profile.Data.CompletedQuests, quest.Id) then
			-- Check if world is unlocked
			if table.find(profile.Data.UnlockedWorlds, quest.World) then
				table.insert(activeQuests, quest)
			end
		end
	end
	
	-- Add achievements
	for _, quest in ipairs(QuestConfig.Achievements) do
		if not table.find(profile.Data.CompletedQuests, quest.Id) then
			table.insert(activeQuests, quest)
		end
	end
	
	-- Add legendary quests
	for _, quest in ipairs(QuestConfig.LegendaryQuests) do
		if not table.find(profile.Data.CompletedQuests, quest.Id) then
			table.insert(activeQuests, quest)
		end
	end
	
	return activeQuests
end

-- Complete a quest
function QuestService.CompleteQuest(player, questId)
	local profile = DataService.GetProfile(player)
	if not profile then return false end
	
	-- Check if already completed
	if table.find(profile.Data.CompletedQuests, questId) then
		return false
	end
	
	-- Mark as complete
	DataService.CompleteQuest(player, questId)
	
	return true
end

-- Claim quest reward
function QuestService.ClaimQuestReward(player, questId)
	local profile = DataService.GetProfile(player)
	if not profile then return {Success = false, Error = "No profile"} end
	
	-- Check if quest is completed
	if not table.find(profile.Data.CompletedQuests, questId) then
		return {Success = false, Error = "Quest not completed"}
	end
	
	-- Get quest data
	local questData = QuestConfig.GetQuestData(questId)
	if not questData then
		return {Success = false, Error = "Invalid quest"}
	end
	
	-- Check if already claimed (store in separate table)
	if not profile.Data.ClaimedQuestRewards then
		profile.Data.ClaimedQuestRewards = {}
	end
	
	if table.find(profile.Data.ClaimedQuestRewards, questId) then
		return {Success = false, Error = "Reward already claimed"}
	end
	
	-- Give rewards
	local rewards = {}
	
	if questData.Rewards.Coins then
		DataService.AddCoins(player, questData.Rewards.Coins)
		table.insert(rewards, {Type = "Coins", Amount = questData.Rewards.Coins})
	end
	
	if questData.Rewards.Experience then
		DataService.AddExperience(player, questData.Rewards.Experience)
		table.insert(rewards, {Type = "Experience", Amount = questData.Rewards.Experience})
	end
	
	if questData.Rewards.Pet then
		local pet = DataService.AddPet(player, questData.Rewards.Pet, 0)
		table.insert(rewards, {Type = "Pet", Pet = pet})
	end
	
	if questData.Rewards.Title then
		if not profile.Data.UnlockedTitles then
			profile.Data.UnlockedTitles = {}
		end
		table.insert(profile.Data.UnlockedTitles, questData.Rewards.Title)
		table.insert(rewards, {Type = "Title", Title = questData.Rewards.Title})
	end
	
	-- Mark as claimed
	table.insert(profile.Data.ClaimedQuestRewards, questId)
	
	return {
		Success = true,
		Rewards = rewards
	}
end

-- Check and reset daily quests
function QuestService.CheckDailyQuestReset()
	local currentTime = os.time()
	local currentDay = math.floor(currentTime / 86400) -- Days since epoch
	
	for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
		local profile = DataService.GetProfile(player)
		if profile then
			local lastResetDay = math.floor(profile.Data.DailyQuestsLastReset / 86400)
			
			if currentDay > lastResetDay then
				-- Reset daily quests
				for _, quest in ipairs(QuestConfig.DailyQuests) do
					-- Remove from completed quests
					local index = table.find(profile.Data.CompletedQuests, quest.Id)
					if index then
						table.remove(profile.Data.CompletedQuests, index)
					end
					
					-- Remove from claimed rewards
					if profile.Data.ClaimedQuestRewards then
						local claimIndex = table.find(profile.Data.ClaimedQuestRewards, quest.Id)
						if claimIndex then
							table.remove(profile.Data.ClaimedQuestRewards, claimIndex)
						end
					end
					
					-- Reset progress
					profile.Data.QuestProgress[quest.Id] = 0
				end
				
				profile.Data.DailyQuestsLastReset = currentTime
				
				-- Notify player
				RemoteManager.FireClient(player, "NotificationSent", {
					Title = "Daily Quests Reset",
					Message = "New daily quests are available!",
					Type = "Info"
				})
			end
		end
	end
end

-- Track egg hatch
function QuestService.OnEggHatched(player, eggType)
	QuestService.TrackProgress(player, "HatchEggs", 1, {EggType = eggType})
end

-- Track pet merge
function QuestService.OnPetMerged(player, petId, world)
	QuestService.TrackProgress(player, "MergePets", 1, {World = world})
end

-- Track coin collection
function QuestService.OnCoinsCollected(player, amount)
	QuestService.TrackProgress(player, "CollectCoins", amount)
end

-- Track trade completion
function QuestService.OnTradeCompleted(player)
	QuestService.TrackProgress(player, "CompleteTrades", 1)
end

-- Track world unlock
function QuestService.OnWorldUnlocked(player, worldId)
	QuestService.TrackProgress(player, "UnlockWorld", 1, {World = worldId})
end

-- Track unique pet collection
function QuestService.OnPetCollected(player, petId, world, rarity)
	QuestService.TrackProgress(player, "CollectUniquePets", 1, {
		World = world,
		Rarity = rarity
	})
end

return QuestService