-- Pet Quest Legends - Workspace Initialization
-- Sets up the game world

local WorldSetup = require(script.WorldSetup)

print("=== Setting up game world ===")

-- Create all worlds
WorldSetup.CreateWorlds()

-- Set up lighting
local Lighting = game:GetService("Lighting")
Lighting.Ambient = Color3.fromRGB(100, 100, 100)
Lighting.Brightness = 2
Lighting.OutdoorAmbient = Color3.fromRGB(100, 100, 100)
Lighting.TimeOfDay = "14:00:00"

-- Add atmosphere
local atmosphere = Instance.new("Atmosphere")
atmosphere.Density = 0.3
atmosphere.Offset = 0.25
atmosphere.Color = Color3.fromRGB(199, 199, 199)
atmosphere.Decay = Color3.fromRGB(106, 112, 125)
atmosphere.Glare = 0
atmosphere.Haze = 0
atmosphere.Parent = Lighting

print("=== Game world setup complete ===")