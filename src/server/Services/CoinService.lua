-- Pet Quest Legends - Coin Service
-- Handles coin spawning and collection

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Workspace = game:GetService("Workspace")

local DataService = require(script.Parent.DataService)
local PetService = require(script.Parent.PetService)
local RemoteManager = require(ReplicatedStorage.Modules.RemoteManager)
local Utilities = require(ReplicatedStorage.Modules.Utilities)
local WorldConfig = require(ReplicatedStorage.Config.WorldConfig)

local CoinService = {}
CoinService.ActiveCoins = {}
CoinService.WorldCoinSpawners = {}

-- Initialize service
function CoinService.Init()
	-- Create coins folder
	local coinsFolder = Workspace:FindFirstChild("Coins")
	if not coinsFolder then
		coinsFolder = Instance.new("Folder")
		coinsFolder.Name = "Coins"
		coinsFolder.Parent = Workspace
	end
	
	-- Setup coin collection
	RemoteManager.OnServerEvent("CoinCollected", function(player, coinId)
		CoinService.CollectCoin(player, coinId)
	end)
	
	-- Start coin spawners for each world
	for _, world in ipairs(WorldConfig.Worlds) do
		CoinService.StartWorldSpawner(world)
	end
	
	print("[CoinService] Initialized")
end

-- Start coin spawner for a world
function CoinService.StartWorldSpawner(worldData)
	task.spawn(function()
		while true do
			task.wait(worldData.CoinSpawns.SpawnRate)
			
			-- Count existing coins for this world
			local worldCoins = 0
			for _, coin in pairs(CoinService.ActiveCoins) do
				if coin.World == worldData.Id then
					worldCoins = worldCoins + 1
				end
			end
			
			-- Spawn new coin if under max
			if worldCoins < worldData.CoinSpawns.MaxCoins then
				CoinService.SpawnCoin(worldData)
			end
		end
	end)
end

-- Spawn a coin in a world
function CoinService.SpawnCoin(worldData)
	local coinsFolder = Workspace:FindFirstChild("Coins")
	if not coinsFolder then return end
	
	-- Generate random position in world
	local spawnPos = worldData.SpawnPosition + Vector3.new(
		math.random(-50, 50),
		math.random(5, 20),
		math.random(-50, 50)
	)
	
	-- Generate random coin value
	local coinValue = math.random(worldData.CoinSpawns.MinValue, worldData.CoinSpawns.MaxValue)
	
	-- Create coin
	local coin = Instance.new("Part")
	coin.Name = "Coin"
	coin.Size = Vector3.new(2, 2, 0.5)
	coin.Position = spawnPos
	coin.Anchored = true
	coin.CanCollide = false
	coin.BrickColor = BrickColor.new("Bright yellow")
	coin.Material = Enum.Material.Neon
	coin.Shape = Enum.PartType.Cylinder
	coin.Orientation = Vector3.new(0, 0, 90)
	
	-- Add mesh for better appearance
	local mesh = Instance.new("SpecialMesh")
	mesh.MeshType = Enum.MeshType.Cylinder
	mesh.Scale = Vector3.new(1, 1, 1)
	mesh.Parent = coin
	
	-- Add spinning effect
	local spinValue = Instance.new("NumberValue")
	spinValue.Name = "Spin"
	spinValue.Value = 0
	spinValue.Parent = coin
	
	-- Generate unique ID
	local coinId = Utilities.GenerateId()
	coin:SetAttribute("CoinId", coinId)
	coin:SetAttribute("Value", coinValue)
	coin:SetAttribute("World", worldData.Id)
	
	coin.Parent = coinsFolder
	
	-- Store coin data
	CoinService.ActiveCoins[coinId] = {
		Part = coin,
		Value = coinValue,
		World = worldData.Id,
		SpawnTime = tick()
	}
	
	-- Animate coin
	task.spawn(function()
		while coin.Parent do
			coin.Orientation = coin.Orientation + Vector3.new(0, 2, 0)
			task.wait(0.03)
		end
	end)
	
	-- Auto-despawn after 60 seconds
	task.delay(60, function()
		if coin.Parent then
			CoinService.RemoveCoin(coinId)
		end
	end)
end

-- Collect a coin
function CoinService.CollectCoin(player, coinId)
	local coinData = CoinService.ActiveCoins[coinId]
	if not coinData then return end
	
	-- Check if coin still exists
	if not coinData.Part or not coinData.Part.Parent then
		CoinService.ActiveCoins[coinId] = nil
		return
	end
	
	-- Check distance (anti-cheat)
	local character = player.Character
	if character then
		local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
		if humanoidRootPart then
			local distance = (humanoidRootPart.Position - coinData.Part.Position).Magnitude
			if distance > 50 then -- Max collection distance
				return
			end
		end
	end
	
	-- Calculate final coin value with multipliers
	local multiplier = PetService.GetCoinMultiplier(player)
	local finalValue = math.floor(coinData.Value * multiplier)
	
	-- Add coins to player
	DataService.AddCoins(player, finalValue)
	
	-- Remove coin
	CoinService.RemoveCoin(coinId)
end

-- Remove a coin
function CoinService.RemoveCoin(coinId)
	local coinData = CoinService.ActiveCoins[coinId]
	if coinData and coinData.Part then
		coinData.Part:Destroy()
	end
	CoinService.ActiveCoins[coinId] = nil
end

-- Clean up all coins
function CoinService.CleanupCoins()
	for coinId, _ in pairs(CoinService.ActiveCoins) do
		CoinService.RemoveCoin(coinId)
	end
end

return CoinService