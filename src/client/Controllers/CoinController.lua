-- Pet Quest Legends - Coin Controller
-- Handles coin collection on the client side

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local RemoteManager = require(ReplicatedStorage.Modules.RemoteManager)
local Utilities = require(ReplicatedStorage.Modules.Utilities)

local CoinController = {}
CoinController.CollectionRange = 10
CoinController.AutoCollectEnabled = true

-- Initialize controller
function CoinController.Init()
	local player = Players.LocalPlayer
	
	-- Auto-collect coins
	RunService.Heartbeat:Connect(function()
		if CoinController.AutoCollectEnabled then
			CoinController.CollectNearbyCoins()
		end
	end)
	
	print("[CoinController] Initialized")
end

-- Collect nearby coins
function CoinController.CollectNearbyCoins()
	local player = Players.LocalPlayer
	local character = player.Character
	if not character then return end
	
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return end
	
	local coinsFolder = Workspace:FindFirstChild("Coins")
	if not coinsFolder then return end
	
	-- Check all coins
	for _, coin in ipairs(coinsFolder:GetChildren()) do
		if coin:IsA("BasePart") and coin:GetAttribute("CoinId") then
			local distance = (coin.Position - humanoidRootPart.Position).Magnitude
			
			if distance <= CoinController.CollectionRange then
				-- Collect coin
				local coinId = coin:GetAttribute("CoinId")
				RemoteManager.FireServer("CoinCollected", coinId)
			end
		end
	end
end

-- Set auto-collect enabled
function CoinController.SetAutoCollect(enabled)
	CoinController.AutoCollectEnabled = enabled
end

return CoinController