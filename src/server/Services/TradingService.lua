-- Pet Quest Legends - Trading Service
-- Handles pet trading between players

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataService = require(script.Parent.DataService)
local PetService = require(script.Parent.PetService)
local RemoteManager = require(ReplicatedStorage.Modules.RemoteManager)
local Utilities = require(ReplicatedStorage.Modules.Utilities)
local PetConfig = require(ReplicatedStorage.Config.PetConfig)

local TradingService = {}
TradingService.ActiveTrades = {}

-- Initialize service
function TradingService.Init()
	-- Setup remote callbacks
	RemoteManager.SetCallback("InitiateTrade", function(player, targetPlayer)
		return TradingService.InitiateTrade(player, targetPlayer)
	end)
	
	RemoteManager.SetCallback("AcceptTrade", function(player, tradeId)
		return TradingService.AcceptTrade(player, tradeId)
	end)
	
	RemoteManager.SetCallback("DeclineTrade", function(player, tradeId)
		return TradingService.DeclineTrade(player, tradeId)
	end)
	
	RemoteManager.SetCallback("CancelTrade", function(player, tradeId)
		return TradingService.CancelTrade(player, tradeId)
	end)
	
	RemoteManager.SetCallback("GetTradeValue", function(player, petIds)
		return TradingService.CalculateTradeValue(petIds)
	end)
	
	-- Setup remote events
	RemoteManager.OnServerEvent("AddPetToTrade", function(player, tradeId, petUniqueId)
		TradingService.AddPetToTrade(player, tradeId, petUniqueId)
	end)
	
	RemoteManager.OnServerEvent("RemovePetFromTrade", function(player, tradeId, petUniqueId)
		TradingService.RemovePetFromTrade(player, tradeId, petUniqueId)
	end)
	
	RemoteManager.OnServerEvent("ConfirmTrade", function(player, tradeId)
		TradingService.ConfirmTrade(player, tradeId)
	end)
	
	print("[TradingService] Initialized")
end

-- Initiate a trade
function TradingService.InitiateTrade(player, targetPlayer)
	if not Utilities.IsPlayerValid(targetPlayer) then
		return {Success = false, Error = "Target player not found"}
	end
	
	if player == targetPlayer then
		return {Success = false, Error = "Cannot trade with yourself"}
	end
	
	-- Check if either player is already in a trade
	for _, trade in pairs(TradingService.ActiveTrades) do
		if trade.Player1 == player or trade.Player2 == player or
		   trade.Player1 == targetPlayer or trade.Player2 == targetPlayer then
			return {Success = false, Error = "Already in a trade"}
		end
	end
	
	-- Create trade
	local tradeId = Utilities.GenerateId()
	local trade = {
		Id = tradeId,
		Player1 = player,
		Player2 = targetPlayer,
		Player1Pets = {},
		Player2Pets = {},
		Player1Confirmed = false,
		Player2Confirmed = false,
		Status = "Pending",
		CreatedAt = tick()
	}
	
	TradingService.ActiveTrades[tradeId] = trade
	
	-- Send trade request to target player
	RemoteManager.FireClient(targetPlayer, "TradeRequest", {
		TradeId = tradeId,
		FromPlayer = player.Name,
		FromUserId = player.UserId
	})
	
	return {
		Success = true,
		TradeId = tradeId
	}
end

-- Accept trade request
function TradingService.AcceptTrade(player, tradeId)
	local trade = TradingService.ActiveTrades[tradeId]
	if not trade then
		return {Success = false, Error = "Trade not found"}
	end
	
	if trade.Player2 ~= player then
		return {Success = false, Error = "Not your trade"}
	end
	
	trade.Status = "Active"
	
	-- Notify both players
	RemoteManager.FireClient(trade.Player1, "TradeAccepted", {TradeId = tradeId})
	RemoteManager.FireClient(trade.Player2, "TradeAccepted", {TradeId = tradeId})
	
	return {Success = true}
end

-- Decline trade request
function TradingService.DeclineTrade(player, tradeId)
	local trade = TradingService.ActiveTrades[tradeId]
	if not trade then
		return {Success = false, Error = "Trade not found"}
	end
	
	if trade.Player2 ~= player then
		return {Success = false, Error = "Not your trade"}
	end
	
	-- Notify initiator
	RemoteManager.FireClient(trade.Player1, "TradeCancelled", {
		Reason = "Trade declined"
	})
	
	-- Remove trade
	TradingService.ActiveTrades[tradeId] = nil
	
	return {Success = true}
end

-- Cancel trade
function TradingService.CancelTrade(player, tradeId)
	local trade = TradingService.ActiveTrades[tradeId]
	if not trade then
		return {Success = false, Error = "Trade not found"}
	end
	
	if trade.Player1 ~= player and trade.Player2 ~= player then
		return {Success = false, Error = "Not your trade"}
	end
	
	-- Notify both players
	local otherPlayer = trade.Player1 == player and trade.Player2 or trade.Player1
	RemoteManager.FireClient(otherPlayer, "TradeCancelled", {
		Reason = "Trade cancelled by other player"
	})
	
	-- Remove trade
	TradingService.ActiveTrades[tradeId] = nil
	
	return {Success = true}
end

-- Add pet to trade
function TradingService.AddPetToTrade(player, tradeId, petUniqueId)
	local trade = TradingService.ActiveTrades[tradeId]
	if not trade or trade.Status ~= "Active" then return end
	
	local profile = DataService.GetProfile(player)
	if not profile then return end
	
	-- Find pet
	local pet = PetService.FindPet(profile.Data.Pets, petUniqueId)
	if not pet then return end
	
	-- Check if pet is equipped
	if pet.Equipped then
		RemoteManager.FireClient(player, "NotificationSent", {
			Title = "Cannot Trade",
			Message = "Cannot trade equipped pets",
			Type = "Error"
		})
		return
	end
	
	-- Add to appropriate list
	if trade.Player1 == player then
		if not table.find(trade.Player1Pets, petUniqueId) then
			table.insert(trade.Player1Pets, petUniqueId)
		end
	elseif trade.Player2 == player then
		if not table.find(trade.Player2Pets, petUniqueId) then
			table.insert(trade.Player2Pets, petUniqueId)
		end
	end
	
	-- Reset confirmations
	trade.Player1Confirmed = false
	trade.Player2Confirmed = false
	
	-- Update both players
	TradingService.UpdateTrade(trade)
end

-- Remove pet from trade
function TradingService.RemovePetFromTrade(player, tradeId, petUniqueId)
	local trade = TradingService.ActiveTrades[tradeId]
	if not trade or trade.Status ~= "Active" then return end
	
	-- Remove from appropriate list
	if trade.Player1 == player then
		local index = table.find(trade.Player1Pets, petUniqueId)
		if index then
			table.remove(trade.Player1Pets, index)
		end
	elseif trade.Player2 == player then
		local index = table.find(trade.Player2Pets, petUniqueId)
		if index then
			table.remove(trade.Player2Pets, index)
		end
	end
	
	-- Reset confirmations
	trade.Player1Confirmed = false
	trade.Player2Confirmed = false
	
	-- Update both players
	TradingService.UpdateTrade(trade)
end

-- Confirm trade
function TradingService.ConfirmTrade(player, tradeId)
	local trade = TradingService.ActiveTrades[tradeId]
	if not trade or trade.Status ~= "Active" then return end
	
	-- Set confirmation
	if trade.Player1 == player then
		trade.Player1Confirmed = true
	elseif trade.Player2 == player then
		trade.Player2Confirmed = true
	end
	
	-- Check if both confirmed
	if trade.Player1Confirmed and trade.Player2Confirmed then
		TradingService.ExecuteTrade(trade)
	else
		-- Update both players
		TradingService.UpdateTrade(trade)
	end
end

-- Execute the trade
function TradingService.ExecuteTrade(trade)
	local profile1 = DataService.GetProfile(trade.Player1)
	local profile2 = DataService.GetProfile(trade.Player2)
	
	if not profile1 or not profile2 then
		TradingService.CancelTrade(trade.Player1, trade.Id)
		return
	end
	
	-- Verify all pets still exist and are not equipped
	for _, petId in ipairs(trade.Player1Pets) do
		local pet = PetService.FindPet(profile1.Data.Pets, petId)
		if not pet or pet.Equipped then
			RemoteManager.FireClient(trade.Player1, "TradeCancelled", {
				Reason = "Trade invalid - pet no longer available"
			})
			RemoteManager.FireClient(trade.Player2, "TradeCancelled", {
				Reason = "Trade invalid - pet no longer available"
			})
			TradingService.ActiveTrades[trade.Id] = nil
			return
		end
	end
	
	for _, petId in ipairs(trade.Player2Pets) do
		local pet = PetService.FindPet(profile2.Data.Pets, petId)
		if not pet or pet.Equipped then
			RemoteManager.FireClient(trade.Player1, "TradeCancelled", {
				Reason = "Trade invalid - pet no longer available"
			})
			RemoteManager.FireClient(trade.Player2, "TradeCancelled", {
				Reason = "Trade invalid - pet no longer available"
			})
			TradingService.ActiveTrades[trade.Id] = nil
			return
		end
	end
	
	-- Transfer pets from Player1 to Player2
	for _, petId in ipairs(trade.Player1Pets) do
		local pet, index = PetService.FindPet(profile1.Data.Pets, petId)
		if pet then
			table.remove(profile1.Data.Pets, index)
			pet.Id = Utilities.GenerateId() -- New unique ID
			table.insert(profile2.Data.Pets, pet)
		end
	end
	
	-- Transfer pets from Player2 to Player1
	for _, petId in ipairs(trade.Player2Pets) do
		local pet, index = PetService.FindPet(profile2.Data.Pets, petId)
		if pet then
			table.remove(profile2.Data.Pets, index)
			pet.Id = Utilities.GenerateId() -- New unique ID
			table.insert(profile1.Data.Pets, pet)
		end
	end
	
	-- Update statistics
	profile1.Data.Stats.TradesCompleted = profile1.Data.Stats.TradesCompleted + 1
	profile2.Data.Stats.TradesCompleted = profile2.Data.Stats.TradesCompleted + 1
	
	-- Add to trade history
	local tradeRecord = {
		Timestamp = os.time(),
		OtherPlayer = trade.Player2.Name,
		GavePets = trade.Player1Pets,
		ReceivedPets = trade.Player2Pets
	}
	table.insert(profile1.Data.TradeHistory, tradeRecord)
	
	tradeRecord = {
		Timestamp = os.time(),
		OtherPlayer = trade.Player1.Name,
		GavePets = trade.Player2Pets,
		ReceivedPets = trade.Player1Pets
	}
	table.insert(profile2.Data.TradeHistory, tradeRecord)
	
	-- Notify both players
	RemoteManager.FireClient(trade.Player1, "TradeCompleted", {
		Success = true
	})
	RemoteManager.FireClient(trade.Player2, "TradeCompleted", {
		Success = true
	})
	
	-- Remove trade
	TradingService.ActiveTrades[trade.Id] = nil
end

-- Update trade for both players
function TradingService.UpdateTrade(trade)
	local tradeData = {
		Id = trade.Id,
		Player1Pets = trade.Player1Pets,
		Player2Pets = trade.Player2Pets,
		Player1Confirmed = trade.Player1Confirmed,
		Player2Confirmed = trade.Player2Confirmed
	}
	
	RemoteManager.FireClient(trade.Player1, "TradeUpdated", tradeData)
	RemoteManager.FireClient(trade.Player2, "TradeUpdated", tradeData)
end

-- Calculate trade value
function TradingService.CalculateTradeValue(petIds)
	local totalValue = 0
	
	for _, petId in ipairs(petIds) do
		local petData = PetConfig.GetPetData(petId)
		if petData then
			totalValue = totalValue + petData.BaseValue
		end
	end
	
	return totalValue
end

return TradingService