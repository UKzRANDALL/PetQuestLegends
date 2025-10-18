-- Data Sync Module - Keeps client data in sync with server
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteManager = require(ReplicatedStorage.Modules.RemoteManager)

local DataSync = {}

-- Server-side: Send data updates to client
function DataSync.UpdateClient(player, data)
RemoteManager.FireClient(player, "PlayerDataUpdated", data)
end

-- Client-side: Listen for data updates
function DataSync.StartListening(callback)
RemoteManager.OnClientEvent("PlayerDataUpdated", function(newData)
callback(newData)
end)
end

return DataSync
