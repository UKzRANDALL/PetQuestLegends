-- Pet Quest Legends - Guild Configuration
-- Defines guild system settings and rewards

local GuildConfig = {}

-- Guild settings
GuildConfig.Settings = {
	MaxMembers = 50,
	MinNameLength = 3,
	MaxNameLength = 20,
	CreateCost = 10000, -- Coins to create a guild
	MaxGuildLevel = 50,
	ContributionTiers = {
		Bronze = 1000,
		Silver = 5000,
		Gold = 25000,
		Platinum = 100000,
		Diamond = 500000
	}
}

-- Guild ranks
GuildConfig.Ranks = {
	Owner = {
		Name = "Owner",
		Permissions = {
			Invite = true,
			Kick = true,
			Promote = true,
			Demote = true,
			EditDescription = true,
			ManageSettings = true,
			Disband = true
		}
	},
	CoOwner = {
		Name = "Co-Owner",
		Permissions = {
			Invite = true,
			Kick = true,
			Promote = true,
			Demote = true,
			EditDescription = true,
			ManageSettings = true,
			Disband = false
		}
	},
	Admin = {
		Name = "Admin",
		Permissions = {
			Invite = true,
			Kick = true,
			Promote = false,
			Demote = false,
			EditDescription = true,
			ManageSettings = false,
			Disband = false
		}
	},
	Moderator = {
		Name = "Moderator",
		Permissions = {
			Invite = true,
			Kick = true,
			Promote = false,
			Demote = false,
			EditDescription = false,
			ManageSettings = false,
			Disband = false
		}
	},
	Member = {
		Name = "Member",
		Permissions = {
			Invite = false,
			Kick = false,
			Promote = false,
			Demote = false,
			EditDescription = false,
			ManageSettings = false,
			Disband = false
		}
	}
}

-- Guild level rewards
GuildConfig.LevelRewards = {
	[5] = {
		Coins = 50000,
		Pet = nil,
		Perk = "5% coin boost for all members"
	},
	[10] = {
		Coins = 100000,
		Pet = "guild_dragon_bronze",
		Perk = "10% coin boost for all members"
	},
	[15] = {
		Coins = 250000,
		Pet = nil,
		Perk = "Access to guild-exclusive area"
	},
	[20] = {
		Coins = 500000,
		Pet = "guild_dragon_silver",
		Perk = "15% coin boost for all members"
	},
	[25] = {
		Coins = 1000000,
		Pet = nil,
		Perk = "Guild-exclusive eggs unlocked"
	},
	[30] = {
		Coins = 2000000,
		Pet = "guild_dragon_gold",
		Perk = "20% coin boost for all members"
	},
	[35] = {
		Coins = 5000000,
		Pet = nil,
		Perk = "Guild wars unlocked"
	},
	[40] = {
		Coins = 10000000,
		Pet = "guild_dragon_platinum",
		Perk = "25% coin boost for all members"
	},
	[45] = {
		Coins = 25000000,
		Pet = nil,
		Perk = "Guild raids unlocked"
	},
	[50] = {
		Coins = 50000000,
		Pet = "guild_dragon_diamond",
		Perk = "30% coin boost for all members"
	}
}

-- Guild exclusive pets
GuildConfig.GuildPets = {
	{
		Id = "guild_dragon_bronze",
		Name = "Bronze Guild Dragon",
		Rarity = "Epic",
		Ability = "Fire",
		BaseValue = 500000,
		Description = "A dragon representing your guild's bronze achievement",
		RequiredGuildLevel = 10
	},
	{
		Id = "guild_dragon_silver",
		Name = "Silver Guild Dragon",
		Rarity = "Legendary",
		Ability = "Fire",
		BaseValue = 2000000,
		Description = "A dragon representing your guild's silver achievement",
		RequiredGuildLevel = 20
	},
	{
		Id = "guild_dragon_gold",
		Name = "Gold Guild Dragon",
		Rarity = "Legendary",
		Ability = "Fire",
		BaseValue = 5000000,
		Description = "A dragon representing your guild's gold achievement",
		RequiredGuildLevel = 30
	},
	{
		Id = "guild_dragon_platinum",
		Name = "Platinum Guild Dragon",
		Rarity = "Mythical",
		Ability = "Shadow",
		BaseValue = 15000000,
		Description = "A dragon representing your guild's platinum achievement",
		RequiredGuildLevel = 40
	},
	{
		Id = "guild_dragon_diamond",
		Name = "Diamond Guild Dragon",
		Rarity = "Mythical",
		Ability = "Shadow",
		BaseValue = 50000000,
		Description = "The ultimate guild dragon",
		RequiredGuildLevel = 50
	}
}

-- Guild contribution milestones
GuildConfig.ContributionMilestones = {
	{
		Amount = 1000,
		Reward = {
			Title = "Guild Supporter",
			Coins = 5000
		}
	},
	{
		Amount = 5000,
		Reward = {
			Title = "Guild Contributor",
			Coins = 25000
		}
	},
	{
		Amount = 25000,
		Reward = {
			Title = "Guild Benefactor",
			Coins = 100000,
			Pet = "guild_dragon_bronze"
		}
	},
	{
		Amount = 100000,
		Reward = {
			Title = "Guild Hero",
			Coins = 500000,
			Pet = "guild_dragon_silver"
		}
	},
	{
		Amount = 500000,
		Reward = {
			Title = "Guild Legend",
			Coins = 2500000,
			Pet = "guild_dragon_gold"
		}
	}
}

-- Calculate guild level from total contributions
function GuildConfig.CalculateGuildLevel(totalContributions)
	-- Each level requires progressively more contributions
	-- Level 1: 0, Level 2: 10000, Level 3: 25000, etc.
	local level = 1
	local requiredContributions = 0
	
	while level < GuildConfig.Settings.MaxGuildLevel do
		local nextLevelRequirement = requiredContributions + (level * 10000)
		if totalContributions >= nextLevelRequirement then
			level = level + 1
			requiredContributions = nextLevelRequirement
		else
			break
		end
	end
	
	return level
end

-- Get guild level rewards
function GuildConfig.GetLevelReward(level)
	return GuildConfig.LevelRewards[level]
end

-- Get contribution tier
function GuildConfig.GetContributionTier(contributions)
	if contributions >= GuildConfig.Settings.ContributionTiers.Diamond then
		return "Diamond"
	elseif contributions >= GuildConfig.Settings.ContributionTiers.Platinum then
		return "Platinum"
	elseif contributions >= GuildConfig.Settings.ContributionTiers.Gold then
		return "Gold"
	elseif contributions >= GuildConfig.Settings.ContributionTiers.Silver then
		return "Silver"
	elseif contributions >= GuildConfig.Settings.ContributionTiers.Bronze then
		return "Bronze"
	else
		return "None"
	end
end

-- Check if player has permission
function GuildConfig.HasPermission(rank, permission)
	local rankData = GuildConfig.Ranks[rank]
	if not rankData then return false end
	return rankData.Permissions[permission] == true
end

return GuildConfig