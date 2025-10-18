-- Pet Quest Legends - Remote Manager
-- Centralized remote event/function management

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RemoteManager = {}
RemoteManager.Remotes = {}

-- Create remotes folder
local remotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
if not remotesFolder then
remotesFolder = Instance.new("Folder")
remotesFolder.Name = "Remotes"
remotesFolder.Parent = ReplicatedStorage
end

-- Remote definitions
local remoteDefinitions = {
-- Events (one-way communication)
Events = {
"CoinCollected",
"PetHatched",
"PetMerged",
"PetEquipped",
"PetUnequipped",
"QuestCompleted",
"LevelUp",
"WorldUnlocked",
"TradeRequest",
"TradeAccepted",
"TradeCancelled",
"TradeCompleted",
"TradeUpdated",
"GuildInvite",
"GuildJoined",
"GuildLeft",
"BoostActivated",
"NotificationSent",
"PlayerDataLoaded",
"AddPetToTrade",
"RemovePetFromTrade",
"ConfirmTrade",
"KickGuildMember",
"PromoteGuildMember",
"DemoteGuildMember"
},

-- Functions (two-way communication with return values)
Functions = {
"GetPlayerData",
"HatchEgg",
"MergePets",
"EquipPet",
"UnequipPet",
"UnlockWorld",
"ClaimQuestReward",
"CreateGuild",
"JoinGuild",
"LeaveGuild",
"ContributeToGuild",
"InitiateTrade",
"AcceptTrade",
"DeclineTrade",
"CancelTrade",
"PurchaseGamepass",
"PurchasePremiumEgg",
"ActivateBoost",
"DeletePet",
"GetLeaderboard",
"GetGuildData",
"GetTradeValue",
"PrestigePlayer"
}
}

-- Create or get remote events
for _, eventName in ipairs(remoteDefinitions.Events) do
local remote = remotesFolder:FindFirstChild(eventName)
if not remote then
remote = Instance.new("RemoteEvent")
remote.Name = eventName
remote.Parent = remotesFolder
end
RemoteManager.Remotes[eventName] = remote
end

-- Create or get remote functions
for _, functionName in ipairs(remoteDefinitions.Functions) do
local remote = remotesFolder:FindFirstChild(functionName)
if not remote then
remote = Instance.new("RemoteFunction")
remote.Name = functionName
remote.Parent = remotesFolder
end
RemoteManager.Remotes[functionName] = remote
end

-- Get a remote by name
function RemoteManager.GetRemote(remoteName)
return RemoteManager.Remotes[remoteName]
end

-- Fire event to client
function RemoteManager.FireClient(player, eventName, ...)
local remote = RemoteManager.GetRemote(eventName)
if remote and remote:IsA("RemoteEvent") then
remote:FireClient(player, ...)
else
warn("Remote event not found or is not a RemoteEvent:", eventName)
end
end

-- Fire event to all clients
function RemoteManager.FireAllClients(eventName, ...)
local remote = RemoteManager.GetRemote(eventName)
if remote and remote:IsA("RemoteEvent") then
remote:FireAllClients(...)
else
warn("Remote event not found or is not a RemoteEvent:", eventName)
end
end

-- Fire event to server (client-side)
function RemoteManager.FireServer(eventName, ...)
local remote = RemoteManager.GetRemote(eventName)
if remote and remote:IsA("RemoteEvent") then
remote:FireServer(...)
else
warn("Remote event not found or is not a RemoteEvent:", eventName)
end
end

-- Invoke server (client-side)
function RemoteManager.InvokeServer(functionName, ...)
local remote = RemoteManager.GetRemote(functionName)
if remote and remote:IsA("RemoteFunction") then
return remote:InvokeServer(...)
else
warn("Remote function not found or is not a RemoteFunction:", functionName)
return nil
end
end

-- Connect to event (client-side)
function RemoteManager.OnClientEvent(eventName, callback)
local remote = RemoteManager.GetRemote(eventName)
if remote and remote:IsA("RemoteEvent") then
return remote.OnClientEvent:Connect(callback)
else
warn("Remote event not found or is not a RemoteEvent:", eventName)
end
end

-- Connect to event (server-side)
function RemoteManager.OnServerEvent(eventName, callback)
local remote = RemoteManager.GetRemote(eventName)
if remote and remote:IsA("RemoteEvent") then
return remote.OnServerEvent:Connect(callback)
else
warn("Remote event not found or is not a RemoteEvent:", eventName)
end
end

-- Set callback for function (server-side)
function RemoteManager.SetCallback(functionName, callback)
local remote = RemoteManager.GetRemote(functionName)
if remote and remote:IsA("RemoteFunction") then
remote.OnServerInvoke = callback
else
warn("Remote function not found or is not a RemoteFunction:", functionName)
end
end

return RemoteManager
