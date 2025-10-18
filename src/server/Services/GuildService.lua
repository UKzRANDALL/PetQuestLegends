-- Pet Quest Legends - Guild Service
-- Handles guild creation, management, and rewards

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local DataStoreService = game:GetService("DataStoreService")

local DataService = require(script.Parent.DataService)
local RemoteManager = require(ReplicatedStorage.Modules.RemoteManager)
local Utilities = require(ReplicatedStorage.Modules.Utilities)
local GuildConfig = require(ReplicatedStorage.Config.GuildConfig)

local GuildService = {}
GuildService.Guilds = {}
GuildService.GuildDataStore = DataStoreService:GetDataStore("GuildData_v1")

-- Initialize service
function GuildService.Init()
	-- Setup remote callbacks
	RemoteManager.SetCallback("CreateGuild", function(player, guildName, description)
		return GuildService.CreateGuild(player, guildName, description)
	end)
	
	RemoteManager.SetCallback("JoinGuild", function(player, guildId)
		return GuildService.JoinGuild(player, guildId)
	end)
	
	RemoteManager.SetCallback("LeaveGuild", function(player)
		return GuildService.LeaveGuild(player)
	end)
	
	RemoteManager.SetCallback("ContributeToGuild", function(player, amount)
		return GuildService.ContributeToGuild(player, amount)
	end)
	
	RemoteManager.SetCallback("GetGuildData", function(player, guildId)
		return GuildService.GetGuildData(guildId)
	end)
	
	-- Setup remote events
	RemoteManager.OnServerEvent("GuildInvite", function(player, targetPlayer)
		GuildService.InvitePlayer(player, targetPlayer)
	end)
	
	RemoteManager.OnServerEvent("KickGuildMember", function(player, targetUserId)
		GuildService.KickMember(player, targetUserId)
	end)
	
	RemoteManager.OnServerEvent("PromoteGuildMember", function(player, targetUserId)
		GuildService.PromoteMember(player, targetUserId)
	end)
	
	RemoteManager.OnServerEvent("DemoteGuildMember", function(player, targetUserId)
		GuildService.DemoteMember(player, targetUserId)
	end)
	
	print("[GuildService] Initialized")
end

-- Create a new guild
function GuildService.CreateGuild(player, guildName, description)
	local profile = DataService.GetProfile(player)
	if not profile then return {Success = false, Error = "No profile"} end
	
	-- Check if player is already in a guild
	if profile.Data.GuildId then
		return {Success = false, Error = "Already in a guild"}
	end
	
	-- Check if player has enough coins
	if profile.Data.Coins < GuildConfig.Settings.CreateCost then
		return {Success = false, Error = "Not enough coins"}
	end
	
	-- Validate guild name
	if #guildName < GuildConfig.Settings.MinNameLength or 
	   #guildName > GuildConfig.Settings.MaxNameLength then
		return {Success = false, Error = "Invalid guild name length"}
	end
	
	-- Check if guild name is taken
	local success, existingGuild = pcall(function()
		return GuildService.GuildDataStore:GetAsync("GuildName_" .. guildName)
	end)
	
	if success and existingGuild then
		return {Success = false, Error = "Guild name already taken"}
	end
	
	-- Create guild
	local guildId = Utilities.GenerateId()
	local guildData = {
		Id = guildId,
		Name = guildName,
		Description = description or "",
		Owner = player.UserId,
		CreatedAt = os.time(),
		Level = 1,
		TotalContributions = 0,
		Members = {
			[tostring(player.UserId)] = {
				UserId = player.UserId,
				Username = player.Name,
				Rank = "Owner",
				Contributions = 0,
				JoinedAt = os.time()
			}
		},
		Settings = {
			RequireApproval = true,
			MinLevel = 1
		}
	}
	
	-- Save guild data
	local saveSuccess = pcall(function()
		GuildService.GuildDataStore:SetAsync("Guild_" .. guildId, guildData)
		GuildService.GuildDataStore:SetAsync("GuildName_" .. guildName, guildId)
	end)
	
	if not saveSuccess then
		return {Success = false, Error = "Failed to save guild"}
	end
	
	-- Update player data
	profile.Data.GuildId = guildId
	profile.Data.GuildRank = "Owner"
	
	-- Remove coins
	DataService.RemoveCoins(player, GuildConfig.Settings.CreateCost)
	
	-- Cache guild
	GuildService.Guilds[guildId] = guildData
	
	-- Fire event
	RemoteManager.FireClient(player, "GuildJoined", guildData)
	
	return {
		Success = true,
		Guild = guildData
	}
end

-- Join a guild
function GuildService.JoinGuild(player, guildId)
	local profile = DataService.GetProfile(player)
	if not profile then return {Success = false, Error = "No profile"} end
	
	-- Check if player is already in a guild
	if profile.Data.GuildId then
		return {Success = false, Error = "Already in a guild"}
	end
	
	-- Load guild data
	local guildData = GuildService.LoadGuild(guildId)
	if not guildData then
		return {Success = false, Error = "Guild not found"}
	end
	
	-- Check if guild is full
	if Utilities.TableLength(guildData.Members) >= GuildConfig.Settings.MaxMembers then
		return {Success = false, Error = "Guild is full"}
	end
	
	-- Check level requirement
	if profile.Data.Level < guildData.Settings.MinLevel then
		return {Success = false, Error = "Level requirement not met"}
	end
	
	-- Add member
	guildData.Members[tostring(player.UserId)] = {
		UserId = player.UserId,
		Username = player.Name,
		Rank = "Member",
		Contributions = 0,
		JoinedAt = os.time()
	}
	
	-- Save guild
	GuildService.SaveGuild(guildData)
	
	-- Update player data
	profile.Data.GuildId = guildId
	profile.Data.GuildRank = "Member"
	
	-- Fire event
	RemoteManager.FireClient(player, "GuildJoined", guildData)
	
	return {
		Success = true,
		Guild = guildData
	}
end

-- Leave guild
function GuildService.LeaveGuild(player)
	local profile = DataService.GetProfile(player)
	if not profile then return {Success = false, Error = "No profile"} end
	
	if not profile.Data.GuildId then
		return {Success = false, Error = "Not in a guild"}
	end
	
	-- Load guild
	local guildData = GuildService.LoadGuild(profile.Data.GuildId)
	if not guildData then
		return {Success = false, Error = "Guild not found"}
	end
	
	-- Check if owner
	if guildData.Owner == player.UserId then
		-- Transfer ownership or disband
		local memberCount = Utilities.TableLength(guildData.Members)
		if memberCount > 1 then
			return {Success = false, Error = "Transfer ownership before leaving"}
		else
			-- Disband guild
			GuildService.DisbandGuild(profile.Data.GuildId)
		end
	else
		-- Remove member
		guildData.Members[tostring(player.UserId)] = nil
		GuildService.SaveGuild(guildData)
	end
	
	-- Update player data
	profile.Data.GuildId = nil
	profile.Data.GuildRank = nil
	
	-- Fire event
	RemoteManager.FireClient(player, "GuildLeft")
	
	return {Success = true}
end

-- Contribute to guild
function GuildService.ContributeToGuild(player, amount)
	local profile = DataService.GetProfile(player)
	if not profile then return {Success = false, Error = "No profile"} end
	
	if not profile.Data.GuildId then
		return {Success = false, Error = "Not in a guild"}
	end
	
	-- Check if player has enough coins
	if profile.Data.Coins < amount then
		return {Success = false, Error = "Not enough coins"}
	end
	
	-- Load guild
	local guildData = GuildService.LoadGuild(profile.Data.GuildId)
	if not guildData then
		return {Success = false, Error = "Guild not found"}
	end
	
	-- Remove coins from player
	DataService.RemoveCoins(player, amount)
	
	-- Add to guild contributions
	guildData.TotalContributions = guildData.TotalContributions + amount
	
	-- Update member contributions
	local memberData = guildData.Members[tostring(player.UserId)]
	if memberData then
		memberData.Contributions = memberData.Contributions + amount
		profile.Data.GuildContributions = profile.Data.GuildContributions + amount
	end
	
	-- Check for level up
	local oldLevel = guildData.Level
	guildData.Level = GuildConfig.CalculateGuildLevel(guildData.TotalContributions)
	
	-- Check for rewards
	if guildData.Level > oldLevel then
		GuildService.GrantLevelRewards(guildData, guildData.Level)
	end
	
	-- Save guild
	GuildService.SaveGuild(guildData)
	
	return {
		Success = true,
		NewLevel = guildData.Level,
		TotalContributions = guildData.TotalContributions
	}
end

-- Grant level rewards to all guild members
function GuildService.GrantLevelRewards(guildData, level)
	local rewards = GuildConfig.GetLevelReward(level)
	if not rewards then return end
	
	-- Notify all online members
	for userIdStr, memberData in pairs(guildData.Members) do
		local player = game:GetService("Players"):GetPlayerByUserId(memberData.UserId)
		if player then
			-- Give rewards
			if rewards.Coins then
				DataService.AddCoins(player, rewards.Coins)
			end
			
			if rewards.Pet then
				DataService.AddPet(player, rewards.Pet, 0)
			end
			
			-- Notify
			RemoteManager.FireClient(player, "NotificationSent", {
				Title = "Guild Level Up!",
				Message = string.format("Your guild reached level %d!", level),
				Type = "Success"
			})
		end
	end
end

-- Load guild from datastore
function GuildService.LoadGuild(guildId)
	-- Check cache first
	if GuildService.Guilds[guildId] then
		return GuildService.Guilds[guildId]
	end
	
	-- Load from datastore
	local success, guildData = pcall(function()
		return GuildService.GuildDataStore:GetAsync("Guild_" .. guildId)
	end)
	
	if success and guildData then
		GuildService.Guilds[guildId] = guildData
		return guildData
	end
	
	return nil
end

-- Save guild to datastore
function GuildService.SaveGuild(guildData)
	GuildService.Guilds[guildData.Id] = guildData
	
	pcall(function()
		GuildService.GuildDataStore:SetAsync("Guild_" .. guildData.Id, guildData)
	end)
end

-- Disband guild
function GuildService.DisbandGuild(guildId)
	local guildData = GuildService.LoadGuild(guildId)
	if not guildData then return end
	
	-- Remove from cache
	GuildService.Guilds[guildId] = nil
	
	-- Remove from datastore
	pcall(function()
		GuildService.GuildDataStore:RemoveAsync("Guild_" .. guildId)
		GuildService.GuildDataStore:RemoveAsync("GuildName_" .. guildData.Name)
	end)
end

-- Get guild data
function GuildService.GetGuildData(guildId)
	return GuildService.LoadGuild(guildId)
end

return GuildService