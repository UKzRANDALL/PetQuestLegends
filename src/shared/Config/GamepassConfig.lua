-- Pet Quest Legends - Gamepass Configuration
-- Defines all gamepasses and their effects

local GamepassConfig = {}

GamepassConfig.Gamepasses = {
	VIP = {
		Id = 0, -- Replace with actual gamepass ID from Roblox
		Name = "VIP",
		Description = "Access to VIP area, exclusive eggs, and VIP-only pets",
		Price = 299, -- Robux
		Icon = "rbxassetid://0", -- Replace with actual icon asset ID
		Benefits = {
			"Access to VIP-only area",
			"Exclusive VIP eggs",
			"VIP-only pets",
			"VIP chat tag",
			"Priority in trading"
		},
		Effects = {
			VIPAccess = true,
			VIPEggs = true,
			ChatTag = "[VIP]"
		}
	},
	
	HatchSpeed2x = {
		Id = 0, -- Replace with actual gamepass ID
		Name = "2x Hatch Speed",
		Description = "Hatch eggs twice as fast",
		Price = 199,
		Icon = "rbxassetid://0",
		Benefits = {
			"Hatch eggs 2x faster",
			"Permanent boost",
			"Works on all eggs"
		},
		Effects = {
			HatchSpeedMultiplier = 2
		}
	},
	
	Coins3x = {
		Id = 0, -- Replace with actual gamepass ID
		Name = "3x Coins",
		Description = "Earn coins 3x faster",
		Price = 399,
		Icon = "rbxassetid://0",
		Benefits = {
			"Earn 3x more coins",
			"Permanent boost",
			"Stacks with other boosts"
		},
		Effects = {
			CoinMultiplier = 3
		}
	},
	
	AutoHatch = {
		Id = 0, -- Replace with actual gamepass ID
		Name = "Auto-Hatch",
		Description = "Automatically hatch eggs while AFK",
		Price = 499,
		Icon = "rbxassetid://0",
		Benefits = {
			"Auto-hatch eggs",
			"Works while AFK",
			"Configurable settings",
			"Hatch up to 3 eggs at once"
		},
		Effects = {
			AutoHatch = true,
			MaxAutoHatch = 3
		}
	},
	
	ExtraPetSlots = {
		Id = 0, -- Replace with actual gamepass ID
		Name = "Extra Pet Slots",
		Description = "Equip more pets at once (up to 50)",
		Price = 299,
		Icon = "rbxassetid://0",
		Benefits = {
			"Equip up to 50 pets",
			"Increased coin earning",
			"More pet abilities active"
		},
		Effects = {
			MaxEquippedPets = 50
		}
	},
	
	FastTravel = {
		Id = 0, -- Replace with actual gamepass ID
		Name = "Fast Travel",
		Description = "Instantly teleport between worlds",
		Price = 149,
		Icon = "rbxassetid://0",
		Benefits = {
			"Instant world teleportation",
			"No cooldown",
			"Access from anywhere"
		},
		Effects = {
			FastTravel = true
		}
	}
}

-- Premium Eggs (Robux purchases)
GamepassConfig.PremiumEggs = {
	GalaxyEgg = {
		Name = "Galaxy Egg",
		Description = "Space-themed legendary pets with cosmic powers",
		Price = 399,
		Icon = "rbxassetid://0",
		ProductId = 0, -- Replace with actual product ID
		Rewards = {
			EggType = "GalaxyEgg",
			Amount = 1
		}
	},
	
	RainbowEgg = {
		Name = "Rainbow Egg",
		Description = "Colorful mythical pets with rainbow effects",
		Price = 399,
		Icon = "rbxassetid://0",
		ProductId = 0,
		Rewards = {
			EggType = "RainbowEgg",
			Amount = 1
		}
	},
	
	ShadowEgg = {
		Name = "Shadow Egg",
		Description = "Dark exclusive pets with shadow abilities",
		Price = 399,
		Icon = "rbxassetid://0",
		ProductId = 0,
		Rewards = {
			EggType = "ShadowEgg",
			Amount = 1
		}
	},
	
	-- Egg Bundles
	GalaxyEgg3Pack = {
		Name = "Galaxy Egg 3-Pack",
		Description = "3 Galaxy Eggs at a discounted price",
		Price = 999,
		Icon = "rbxassetid://0",
		ProductId = 0,
		Rewards = {
			EggType = "GalaxyEgg",
			Amount = 3
		}
	},
	
	RainbowEgg3Pack = {
		Name = "Rainbow Egg 3-Pack",
		Description = "3 Rainbow Eggs at a discounted price",
		Price = 999,
		Icon = "rbxassetid://0",
		ProductId = 0,
		Rewards = {
			EggType = "RainbowEgg",
			Amount = 3
		}
	},
	
	ShadowEgg3Pack = {
		Name = "Shadow Egg 3-Pack",
		Description = "3 Shadow Eggs at a discounted price",
		Price = 999,
		Icon = "rbxassetid://0",
		ProductId = 0,
		Rewards = {
			EggType = "ShadowEgg",
			Amount = 3
		}
	}
}

-- Boosts (Temporary Robux purchases)
GamepassConfig.Boosts = {
	Coins2x1Hour = {
		Name = "2x Coins (1 Hour)",
		Description = "Double your coin earnings for 1 hour",
		Price = 49,
		Icon = "rbxassetid://0",
		ProductId = 0,
		Duration = 3600, -- seconds
		Effects = {
			CoinMultiplier = 2
		}
	},
	
	Luck2x1Hour = {
		Name = "2x Luck (1 Hour)",
		Description = "Double your chances of rare pets for 1 hour",
		Price = 49,
		Icon = "rbxassetid://0",
		ProductId = 0,
		Duration = 3600,
		Effects = {
			LuckMultiplier = 2
		}
	},
	
	HatchSpeed2x1Hour = {
		Name = "2x Hatch Speed (1 Hour)",
		Description = "Hatch eggs twice as fast for 1 hour",
		Price = 49,
		Icon = "rbxassetid://0",
		ProductId = 0,
		Duration = 3600,
		Effects = {
			HatchSpeedMultiplier = 2
		}
	},
	
	-- Combo Boosts
	TripleBoost1Hour = {
		Name = "Triple Boost (1 Hour)",
		Description = "2x Coins, 2x Luck, and 2x Hatch Speed for 1 hour",
		Price = 99,
		Icon = "rbxassetid://0",
		ProductId = 0,
		Duration = 3600,
		Effects = {
			CoinMultiplier = 2,
			LuckMultiplier = 2,
			HatchSpeedMultiplier = 2
		}
	}
}

-- Pet Skins (Cosmetic Robux purchases)
GamepassConfig.PetSkins = {
	FireParticles = {
		Name = "Fire Particles",
		Description = "Add fire particle effects to any pet",
		Price = 99,
		Icon = "rbxassetid://0",
		ProductId = 0,
		Effect = "FireParticles"
	},
	
	SparkleParticles = {
		Name = "Sparkle Particles",
		Description = "Add sparkle particle effects to any pet",
		Price = 99,
		Icon = "rbxassetid://0",
		ProductId = 0,
		Effect = "SparkleParticles"
	},
	
	LightningParticles = {
		Name = "Lightning Particles",
		Description = "Add lightning particle effects to any pet",
		Price = 99,
		Icon = "rbxassetid://0",
		ProductId = 0,
		Effect = "LightningParticles"
	},
	
	RainbowTrail = {
		Name = "Rainbow Trail",
		Description = "Add a rainbow trail to any pet",
		Price = 149,
		Icon = "rbxassetid://0",
		ProductId = 0,
		Effect = "RainbowTrail"
	},
	
	GoldenSkin = {
		Name = "Golden Skin",
		Description = "Turn any pet golden",
		Price = 199,
		Icon = "rbxassetid://0",
		ProductId = 0,
		Effect = "GoldenSkin"
	},
	
	ShadowSkin = {
		Name = "Shadow Skin",
		Description = "Turn any pet into a shadow version",
		Price = 199,
		Icon = "rbxassetid://0",
		ProductId = 0,
		Effect = "ShadowSkin"
	}
}

-- Get gamepass data
function GamepassConfig.GetGamepassData(gamepassName)
	return GamepassConfig.Gamepasses[gamepassName]
end

-- Get premium egg data
function GamepassConfig.GetPremiumEggData(eggName)
	return GamepassConfig.PremiumEggs[eggName]
end

-- Get boost data
function GamepassConfig.GetBoostData(boostName)
	return GamepassConfig.Boosts[boostName]
end

-- Get pet skin data
function GamepassConfig.GetPetSkinData(skinName)
	return GamepassConfig.PetSkins[skinName]
end

-- Calculate total multipliers from gamepasses and boosts
function GamepassConfig.CalculateMultipliers(ownedGamepasses, activeBoosts)
	local multipliers = {
		Coins = 1,
		Luck = 1,
		HatchSpeed = 1
	}
	
	-- Apply gamepass multipliers
	for gamepassName, _ in pairs(ownedGamepasses) do
		local gamepass = GamepassConfig.Gamepasses[gamepassName]
		if gamepass and gamepass.Effects then
			if gamepass.Effects.CoinMultiplier then
				multipliers.Coins = multipliers.Coins * gamepass.Effects.CoinMultiplier
			end
			if gamepass.Effects.HatchSpeedMultiplier then
				multipliers.HatchSpeed = multipliers.HatchSpeed * gamepass.Effects.HatchSpeedMultiplier
			end
		end
	end
	
	-- Apply boost multipliers
	for boostName, _ in pairs(activeBoosts) do
		local boost = GamepassConfig.Boosts[boostName]
		if boost and boost.Effects then
			if boost.Effects.CoinMultiplier then
				multipliers.Coins = multipliers.Coins * boost.Effects.CoinMultiplier
			end
			if boost.Effects.LuckMultiplier then
				multipliers.Luck = multipliers.Luck * boost.Effects.LuckMultiplier
			end
			if boost.Effects.HatchSpeedMultiplier then
				multipliers.HatchSpeed = multipliers.HatchSpeed * boost.Effects.HatchSpeedMultiplier
			end
		end
	end
	
	return multipliers
end

return GamepassConfig