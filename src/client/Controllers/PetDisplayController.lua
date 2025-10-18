-- Pet Quest Legends - Pet Display Controller
-- Handles displaying equipped pets following the player

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local RemoteManager = require(ReplicatedStorage.Modules.RemoteManager)
local Utilities = require(ReplicatedStorage.Modules.Utilities)
local PetConfig = require(ReplicatedStorage.Config.PetConfig)

local PetDisplayController = {}
PetDisplayController.EquippedPetModels = {}

-- Initialize controller
function PetDisplayController.Init()
	local player = Players.LocalPlayer
	
	-- Update equipped pets
	PetDisplayController.UpdateEquippedPets()
	
	-- Update pet positions every frame
	RunService.Heartbeat:Connect(function(deltaTime)
		PetDisplayController.UpdatePetPositions(deltaTime)
	end)
	
	print("[PetDisplayController] Initialized")
end

-- Update equipped pets
function PetDisplayController.UpdateEquippedPets()
	local GameController = require(script.Parent.GameController)
	local playerData = GameController.GetPlayerData()
	
	if not playerData then return end
	
	-- Clear existing pet models
	for _, petModel in pairs(PetDisplayController.EquippedPetModels) do
		if petModel.Model then
			petModel.Model:Destroy()
		end
	end
	PetDisplayController.EquippedPetModels = {}
	
	-- Create new pet models
	for index, petUniqueId in ipairs(playerData.EquippedPets) do
		-- Find pet data
		local pet = nil
		for _, p in ipairs(playerData.Pets) do
			if p.Id == petUniqueId then
				pet = p
				break
			end
		end
		
		if pet then
			local petData = PetConfig.GetPetData(pet.PetId)
			if petData then
				local petModel = PetDisplayController.CreatePetModel(pet, petData, index)
				if petModel then
					PetDisplayController.EquippedPetModels[petUniqueId] = {
						Model = petModel,
						Pet = pet,
						PetData = petData,
						Index = index,
						Offset = Vector3.new(0, 0, 0),
						TargetOffset = Vector3.new(0, 0, 0),
						BobPhase = math.random() * math.pi * 2
					}
				end
			end
		end
	end
end

-- Create pet model
function PetDisplayController.CreatePetModel(pet, petData, index)
	local player = Players.LocalPlayer
	local character = player.Character
	if not character then return nil end
	
	-- Create simple pet model (placeholder - replace with actual pet models)
	local petModel = Instance.new("Model")
	petModel.Name = petData.Name
	
	local petPart = Instance.new("Part")
	petPart.Name = "PetPart"
	petPart.Size = Vector3.new(2, 2, 2)
	petPart.Shape = Enum.PartType.Ball
	petPart.Material = Enum.Material.Neon
	petPart.CanCollide = false
	petPart.Anchored = false
	petPart.Massless = true
	
	-- Set color based on rarity
	local rarityData = PetConfig.Rarities[petData.Rarity]
	if rarityData then
		petPart.Color = rarityData.Color
	end
	
	petPart.Parent = petModel
	
	-- Add body velocity for smooth movement
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.MaxForce = Vector3.new(50000, 50000, 50000)
	bodyVelocity.Velocity = Vector3.new(0, 0, 0)
	bodyVelocity.Parent = petPart
	
	-- Add body gyro to prevent rotation
	local bodyGyro = Instance.new("BodyGyro")
	bodyGyro.MaxTorque = Vector3.new(50000, 50000, 50000)
	bodyGyro.P = 3000
	bodyGyro.D = 500
	bodyGyro.Parent = petPart
	
	-- Add particle effects based on rarity
	if petData.Rarity == "Legendary" or petData.Rarity == "Mythical" then
		local particles = Instance.new("ParticleEmitter")
		particles.Texture = "rbxasset://textures/particles/sparkles_main.dds"
		particles.Rate = 20
		particles.Lifetime = NumberRange.new(0.5, 1)
		particles.Speed = NumberRange.new(1, 3)
		particles.SpreadAngle = Vector2.new(180, 180)
		particles.Color = rarityData.ParticleColor
		particles.Size = NumberSequence.new(0.2, 0)
		particles.Transparency = NumberSequence.new(0, 1)
		particles.LightEmission = 1
		particles.Parent = petPart
	end
	
	-- Add name tag
	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Size = UDim2.new(0, 100, 0, 40)
	billboardGui.StudsOffset = Vector3.new(0, 2, 0)
	billboardGui.AlwaysOnTop = true
	billboardGui.Parent = petPart
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 1, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = petData.Name
	nameLabel.TextColor3 = rarityData.Color
	nameLabel.TextSize = 14
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextStrokeTransparency = 0.5
	nameLabel.Parent = billboardGui
	
	petModel.Parent = workspace
	
	return petModel
end

-- Update pet positions
function PetDisplayController.UpdatePetPositions(deltaTime)
	local player = Players.LocalPlayer
	local character = player.Character
	if not character then return end
	
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end
	
	local petCount = 0
	for _, _ in pairs(PetDisplayController.EquippedPetModels) do
		petCount = petCount + 1
	end
	
	if petCount == 0 then return end
	
	-- Calculate positions in a circle around the player
	local radius = 5
	local angleStep = (math.pi * 2) / petCount
	
	for petId, petInfo in pairs(PetDisplayController.EquippedPetModels) do
		if petInfo.Model and petInfo.Model.Parent then
			local petPart = petInfo.Model:FindFirstChild("PetPart")
			if petPart then
				-- Calculate target position
				local angle = angleStep * (petInfo.Index - 1)
				local offsetX = math.cos(angle) * radius
				local offsetZ = math.sin(angle) * radius
				
				-- Add bobbing motion
				petInfo.BobPhase = petInfo.BobPhase + deltaTime * 2
				local bobHeight = math.sin(petInfo.BobPhase) * 0.5
				
				local targetPosition = humanoidRootPart.Position + Vector3.new(offsetX, 2 + bobHeight, offsetZ)
				
				-- Smooth movement
				local bodyVelocity = petPart:FindFirstChild("BodyVelocity")
				if bodyVelocity then
					local direction = (targetPosition - petPart.Position)
					local distance = direction.Magnitude
					
					if distance > 0.1 then
						bodyVelocity.Velocity = direction.Unit * math.min(distance * 5, 20)
					else
						bodyVelocity.Velocity = Vector3.new(0, 0, 0)
					end
				end
				
				-- Keep upright
				local bodyGyro = petPart:FindFirstChild("BodyGyro")
				if bodyGyro then
					bodyGyro.CFrame = CFrame.new(petPart.Position, humanoidRootPart.Position)
				end
			end
		end
	end
end

return PetDisplayController