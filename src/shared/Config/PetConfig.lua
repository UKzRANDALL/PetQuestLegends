-- Pet Quest Legends - Pet Configuration
-- Defines all pets, their stats, abilities, and rarities

local PetConfig = {}

-- Rarity multipliers and colors
PetConfig.Rarities = {
	Common = {
		Chance = 60,
		Color = Color3.fromRGB(150, 150, 150),
		BaseMultiplier = 1,
		ParticleColor = ColorSequence.new(Color3.fromRGB(200, 200, 200))
	},
	Rare = {
		Chance = 25,
		Color = Color3.fromRGB(100, 150, 255),
		BaseMultiplier = 2,
		ParticleColor = ColorSequence.new(Color3.fromRGB(100, 150, 255))
	},
	Epic = {
		Chance = 10,
		Color = Color3.fromRGB(150, 50, 200),
		BaseMultiplier = 5,
		ParticleColor = ColorSequence.new(Color3.fromRGB(150, 50, 200))
	},
	Legendary = {
		Chance = 4,
		Color = Color3.fromRGB(255, 200, 0),
		BaseMultiplier = 15,
		ParticleColor = ColorSequence.new(Color3.fromRGB(255, 200, 0))
	},
	Mythical = {
		Chance = 1,
		Color = Color3.fromRGB(255, 50, 50),
		BaseMultiplier = 50,
		ParticleColor = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 50, 50)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 0)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 50, 50))
		})
	}
}

-- Pet abilities
PetConfig.Abilities = {
	Fire = {
		Name = "Flame Collector",
		Description = "Melts coins faster",
		Effect = "CoinSpeedBoost",
		Value = 1.5
	},
	Flying = {
		Name = "Sky Reach",
		Description = "Reach high-value coin areas",
		Effect = "RangeBoost",
		Value = 2.0
	},
	Ice = {
		Name = "Time Freeze",
		Description = "Freeze time for bonus collection",
		Effect = "TimeBonus",
		Value = 1.3
	},
	Shadow = {
		Name = "Shadow Grasp",
		Description = "Collect coins from further away",
		Effect = "CollectionRange",
		Value = 1.8
	},
	None = {
		Name = "None",
		Description = "No special ability",
		Effect = "None",
		Value = 1.0
	}
}

-- Pet definitions
PetConfig.Pets = {
	-- STARTER FOREST PETS
	{
		Id = "forest_bunny",
		Name = "Forest Bunny",
		Rarity = "Common",
		World = "StarterForest",
		Ability = "None",
		BaseValue = 100,
		Description = "A cute bunny from the forest"
	},
	{
		Id = "forest_fox",
		Name = "Forest Fox",
		Rarity = "Common",
		World = "StarterForest",
		Ability = "None",
		BaseValue = 150,
		Description = "A clever fox that loves to play"
	},
	{
		Id = "forest_deer",
		Name = "Forest Deer",
		Rarity = "Rare",
		World = "StarterForest",
		Ability = "None",
		BaseValue = 300,
		Description = "A graceful deer with antlers"
	},
	{
		Id = "forest_owl",
		Name = "Forest Owl",
		Rarity = "Rare",
		World = "StarterForest",
		Ability = "Flying",
		BaseValue = 400,
		Description = "A wise owl that flies at night"
	},
	{
		Id = "forest_bear",
		Name = "Forest Bear",
		Rarity = "Epic",
		World = "StarterForest",
		Ability = "None",
		BaseValue = 800,
		Description = "A strong bear protecting the forest"
	},
	{
		Id = "forest_phoenix",
		Name = "Forest Phoenix",
		Rarity = "Legendary",
		World = "StarterForest",
		Ability = "Fire",
		BaseValue = 2000,
		Description = "A legendary bird of rebirth"
	},
	{
		Id = "forest_spirit",
		Name = "Forest Spirit",
		Rarity = "Mythical",
		World = "StarterForest",
		Ability = "Shadow",
		BaseValue = 5000,
		Description = "The ancient guardian of the forest"
	},
	
	-- CANDY KINGDOM PETS
	{
		Id = "candy_gummy",
		Name = "Gummy Bear",
		Rarity = "Common",
		World = "CandyKingdom",
		Ability = "None",
		BaseValue = 500,
		Description = "A bouncy gummy bear"
	},
	{
		Id = "candy_lollipop",
		Name = "Lollipop Pup",
		Rarity = "Common",
		World = "CandyKingdom",
		Ability = "None",
		BaseValue = 600,
		Description = "A sweet puppy made of candy"
	},
	{
		Id = "candy_chocolate",
		Name = "Chocolate Bunny",
		Rarity = "Rare",
		World = "CandyKingdom",
		Ability = "None",
		BaseValue = 1200,
		Description = "A delicious chocolate rabbit"
	},
	{
		Id = "candy_cotton",
		Name = "Cotton Cloud",
		Rarity = "Rare",
		World = "CandyKingdom",
		Ability = "Flying",
		BaseValue = 1500,
		Description = "A fluffy cotton candy cloud"
	},
	{
		Id = "candy_jawbreaker",
		Name = "Jawbreaker Dragon",
		Rarity = "Epic",
		World = "CandyKingdom",
		Ability = "Fire",
		BaseValue = 3000,
		Description = "A colorful dragon made of jawbreakers"
	},
	{
		Id = "candy_unicorn",
		Name = "Candy Unicorn",
		Rarity = "Legendary",
		World = "CandyKingdom",
		Ability = "Ice",
		BaseValue = 7500,
		Description = "A magical unicorn of pure sugar"
	},
	{
		Id = "candy_king",
		Name = "Candy King",
		Rarity = "Mythical",
		World = "CandyKingdom",
		Ability = "Shadow",
		BaseValue = 15000,
		Description = "The ruler of all candy"
	},
	
	-- SPACE STATION PETS
	{
		Id = "space_alien",
		Name = "Space Alien",
		Rarity = "Common",
		World = "SpaceStation",
		Ability = "None",
		BaseValue = 2000,
		Description = "A friendly alien visitor"
	},
	{
		Id = "space_robot",
		Name = "Robot Companion",
		Rarity = "Common",
		World = "SpaceStation",
		Ability = "None",
		BaseValue = 2500,
		Description = "A helpful robot assistant"
	},
	{
		Id = "space_satellite",
		Name = "Satellite Pet",
		Rarity = "Rare",
		World = "SpaceStation",
		Ability = "Flying",
		BaseValue = 5000,
		Description = "A floating satellite companion"
	},
	{
		Id = "space_comet",
		Name = "Comet Pup",
		Rarity = "Rare",
		World = "SpaceStation",
		Ability = "Fire",
		BaseValue = 6000,
		Description = "A blazing comet puppy"
	},
	{
		Id = "space_nebula",
		Name = "Nebula Cat",
		Rarity = "Epic",
		World = "SpaceStation",
		Ability = "Shadow",
		BaseValue = 12000,
		Description = "A cosmic cat from the nebula"
	},
	{
		Id = "space_galaxy",
		Name = "Galaxy Dragon",
		Rarity = "Legendary",
		World = "SpaceStation",
		Ability = "Fire",
		BaseValue = 30000,
		Description = "A dragon containing entire galaxies"
	},
	{
		Id = "space_void",
		Name = "Void Entity",
		Rarity = "Mythical",
		World = "SpaceStation",
		Ability = "Shadow",
		BaseValue = 75000,
		Description = "A being from beyond space and time"
	},
	
	-- UNDERWATER DEPTHS PETS
	{
		Id = "water_fish",
		Name = "Tropical Fish",
		Rarity = "Common",
		World = "UnderwaterDepths",
		Ability = "None",
		BaseValue = 8000,
		Description = "A colorful tropical fish"
	},
	{
		Id = "water_crab",
		Name = "Hermit Crab",
		Rarity = "Common",
		World = "UnderwaterDepths",
		Ability = "None",
		BaseValue = 9000,
		Description = "A shy crab with a shell"
	},
	{
		Id = "water_seahorse",
		Name = "Sea Horse",
		Rarity = "Rare",
		World = "UnderwaterDepths",
		Ability = "None",
		BaseValue = 18000,
		Description = "An elegant seahorse"
	},
	{
		Id = "water_jellyfish",
		Name = "Jellyfish",
		Rarity = "Rare",
		World = "UnderwaterDepths",
		Ability = "Flying",
		BaseValue = 20000,
		Description = "A glowing jellyfish"
	},
	{
		Id = "water_octopus",
		Name = "Octopus",
		Rarity = "Epic",
		World = "UnderwaterDepths",
		Ability = "Shadow",
		BaseValue = 40000,
		Description = "An intelligent octopus"
	},
	{
		Id = "water_whale",
		Name = "Cosmic Whale",
		Rarity = "Legendary",
		World = "UnderwaterDepths",
		Ability = "Ice",
		BaseValue = 100000,
		Description = "A massive whale from the depths"
	},
	{
		Id = "water_kraken",
		Name = "Kraken",
		Rarity = "Mythical",
		World = "UnderwaterDepths",
		Ability = "Shadow",
		BaseValue = 250000,
		Description = "The legendary sea monster"
	},
	
	-- VOLCANIC WASTELAND PETS
	{
		Id = "volcano_lizard",
		Name = "Lava Lizard",
		Rarity = "Common",
		World = "VolcanicWasteland",
		Ability = "Fire",
		BaseValue = 30000,
		Description = "A lizard that loves heat"
	},
	{
		Id = "volcano_salamander",
		Name = "Fire Salamander",
		Rarity = "Common",
		World = "VolcanicWasteland",
		Ability = "Fire",
		BaseValue = 35000,
		Description = "A salamander born in flames"
	},
	{
		Id = "volcano_golem",
		Name = "Magma Golem",
		Rarity = "Rare",
		World = "VolcanicWasteland",
		Ability = "Fire",
		BaseValue = 70000,
		Description = "A golem made of molten rock"
	},
	{
		Id = "volcano_phoenix",
		Name = "Volcanic Phoenix",
		Rarity = "Rare",
		World = "VolcanicWasteland",
		Ability = "Fire",
		BaseValue = 80000,
		Description = "A phoenix reborn in lava"
	},
	{
		Id = "volcano_demon",
		Name = "Flame Demon",
		Rarity = "Epic",
		World = "VolcanicWasteland",
		Ability = "Fire",
		BaseValue = 160000,
		Description = "A demon from the volcanic depths"
	},
	{
		Id = "volcano_dragon",
		Name = "Inferno Dragon",
		Rarity = "Legendary",
		World = "VolcanicWasteland",
		Ability = "Fire",
		BaseValue = 400000,
		Description = "The ultimate fire dragon"
	},
	{
		Id = "volcano_titan",
		Name = "Volcanic Titan",
		Rarity = "Mythical",
		World = "VolcanicWasteland",
		Ability = "Fire",
		BaseValue = 1000000,
		Description = "The ancient titan of fire"
	},
	
	-- CRYSTAL CAVES PETS
	{
		Id = "crystal_bat",
		Name = "Crystal Bat",
		Rarity = "Common",
		World = "CrystalCaves",
		Ability = "Flying",
		BaseValue = 100000,
		Description = "A bat with crystal wings"
	},
	{
		Id = "crystal_spider",
		Name = "Gem Spider",
		Rarity = "Common",
		World = "CrystalCaves",
		Ability = "None",
		BaseValue = 120000,
		Description = "A spider that weaves crystal webs"
	},
	{
		Id = "crystal_fox",
		Name = "Crystal Fox",
		Rarity = "Rare",
		World = "CrystalCaves",
		Ability = "Ice",
		BaseValue = 240000,
		Description = "A fox made of pure crystal"
	},
	{
		Id = "crystal_wolf",
		Name = "Diamond Wolf",
		Rarity = "Rare",
		World = "CrystalCaves",
		Ability = "Ice",
		BaseValue = 280000,
		Description = "A wolf with diamond fur"
	},
	{
		Id = "crystal_golem",
		Name = "Crystal Golem",
		Rarity = "Epic",
		World = "CrystalCaves",
		Ability = "Shadow",
		BaseValue = 560000,
		Description = "A massive crystal guardian"
	},
	{
		Id = "crystal_unicorn",
		Name = "Prismatic Unicorn",
		Rarity = "Legendary",
		World = "CrystalCaves",
		Ability = "Ice",
		BaseValue = 1400000,
		Description = "A unicorn that refracts light"
	},
	{
		Id = "crystal_deity",
		Name = "Crystal Deity",
		Rarity = "Mythical",
		World = "CrystalCaves",
		Ability = "Shadow",
		BaseValue = 3500000,
		Description = "The god of all crystals"
	},
	
	-- PREMIUM EGGS - Galaxy Egg
	{
		Id = "galaxy_star",
		Name = "Star Sprite",
		Rarity = "Rare",
		World = "Premium",
		Ability = "Flying",
		BaseValue = 500000,
		Description = "A sprite made of starlight",
		Premium = true,
		EggType = "Galaxy"
	},
	{
		Id = "galaxy_planet",
		Name = "Planet Guardian",
		Rarity = "Epic",
		World = "Premium",
		Ability = "Shadow",
		BaseValue = 1000000,
		Description = "A guardian of planets",
		Premium = true,
		EggType = "Galaxy"
	},
	{
		Id = "galaxy_supernova",
		Name = "Supernova Phoenix",
		Rarity = "Legendary",
		World = "Premium",
		Ability = "Fire",
		BaseValue = 2500000,
		Description = "A phoenix born from a supernova",
		Premium = true,
		EggType = "Galaxy"
	},
	{
		Id = "galaxy_universe",
		Name = "Universe Dragon",
		Rarity = "Mythical",
		World = "Premium",
		Ability = "Shadow",
		BaseValue = 10000000,
		Description = "A dragon containing the universe",
		Premium = true,
		EggType = "Galaxy"
	},
	
	-- PREMIUM EGGS - Rainbow Egg
	{
		Id = "rainbow_butterfly",
		Name = "Rainbow Butterfly",
		Rarity = "Rare",
		World = "Premium",
		Ability = "Flying",
		BaseValue = 500000,
		Description = "A butterfly with rainbow wings",
		Premium = true,
		EggType = "Rainbow"
	},
	{
		Id = "rainbow_tiger",
		Name = "Rainbow Tiger",
		Rarity = "Epic",
		World = "Premium",
		Ability = "Fire",
		BaseValue = 1000000,
		Description = "A tiger with rainbow stripes",
		Premium = true,
		EggType = "Rainbow"
	},
	{
		Id = "rainbow_pegasus",
		Name = "Rainbow Pegasus",
		Rarity = "Legendary",
		World = "Premium",
		Ability = "Flying",
		BaseValue = 2500000,
		Description = "A pegasus trailing rainbows",
		Premium = true,
		EggType = "Rainbow"
	},
	{
		Id = "rainbow_deity",
		Name = "Rainbow Deity",
		Rarity = "Mythical",
		World = "Premium",
		Ability = "Shadow",
		BaseValue = 10000000,
		Description = "The embodiment of all colors",
		Premium = true,
		EggType = "Rainbow"
	},
	
	-- PREMIUM EGGS - Shadow Egg
	{
		Id = "shadow_wolf",
		Name = "Shadow Wolf",
		Rarity = "Rare",
		World = "Premium",
		Ability = "Shadow",
		BaseValue = 500000,
		Description = "A wolf made of shadows",
		Premium = true,
		EggType = "Shadow"
	},
	{
		Id = "shadow_panther",
		Name = "Shadow Panther",
		Rarity = "Epic",
		World = "Premium",
		Ability = "Shadow",
		BaseValue = 1000000,
		Description = "A panther that moves through darkness",
		Premium = true,
		EggType = "Shadow"
	},
	{
		Id = "shadow_reaper",
		Name = "Shadow Reaper",
		Rarity = "Legendary",
		World = "Premium",
		Ability = "Shadow",
		BaseValue = 2500000,
		Description = "A reaper from the void",
		Premium = true,
		EggType = "Shadow"
	},
	{
		Id = "shadow_overlord",
		Name = "Shadow Overlord",
		Rarity = "Mythical",
		World = "Premium",
		Ability = "Shadow",
		BaseValue = 10000000,
		Description = "The master of all shadows",
		Premium = true,
		EggType = "Shadow"
	}
}

-- Calculate pet value based on rarity and merge level
function PetConfig.CalculatePetValue(petId, mergeLevel)
	local petData = PetConfig.GetPetData(petId)
	if not petData then return 0 end
	
	local rarityData = PetConfig.Rarities[petData.Rarity]
	local baseValue = petData.BaseValue
	local multiplier = rarityData.BaseMultiplier
	
	-- Each merge level multiplies value by 2
	local mergeMultiplier = math.pow(2, mergeLevel)
	
	return baseValue * multiplier * mergeMultiplier
end

-- Get pet data by ID
function PetConfig.GetPetData(petId)
	for _, pet in ipairs(PetConfig.Pets) do
		if pet.Id == petId then
			return pet
		end
	end
	return nil
end

-- Get pets by world
function PetConfig.GetPetsByWorld(worldName)
	local pets = {}
	for _, pet in ipairs(PetConfig.Pets) do
		if pet.World == worldName then
			table.insert(pets, pet)
		end
	end
	return pets
end

-- Get pets by rarity
function PetConfig.GetPetsByRarity(rarity)
	local pets = {}
	for _, pet in ipairs(PetConfig.Pets) do
		if pet.Rarity == rarity then
			table.insert(pets, pet)
		end
	end
	return pets
end

return PetConfig