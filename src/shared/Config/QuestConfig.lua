-- Pet Quest Legends - Quest Configuration
-- Defines all quests, achievements, and rewards

local QuestConfig = {}

-- Quest types
QuestConfig.QuestTypes = {
	Daily = "Daily",
	World = "World",
	Achievement = "Achievement",
	Legendary = "Legendary"
}

-- Daily Quests (Reset every 24 hours)
QuestConfig.DailyQuests = {
	{
		Id = "daily_hatch_5",
		Name = "Egg Collector",
		Description = "Hatch 5 eggs",
		Type = "Daily",
		Requirement = {
			Type = "HatchEggs",
			Amount = 5
		},
		Rewards = {
			Coins = 1000,
			Experience = 50
		}
	},
	{
		Id = "daily_collect_1000",
		Name = "Coin Collector",
		Description = "Collect 1,000 coins",
		Type = "Daily",
		Requirement = {
			Type = "CollectCoins",
			Amount = 1000
		},
		Rewards = {
			Coins = 500,
			Experience = 30
		}
	},
	{
		Id = "daily_merge_3",
		Name = "Pet Merger",
		Description = "Merge 3 pets",
		Type = "Daily",
		Requirement = {
			Type = "MergePets",
			Amount = 3
		},
		Rewards = {
			Coins = 2000,
			Experience = 75
		}
	},
	{
		Id = "daily_trade_1",
		Name = "Trader",
		Description = "Complete 1 trade",
		Type = "Daily",
		Requirement = {
			Type = "CompleteTrades",
			Amount = 1
		},
		Rewards = {
			Coins = 1500,
			Experience = 60
		}
	}
}

-- World-Specific Quests
QuestConfig.WorldQuests = {
	-- Starter Forest Quests
	{
		Id = "forest_welcome",
		Name = "Welcome to the Forest",
		Description = "Hatch your first pet",
		World = "StarterForest",
		Type = "World",
		Requirement = {
			Type = "HatchEggs",
			Amount = 1
		},
		Rewards = {
			Coins = 500,
			Experience = 25
		}
	},
	{
		Id = "forest_collector",
		Name = "Forest Collector",
		Description = "Collect 10 different forest pets",
		World = "StarterForest",
		Type = "World",
		Requirement = {
			Type = "CollectUniquePets",
			Amount = 10,
			World = "StarterForest"
		},
		Rewards = {
			Coins = 5000,
			Experience = 100,
			Pet = "forest_phoenix"
		}
	},
	
	-- Candy Kingdom Quests
	{
		Id = "candy_sweet_tooth",
		Name = "Sweet Tooth",
		Description = "Hatch 10 candy eggs",
		World = "CandyKingdom",
		Type = "World",
		Requirement = {
			Type = "HatchEggs",
			Amount = 10,
			EggType = "CandyEgg"
		},
		Rewards = {
			Coins = 10000,
			Experience = 150
		}
	},
	{
		Id = "candy_master",
		Name = "Candy Master",
		Description = "Collect all candy pets",
		World = "CandyKingdom",
		Type = "World",
		Requirement = {
			Type = "CollectUniquePets",
			Amount = 7,
			World = "CandyKingdom"
		},
		Rewards = {
			Coins = 25000,
			Experience = 250,
			Pet = "candy_king"
		}
	},
	
	-- Space Station Quests
	{
		Id = "space_explorer",
		Name = "Space Explorer",
		Description = "Reach the Space Station",
		World = "SpaceStation",
		Type = "World",
		Requirement = {
			Type = "UnlockWorld",
			World = "SpaceStation"
		},
		Rewards = {
			Coins = 50000,
			Experience = 300
		}
	},
	{
		Id = "space_commander",
		Name = "Space Commander",
		Description = "Collect all space pets",
		World = "SpaceStation",
		Type = "World",
		Requirement = {
			Type = "CollectUniquePets",
			Amount = 7,
			World = "SpaceStation"
		},
		Rewards = {
			Coins = 100000,
			Experience = 500,
			Pet = "space_void"
		}
	},
	
	-- Underwater Depths Quests
	{
		Id = "ocean_diver",
		Name = "Deep Sea Diver",
		Description = "Explore the Underwater Depths",
		World = "UnderwaterDepths",
		Type = "World",
		Requirement = {
			Type = "UnlockWorld",
			World = "UnderwaterDepths"
		},
		Rewards = {
			Coins = 200000,
			Experience = 600
		}
	},
	{
		Id = "ocean_master",
		Name = "Ocean Master",
		Description = "Collect all underwater pets",
		World = "UnderwaterDepths",
		Type = "World",
		Requirement = {
			Type = "CollectUniquePets",
			Amount = 7,
			World = "UnderwaterDepths"
		},
		Rewards = {
			Coins = 500000,
			Experience = 1000,
			Pet = "water_kraken"
		}
	},
	
	-- Volcanic Wasteland Quests
	{
		Id = "volcano_survivor",
		Name = "Volcano Survivor",
		Description = "Survive the Volcanic Wasteland",
		World = "VolcanicWasteland",
		Type = "World",
		Requirement = {
			Type = "UnlockWorld",
			World = "VolcanicWasteland"
		},
		Rewards = {
			Coins = 1000000,
			Experience = 1500
		}
	},
	{
		Id = "volcano_lord",
		Name = "Volcano Lord",
		Description = "Collect all volcanic pets",
		World = "VolcanicWasteland",
		Type = "World",
		Requirement = {
			Type = "CollectUniquePets",
			Amount = 7,
			World = "VolcanicWasteland"
		},
		Rewards = {
			Coins = 2000000,
			Experience = 2500,
			Pet = "volcano_titan"
		}
	},
	
	-- Crystal Caves Quests
	{
		Id = "crystal_miner",
		Name = "Crystal Miner",
		Description = "Discover the Crystal Caves",
		World = "CrystalCaves",
		Type = "World",
		Requirement = {
			Type = "UnlockWorld",
			World = "CrystalCaves"
		},
		Rewards = {
			Coins = 5000000,
			Experience = 3000
		}
	},
	{
		Id = "crystal_deity",
		Name = "Crystal Deity",
		Description = "Collect all crystal pets",
		World = "CrystalCaves",
		Type = "World",
		Requirement = {
			Type = "CollectUniquePets",
			Amount = 7,
			World = "CrystalCaves"
		},
		Rewards = {
			Coins = 10000000,
			Experience = 5000,
			Pet = "crystal_deity"
		}
	}
}

-- Achievement Quests
QuestConfig.Achievements = {
	{
		Id = "achievement_hatch_100",
		Name = "Egg Master",
		Description = "Hatch 100 eggs",
		Type = "Achievement",
		Requirement = {
			Type = "HatchEggs",
			Amount = 100
		},
		Rewards = {
			Coins = 10000,
			Experience = 500,
			Title = "Egg Master"
		}
	},
	{
		Id = "achievement_hatch_1000",
		Name = "Legendary Hatcher",
		Description = "Hatch 1,000 eggs",
		Type = "Achievement",
		Requirement = {
			Type = "HatchEggs",
			Amount = 1000
		},
		Rewards = {
			Coins = 100000,
			Experience = 2000,
			Title = "Legendary Hatcher"
		}
	},
	{
		Id = "achievement_merge_50",
		Name = "Merge Expert",
		Description = "Merge 50 pets",
		Type = "Achievement",
		Requirement = {
			Type = "MergePets",
			Amount = 50
		},
		Rewards = {
			Coins = 25000,
			Experience = 750,
			Title = "Merge Expert"
		}
	},
	{
		Id = "achievement_collect_50",
		Name = "Pet Collector",
		Description = "Collect 50 unique pets",
		Type = "Achievement",
		Requirement = {
			Type = "CollectUniquePets",
			Amount = 50
		},
		Rewards = {
			Coins = 50000,
			Experience = 1500,
			Title = "Pet Collector"
		}
	},
	{
		Id = "achievement_coins_1m",
		Name = "Millionaire",
		Description = "Collect 1,000,000 total coins",
		Type = "Achievement",
		Requirement = {
			Type = "CollectCoins",
			Amount = 1000000
		},
		Rewards = {
			Coins = 100000,
			Experience = 2000,
			Title = "Millionaire"
		}
	},
	{
		Id = "achievement_trade_10",
		Name = "Trading Expert",
		Description = "Complete 10 trades",
		Type = "Achievement",
		Requirement = {
			Type = "CompleteTrades",
			Amount = 10
		},
		Rewards = {
			Coins = 15000,
			Experience = 600,
			Title = "Trading Expert"
		}
	},
	{
		Id = "achievement_all_worlds",
		Name = "World Explorer",
		Description = "Unlock all worlds",
		Type = "Achievement",
		Requirement = {
			Type = "UnlockAllWorlds"
		},
		Rewards = {
			Coins = 500000,
			Experience = 5000,
			Title = "World Explorer"
		}
	},
	{
		Id = "achievement_mythical",
		Name = "Mythical Master",
		Description = "Collect 5 mythical pets",
		Type = "Achievement",
		Requirement = {
			Type = "CollectRarity",
			Rarity = "Mythical",
			Amount = 5
		},
		Rewards = {
			Coins = 1000000,
			Experience = 10000,
			Title = "Mythical Master"
		}
	}
}

-- Legendary Quests (Unlock mythical pets)
QuestConfig.LegendaryQuests = {
	{
		Id = "legendary_forest_spirit",
		Name = "Awaken the Forest Spirit",
		Description = "Complete all forest quests and merge 10 forest pets",
		Type = "Legendary",
		Requirement = {
			Type = "CompleteQuests",
			Quests = {"forest_welcome", "forest_collector"},
			AdditionalRequirement = {
				Type = "MergePets",
				Amount = 10,
				World = "StarterForest"
			}
		},
		Rewards = {
			Pet = "forest_spirit",
			Experience = 1000
		}
	},
	{
		Id = "legendary_candy_king",
		Name = "Crown the Candy King",
		Description = "Collect all candy pets and merge 20 candy pets",
		Type = "Legendary",
		Requirement = {
			Type = "CompleteQuests",
			Quests = {"candy_sweet_tooth", "candy_master"},
			AdditionalRequirement = {
				Type = "MergePets",
				Amount = 20,
				World = "CandyKingdom"
			}
		},
		Rewards = {
			Pet = "candy_king",
			Experience = 2000
		}
	}
}

-- Get quest data by ID
function QuestConfig.GetQuestData(questId)
	-- Check daily quests
	for _, quest in ipairs(QuestConfig.DailyQuests) do
		if quest.Id == questId then
			return quest
		end
	end
	
	-- Check world quests
	for _, quest in ipairs(QuestConfig.WorldQuests) do
		if quest.Id == questId then
			return quest
		end
	end
	
	-- Check achievements
	for _, quest in ipairs(QuestConfig.Achievements) do
		if quest.Id == questId then
			return quest
		end
	end
	
	-- Check legendary quests
	for _, quest in ipairs(QuestConfig.LegendaryQuests) do
		if quest.Id == questId then
			return quest
		end
	end
	
	return nil
end

-- Get quests by type
function QuestConfig.GetQuestsByType(questType)
	if questType == "Daily" then
		return QuestConfig.DailyQuests
	elseif questType == "World" then
		return QuestConfig.WorldQuests
	elseif questType == "Achievement" then
		return QuestConfig.Achievements
	elseif questType == "Legendary" then
		return QuestConfig.LegendaryQuests
	end
	return {}
end

-- Get quests by world
function QuestConfig.GetQuestsByWorld(worldId)
	local quests = {}
	for _, quest in ipairs(QuestConfig.WorldQuests) do
		if quest.World == worldId then
			table.insert(quests, quest)
		end
	end
	return quests
end

return QuestConfig