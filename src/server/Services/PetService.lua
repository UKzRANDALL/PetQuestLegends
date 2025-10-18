-- Pet Quest Legends - Pet Service
-- Handles pet hatching, merging, and management

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataService = require(script.Parent.DataService)
local RemoteManager = require(ReplicatedStorage.Modules.RemoteManager)
local Utilities = require(ReplicatedStorage.Modules.Utilities)
local PetConfig = require(ReplicatedStorage.Config.PetConfig)
local WorldConfig = require(ReplicatedStorage.Config.WorldConfig)
local GamepassConfig = require(ReplicatedStorage.Config.GamepassConfig)

local PetService = {}

-- Initialize service
function PetService.Init()
	-- Setup remote callbacks
	RemoteManager.SetCallback("HatchEgg", function(player, eggType)
		return PetService.HatchEgg(player, eggType)
	end)
	
	RemoteManager.SetCallback("MergePets", function(player, petId1, petId2)
		return PetService.MergePets(player, petId1, petId2)
	end)
	
	RemoteManager.SetCallback("EquipPet", function(player, petUniqueId)
		return PetService.EquipPet(player, petUniqueId)
	end)
	
	RemoteManager.SetCallback("UnequipPet", function(player, petUniqueId)
		return PetService.UnequipPet(player, petUniqueId)
	end)
	
	RemoteManager.SetCallback("DeletePet", function(player, petUniqueId)
		return PetService.DeletePet(player, petUniqueId)
	end)
	
	print("[PetService] Initialized")
end

-- Hatch an egg
function PetService.HatchEgg(player, eggType)
	local profile = DataService.GetProfile(player)
	if not profile then return {Success = false, Error = "No profile"} end
	
	local eggData = WorldConfig.GetEggData(eggType)
	if not eggData then return {Success = false, Error = "Invalid egg type"} end
	
	-- Check if premium egg
	if eggData.Premium then
		-- Check if player has premium egg in inventory
		local hasEgg = false
		for i, egg in ipairs(profile.Data.Inventory.PremiumEggs) do
			if egg == eggType then
				table.remove(profile.Data.Inventory.PremiumEggs, i)
				hasEgg = true
				break
			end
		end
		
		if not hasEgg then
			return {Success = false, Error = "No premium egg in inventory"}
		end
	else
		-- Check if player has enough coins
		if profile.Data.Coins < eggData.Cost then
			return {Success = false, Error = "Not enough coins"}
		end
		
		-- Remove coins
		DataService.RemoveCoins(player, eggData.Cost)
	end
	
	-- Calculate luck multiplier
	local luckMultiplier = 1
	if DataService.IsBoostActive(player, "Luck2x1Hour") or 
	   DataService.IsBoostActive(player, "TripleBoost1Hour") then
		luckMultiplier = 2
	end
	
	-- Select random pet based on rarity chances
	local selectedPet = PetService.SelectRandomPet(eggData.Pets, luckMultiplier)
	if not selectedPet then
		return {Success = false, Error = "Failed to select pet"}
	end
	
	-- Add pet to inventory
	local newPet = DataService.AddPet(player, selectedPet.Id, 0)
	if not newPet then
		return {Success = false, Error = "Failed to add pet"}
	end
	
	-- Update statistics
	profile.Data.Stats.EggsHatched = profile.Data.Stats.EggsHatched + 1
	
	-- Fire event to client
	RemoteManager.FireClient(player, "PetHatched", newPet, selectedPet)
	
	return {
		Success = true,
		Pet = newPet,
		PetData = selectedPet
	}
end

-- Select random pet based on rarity chances
function PetService.SelectRandomPet(petIds, luckMultiplier)
	luckMultiplier = luckMultiplier or 1
	
	-- Build weights table
	local weights = {}
	for _, petId in ipairs(petIds) do
		local petData = PetConfig.GetPetData(petId)
		if petData then
			local rarityData = PetConfig.Rarities[petData.Rarity]
			if rarityData then
				-- Apply luck multiplier to rare pets
				local weight = rarityData.Chance
				if petData.Rarity == "Legendary" or petData.Rarity == "Mythical" then
					weight = weight * luckMultiplier
				end
				weights[petId] = weight
			end
		end
	end
	
	-- Select weighted random
	local selectedId = Utilities.WeightedRandom(weights)
	return PetConfig.GetPetData(selectedId)
end

-- Merge two pets
function PetService.MergePets(player, petId1, petId2)
	local profile = DataService.GetProfile(player)
	if not profile then return {Success = false, Error = "No profile"} end
	
	-- Find both pets
	local pet1, pet1Index = PetService.FindPet(profile.Data.Pets, petId1)
	local pet2, pet2Index = PetService.FindPet(profile.Data.Pets, petId2)
	
	if not pet1 or not pet2 then
		return {Success = false, Error = "Pets not found"}
	end
	
	-- Check if same pet type
	if pet1.PetId ~= pet2.PetId then
		return {Success = false, Error = "Pets must be the same type"}
	end
	
	-- Check if same merge level
	if pet1.MergeLevel ~= pet2.MergeLevel then
		return {Success = false, Error = "Pets must be the same merge level"}
	end
	
	-- Check if either pet is equipped
	if pet1.Equipped or pet2.Equipped then
		return {Success = false, Error = "Cannot merge equipped pets"}
	end
	
	-- Create merged pet
	local mergedPet = {
		Id = Utilities.GenerateId(),
		PetId = pet1.PetId,
		MergeLevel = pet1.MergeLevel + 1,
		Equipped = false,
		Skin = pet1.Skin,
		ObtainedAt = os.time()
	}
	
	-- Remove old pets
	table.remove(profile.Data.Pets, math.max(pet1Index, pet2Index))
	table.remove(profile.Data.Pets, math.min(pet1Index, pet2Index))
	
	-- Add merged pet
	table.insert(profile.Data.Pets, mergedPet)
	
	-- Update statistics
	profile.Data.Stats.PetsMerged = profile.Data.Stats.PetsMerged + 1
	
	-- Fire event to client
	RemoteManager.FireClient(player, "PetMerged", mergedPet)
	
	return {
		Success = true,
		MergedPet = mergedPet
	}
end

-- Find pet in inventory
function PetService.FindPet(pets, petUniqueId)
	for index, pet in ipairs(pets) do
		if pet.Id == petUniqueId then
			return pet, index
		end
	end
	return nil, nil
end

-- Equip pet
function PetService.EquipPet(player, petUniqueId)
	local success, error = DataService.EquipPet(player, petUniqueId)
	if success then
		RemoteManager.FireClient(player, "PetEquipped", petUniqueId)
		return {Success = true}
	else
		return {Success = false, Error = error}
	end
end

-- Unequip pet
function PetService.UnequipPet(player, petUniqueId)
	local success = DataService.UnequipPet(player, petUniqueId)
	if success then
		RemoteManager.FireClient(player, "PetUnequipped", petUniqueId)
		return {Success = true}
	else
		return {Success = false, Error = "Failed to unequip"}
	end
end

-- Delete pet
function PetService.DeletePet(player, petUniqueId)
	local profile = DataService.GetProfile(player)
	if not profile then return {Success = false, Error = "No profile"} end
	
	-- Find pet
	local pet, petIndex = PetService.FindPet(profile.Data.Pets, petUniqueId)
	if not pet then
		return {Success = false, Error = "Pet not found"}
	end
	
	-- Check if equipped
	if pet.Equipped then
		return {Success = false, Error = "Cannot delete equipped pet"}
	end
	
	-- Remove pet
	table.remove(profile.Data.Pets, petIndex)
	
	return {Success = true}
end

-- Calculate total coin multiplier from equipped pets
function PetService.GetCoinMultiplier(player)
	local profile = DataService.GetProfile(player)
	if not profile then return 1 end
	
	local totalMultiplier = 1
	
	for _, petUniqueId in ipairs(profile.Data.EquippedPets) do
		local pet = PetService.FindPet(profile.Data.Pets, petUniqueId)
		if pet then
			local petData = PetConfig.GetPetData(pet.PetId)
			if petData then
				local value = PetConfig.CalculatePetValue(pet.PetId, pet.MergeLevel)
				totalMultiplier = totalMultiplier + (value / 1000) -- Scale appropriately
			end
		end
	end
	
	-- Apply gamepass multipliers
	local gamepassMultipliers = GamepassConfig.CalculateMultipliers(
		profile.Data.OwnedGamepasses,
		profile.Data.ActiveBoosts
	)
	
	totalMultiplier = totalMultiplier * gamepassMultipliers.Coins
	
	return totalMultiplier
end

return PetService