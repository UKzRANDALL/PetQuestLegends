# Pet Quest Legends - Configuration Guide

This guide explains how to configure and customize the game to your needs.

## Table of Contents
1. [Pet Configuration](#pet-configuration)
2. [World Configuration](#world-configuration)
3. [Quest Configuration](#quest-configuration)
4. [Gamepass Configuration](#gamepass-configuration)
5. [Guild Configuration](#guild-configuration)
6. [Balancing Tips](#balancing-tips)

---

## Pet Configuration

File: `src/shared/Config/PetConfig.lua`

### Adding New Pets

To add a new pet, add an entry to the `PetConfig.Pets` table:

```lua
{
    Id = "unique_pet_id",              -- Unique identifier
    Name = "Pet Display Name",         -- Name shown to players
    Rarity = "Common",                 -- Common, Rare, Epic, Legendary, Mythical
    World = "StarterForest",           -- Which world it belongs to
    Ability = "Fire",                  -- Fire, Flying, Ice, Shadow, None
    BaseValue = 100,                   -- Base coin value
    Description = "Pet description",   -- Flavor text
    Premium = false,                   -- Optional: true for premium eggs only
    EggType = "BasicEgg"              -- Optional: specific egg type
}
```

### Rarity System

Rarities are defined in `PetConfig.Rarities`:

```lua
Common = {
    Chance = 60,                       -- 60% drop chance
    Color = Color3.fromRGB(150, 150, 150),
    BaseMultiplier = 1,                -- Coin multiplier
    ParticleColor = ColorSequence.new(...)
}
```

**Balancing Tips:**
- Total chances should add up to 100
- Higher rarities should have significantly better multipliers
- Mythical pets should be very rare (1% or less)

### Pet Abilities

Abilities are defined in `PetConfig.Abilities`:

```lua
Fire = {
    Name = "Flame Collector",
    Description = "Melts coins faster",
    Effect = "CoinSpeedBoost",
    Value = 1.5                        -- 50% boost
}
```

**Available Effects:**
- `CoinSpeedBoost` - Collect coins faster
- `RangeBoost` - Collect from further away
- `TimeBonus` - Time-based bonuses
- `CollectionRange` - Increased collection radius

### Pet Value Calculation

Pet value is calculated as:
```
FinalValue = BaseValue × RarityMultiplier × (2 ^ MergeLevel)
```

Example:
- Common pet (BaseValue: 100, Multiplier: 1, Merge Level: 0) = 100
- Same pet at Merge Level 3 = 100 × 1 × (2^3) = 800

---

## World Configuration

File: `src/shared/Config/WorldConfig.lua`

### Adding New Worlds

Add to `WorldConfig.Worlds`:

```lua
{
    Id = "NewWorld",
    Name = "New World Name",
    Description = "World description",
    UnlockCost = 1000000,              -- Coins needed to unlock
    RequiredLevel = 15,                -- Player level required
    SpawnPosition = Vector3.new(x, y, z),
    Theme = {
        SkyColor = Color3.fromRGB(...),
        AmbientColor = Color3.fromRGB(...),
        FogColor = Color3.fromRGB(...),
        FogEnd = 500,
        FogStart = 100
    },
    CoinSpawns = {
        MinValue = 100,                -- Minimum coin value
        MaxValue = 1000,               -- Maximum coin value
        SpawnRate = 1.5,               -- Seconds between spawns
        MaxCoins = 80                  -- Max coins in world
    },
    EggCost = 10000,                   -- Cost to hatch eggs
    AvailableEggs = {"NewWorldEgg"}
}
```

### World Progression

Worlds should follow this progression pattern:
1. **Early Game** (Levels 1-5): Low costs, frequent rewards
2. **Mid Game** (Levels 10-20): Moderate costs, balanced rewards
3. **Late Game** (Levels 25+): High costs, premium rewards

**Recommended Unlock Costs:**
- World 1: 0 (starter)
- World 2: 10,000
- World 3: 100,000
- World 4: 500,000
- World 5: 2,000,000
- World 6: 10,000,000

### Egg Configuration

Add eggs to `WorldConfig.Eggs`:

```lua
NewWorldEgg = {
    Name = "New World Egg",
    Cost = 10000,
    World = "NewWorld",
    HatchTime = 5,                     -- Seconds to hatch
    Pets = {                           -- List of possible pets
        "pet_id_1",
        "pet_id_2",
        -- ...
    }
}
```

---

## Quest Configuration

File: `src/shared/Config/QuestConfig.lua`

### Quest Types

1. **Daily Quests** - Reset every 24 hours
2. **World Quests** - Specific to each world
3. **Achievements** - One-time permanent goals
4. **Legendary Quests** - Special unlock quests

### Adding Daily Quests

```lua
{
    Id = "daily_quest_id",
    Name = "Quest Name",
    Description = "Quest description",
    Type = "Daily",
    Requirement = {
        Type = "HatchEggs",            -- Quest type
        Amount = 10                    -- Required amount
    },
    Rewards = {
        Coins = 5000,
        Experience = 100
    }
}
```

**Available Requirement Types:**
- `HatchEggs` - Hatch X eggs
- `CollectCoins` - Collect X coins
- `MergePets` - Merge X pets
- `CompleteTrades` - Complete X trades
- `CollectUniquePets` - Collect X unique pets
- `UnlockWorld` - Unlock a specific world
- `CollectRarity` - Collect X pets of specific rarity

### Adding World Quests

```lua
{
    Id = "world_quest_id",
    Name = "Quest Name",
    Description = "Quest description",
    World = "StarterForest",           -- Required world
    Type = "World",
    Requirement = {
        Type = "CollectUniquePets",
        Amount = 10,
        World = "StarterForest"        -- Optional: world filter
    },
    Rewards = {
        Coins = 10000,
        Experience = 200,
        Pet = "special_pet_id"         -- Optional: reward pet
    }
}
```

### Quest Rewards

**Balancing Guidelines:**
- Daily quests: 1,000-5,000 coins
- World quests: 5,000-50,000 coins
- Achievements: 10,000-1,000,000 coins
- Experience should scale with difficulty

---

## Gamepass Configuration

File: `src/shared/Config/GamepassConfig.lua`

### Adding Gamepasses

```lua
NewGamepass = {
    Id = 0,                            -- Replace with actual ID
    Name = "Gamepass Name",
    Description = "What it does",
    Price = 299,                       -- Robux price
    Icon = "rbxassetid://0",          -- Icon asset ID
    Benefits = {
        "Benefit 1",
        "Benefit 2"
    },
    Effects = {
        CoinMultiplier = 2,            -- Optional
        HatchSpeedMultiplier = 2,      -- Optional
        MaxEquippedPets = 50,          -- Optional
        VIPAccess = true,              -- Optional
        FastTravel = true,             -- Optional
        AutoHatch = true               -- Optional
    }
}
```

### Pricing Guidelines

**Recommended Prices:**
- Small boosts (2x): 99-199 Robux
- Medium boosts (3x): 199-299 Robux
- Large features: 299-499 Robux
- VIP access: 299-399 Robux

### Premium Eggs

```lua
NewPremiumEgg = {
    Name = "Premium Egg Name",
    Description = "What's inside",
    Price = 399,                       -- Robux
    Icon = "rbxassetid://0",
    ProductId = 0,                     -- Developer product ID
    Rewards = {
        EggType = "PremiumEggType",
        Amount = 1
    }
}
```

### Boosts

```lua
NewBoost = {
    Name = "Boost Name",
    Description = "What it does",
    Price = 49,                        -- Robux
    Icon = "rbxassetid://0",
    ProductId = 0,
    Duration = 3600,                   -- Seconds (1 hour)
    Effects = {
        CoinMultiplier = 2,
        LuckMultiplier = 2,
        HatchSpeedMultiplier = 2
    }
}
```

---

## Guild Configuration

File: `src/shared/Config/GuildConfig.lua`

### Guild Settings

```lua
Settings = {
    MaxMembers = 50,                   -- Max guild size
    MinNameLength = 3,
    MaxNameLength = 20,
    CreateCost = 10000,                -- Coins to create
    MaxGuildLevel = 50,
    ContributionTiers = {
        Bronze = 1000,
        Silver = 5000,
        Gold = 25000,
        Platinum = 100000,
        Diamond = 500000
    }
}
```

### Guild Level Rewards

```lua
[10] = {
    Coins = 100000,
    Pet = "guild_dragon_bronze",
    Perk = "10% coin boost for all members"
}
```

**Reward Scaling:**
- Every 5 levels: Coin reward
- Every 10 levels: Exclusive pet
- Every 5 levels: Permanent perk

### Guild Exclusive Pets

```lua
{
    Id = "guild_pet_id",
    Name = "Guild Pet Name",
    Rarity = "Legendary",
    Ability = "Fire",
    BaseValue = 1000000,
    Description = "Guild achievement pet",
    RequiredGuildLevel = 20
}
```

---

## Balancing Tips

### Economy Balance

**Coin Generation:**
- Early game: 10-100 coins/minute
- Mid game: 100-1,000 coins/minute
- Late game: 1,000-10,000 coins/minute

**Spending:**
- Eggs should cost 1-5 minutes of farming
- World unlocks should cost 30-60 minutes
- Premium items should feel valuable

### Pet Balance

**Rarity Distribution:**
- Common: 60% (everyday pets)
- Rare: 25% (nice finds)
- Epic: 10% (exciting!)
- Legendary: 4% (very rare)
- Mythical: 1% (extremely rare)

**Merge Levels:**
- Level 0-3: Common progression
- Level 4-6: Dedicated players
- Level 7+: Hardcore collectors

### Quest Balance

**Completion Time:**
- Daily quests: 10-30 minutes
- World quests: 1-3 hours
- Achievements: Days to weeks
- Legendary quests: Weeks to months

### Monetization Balance

**Free vs Premium:**
- Free players should progress at 100% speed
- Premium should be 2-3x faster, not required
- Exclusive content should be cosmetic or convenience
- Never create "pay to win" scenarios

---

## Testing Your Changes

After making configuration changes:

1. **Test in Studio**
   - Verify values are correct
   - Check for typos in IDs
   - Test progression feels good

2. **Balance Testing**
   - Play for 30 minutes as new player
   - Check if progression feels right
   - Adjust values as needed

3. **Economy Testing**
   - Track coin generation rates
   - Verify costs are appropriate
   - Test with different playstyles

4. **Multiplayer Testing**
   - Test with 2+ players
   - Verify trading works
   - Check guild features

---

## Common Mistakes to Avoid

1. **Don't** make early game too grindy
2. **Don't** make premium items required
3. **Don't** forget to test all changes
4. **Don't** make rarities too common
5. **Don't** create impossible quests
6. **Do** listen to player feedback
7. **Do** iterate based on data
8. **Do** keep the game fun first

---

For more help, see:
- README.md - Setup instructions
- DEPLOYMENT_GUIDE.md - Publishing guide
- Code comments - Implementation details