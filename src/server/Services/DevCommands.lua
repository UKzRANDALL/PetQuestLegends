-- Pet Quest Legends - Dev Commands Server (FOR TESTING ONLY)
-- Remove this before publishing!

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataService = require(ServerScriptService.Server.Services.DataService)
local PetConfig = require(ReplicatedStorage.Config.PetConfig)

local DevCommands = {}

function DevCommands.Init()
-- Create dev remotes folder
local devRemotesFolder = ReplicatedStorage:FindFirstChild("DevRemotes")
if not devRemotesFolder then
devRemotesFolder = Instance.new("Folder")
devRemotesFolder.Name = "DevRemotes"
devRemotesFolder.Parent = ReplicatedStorage
end

local function createDevRemote(name)
local remote = devRemotesFolder:FindFirstChild(name)
if not remote then
remote = Instance.new("RemoteEvent")
remote.Name = name
remote.Parent = devRemotesFolder
end
return remote
end

local giveCoinsRemote = createDevRemote("DevGiveCoins")
local givePetRemote = createDevRemote("DevGivePet")
local maxLevelRemote = createDevRemote("DevMaxLevel")

-- Give coins
giveCoinsRemote.OnServerEvent:Connect(function(player, amount)
	DataService.AddCoins(player, amount or 10000)
	print("[DEV] Gave " .. (amount or 10000) .. " coins to " .. player.Name)
end)

-- Give random pet
givePetRemote.OnServerEvent:Connect(function(player)
local randomPet = PetConfig.Pets[math.random(#PetConfig.Pets)]
DataService.AddPet(player, randomPet.Id, 0)
print("[DEV] Gave " .. randomPet.Name .. " to " .. player.Name)
end)

-- Max level
maxLevelRemote.OnServerEvent:Connect(function(player)
local profile = DataService.GetProfile(player)
if profile then
profile.Data.Level = 50
profile.Data.Experience = 0
print("[DEV] Set " .. player.Name .. " to level 50")
end
end)

print("[DEV COMMANDS] Server handlers loaded")
end

return DevCommands
