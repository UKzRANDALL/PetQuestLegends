-- Pet Quest Legends - World Configuration
-- Defines all worlds, their requirements, and properties

local WorldConfig = {}

WorldConfig.Worlds = {
	{
		Id = "StarterForest",
		Name = "Starter Forest",
		Description = "A peaceful forest where your journey begins",
		UnlockCost = 0,
		RequiredLevel = 0,
		SpawnPosition = Vector3.new(0, 5, 0),
		Theme = {
			SkyColor = Color3.fromRGB(135, 206, 235),
			AmbientColor = Color3.fromRGB(100, 150, 100),
			FogColor = Color3.fromRGB(200, 220, 200),
			FogEnd = 500,
			FogStart = 100
		},
		CoinSpawns = {
			MinValue = 1,
			MaxValue = 10,
			SpawnRate = 2, -- seconds
			MaxCoins = 50
		},
		EggCost = 100,
		AvailableEggs = {"BasicEgg"}
	},
	{
		Id = "CandyKingdom",
		Name = "Candy Kingdom",
		Description = "A sweet world made entirely of candy",
		UnlockCost = 10000,
		RequiredLevel = 5,
		SpawnPosition = Vector3.new(500, 5, 0),
		Theme = {
			SkyColor = Color3.fromRGB(255, 192, 203),
			AmbientColor = Color3.fromRGB(255, 150, 200),
			FogColor = Color3.fromRGB(255, 200, 220),
			FogEnd = 600,
			FogStart = 150
		},
		CoinSpawns = {
			MinValue = 5,
			MaxValue = 50,
			SpawnRate = 1.8,
			MaxCoins = 60
		},
		EggCost = 500,
		AvailableEggs = {"CandyEgg"}
	},
	{
		Id = "SpaceStation",
		Name = "Space Station",
		Description = "A futuristic station orbiting distant planets",
		UnlockCost = 100000,
		RequiredLevel = 10,
		SpawnPosition = Vector3.new(1000, 5, 0),
		Theme = {
			SkyColor = Color3.fromRGB(10, 10, 30),
			AmbientColor = Color3.fromRGB(50, 50, 100),
			FogColor = Color3.fromRGB(20, 20, 50),
			FogEnd = 800,
			FogStart = 200
		},
		CoinSpawns = {
			MinValue = 20,
			MaxValue = 200,
			SpawnRate = 1.5,
			MaxCoins = 70
		},
		EggCost = 2000,
		AvailableEggs = {"SpaceEgg"}
	},
	{
		Id = "UnderwaterDepths",
		Name = "Underwater Depths",
		Description = "Explore the mysterious ocean floor",
		UnlockCost = 500000,
		RequiredLevel = 15,
		SpawnPosition = Vector3.new(1500, 5, 0),
		Theme = {
			SkyColor = Color3.fromRGB(0, 50, 100),
			AmbientColor = Color3.fromRGB(50, 100, 150),
			FogColor = Color3.fromRGB(0, 100, 150),
			FogEnd = 400,
			FogStart = 50
		},
		CoinSpawns = {
			MinValue = 80,
			MaxValue = 800,
			SpawnRate = 1.3,
			MaxCoins = 80
		},
		EggCost = 8000,
		AvailableEggs = {"OceanEgg"}
	},
	{
		Id = "VolcanicWasteland",
		Name = "Volcanic Wasteland",
		Description = "A dangerous land of fire and lava",
		UnlockCost = 2000000,
		RequiredLevel = 20,
		SpawnPosition = Vector3.new(2000, 5, 0),
		Theme = {
			SkyColor = Color3.fromRGB(100, 30, 0),
			AmbientColor = Color3.fromRGB(150, 50, 0),
			FogColor = Color3.fromRGB(200, 100, 0),
			FogEnd = 500,
			FogStart = 100
		},
		CoinSpawns = {
			MinValue = 300,
			MaxValue = 3000,
			SpawnRate = 1.0,
			MaxCoins = 90
		},
		EggCost = 30000,
		AvailableEggs = {"VolcanoEgg"}
	},
	{
		Id = "CrystalCaves",
		Name = "Crystal Caves",
		Description = "Glittering caves filled with precious gems",
		UnlockCost = 10000000,
		RequiredLevel = 25,
		SpawnPosition = Vector3.new(2500, 5, 0),
		Theme = {
			SkyColor = Color3.fromRGB(150, 100, 200),
			AmbientColor = Color3.fromRGB(200, 150, 255),
			FogColor = Color3.fromRGB(180, 150, 220),
			FogEnd = 600,
			FogStart = 150
		},
		CoinSpawns = {
			MinValue = 1000,
			MaxValue = 10000,
			SpawnRate = 0.8,
			MaxCoins = 100
		},
		EggCost = 100000,
		AvailableEggs = {"CrystalEgg"}
	}
}

-- Egg configurations
WorldConfig.Eggs = {
	BasicEgg = {
		Name = "Basic Egg",
		Cost = 100,
		World = "StarterForest",
		HatchTime = 3, -- seconds
		Pets = {"forest_bunny", "forest_fox", "forest_deer", "forest_owl", "forest_bear", "forest_phoenix", "forest_spirit"}
	},
	CandyEgg = {
		Name = "Candy Egg",
		Cost = 500,
		World = "CandyKingdom",
		HatchTime = 4,
		Pets = {"candy_gummy", "candy_lollipop", "candy_chocolate", "candy_cotton", "candy_jawbreaker", "candy_unicorn", "candy_king"}
	},
	SpaceEgg = {
		Name = "Space Egg",
		Cost = 2000,
		World = "SpaceStation",
		HatchTime = 5,
		Pets = {"space_alien", "space_robot", "space_satellite", "space_comet", "space_nebula", "space_galaxy", "space_void"}
	},
	OceanEgg = {
		Name = "Ocean Egg",
		Cost = 8000,
		World = "UnderwaterDepths",
		HatchTime = 6,
		Pets = {"water_fish", "water_crab", "water_seahorse", "water_jellyfish", "water_octopus", "water_whale", "water_kraken"}
	},
	VolcanoEgg = {
		Name = "Volcano Egg",
		Cost = 30000,
		World = "VolcanicWasteland",
		HatchTime = 7,
		Pets = {"volcano_lizard", "volcano_salamander", "volcano_golem", "volcano_phoenix", "volcano_demon", "volcano_dragon", "volcano_titan"}
	},
	CrystalEgg = {
		Name = "Crystal Egg",
		Cost = 100000,
		World = "CrystalCaves",
		HatchTime = 8,
		Pets = {"crystal_bat", "crystal_spider", "crystal_fox", "crystal_wolf", "crystal_golem", "crystal_unicorn", "crystal_deity"}
	},
	-- Premium Eggs
	GalaxyEgg = {
		Name = "Galaxy Egg",
		Cost = 399, -- Robux
		World = "Premium",
		HatchTime = 5,
		Premium = true,
		Pets = {"galaxy_star", "galaxy_planet", "galaxy_supernova", "galaxy_universe"}
	},
	RainbowEgg = {
		Name = "Rainbow Egg",
		Cost = 399, -- Robux
		World = "Premium",
		HatchTime = 5,
		Premium = true,
		Pets = {"rainbow_butterfly", "rainbow_tiger", "rainbow_pegasus", "rainbow_deity"}
	},
	ShadowEgg = {
		Name = "Shadow Egg",
		Cost = 399, -- Robux
		World = "Premium",
		HatchTime = 5,
		Premium = true,
		Pets = {"shadow_wolf", "shadow_panther", "shadow_reaper", "shadow_overlord"}
	}
}

-- Get world data by ID
function WorldConfig.GetWorldData(worldId)
	for _, world in ipairs(WorldConfig.Worlds) do
		if world.Id == worldId then
			return world
		end
	end
	return nil
end

-- Get egg data by ID
function WorldConfig.GetEggData(eggId)
	return WorldConfig.Eggs[eggId]
end

-- Check if player can unlock world
function WorldConfig.CanUnlockWorld(worldId, playerCoins, playerLevel)
	local worldData = WorldConfig.GetWorldData(worldId)
	if not worldData then return false end
	
	return playerCoins >= worldData.UnlockCost and playerLevel >= worldData.RequiredLevel
end

-- Get next world to unlock
function WorldConfig.GetNextWorld(currentWorldId)
	local foundCurrent = false
	for _, world in ipairs(WorldConfig.Worlds) do
		if foundCurrent then
			return world
		end
		if world.Id == currentWorldId then
			foundCurrent = true
		end
	end
	return nil
end

return WorldConfig