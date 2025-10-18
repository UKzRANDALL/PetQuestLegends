-- Pet Quest Legends - Workspace Setup
-- Creates basic world structures

local WorldConfig = require(game:GetService("ReplicatedStorage").Config.WorldConfig)

local WorldSetup = {}

function WorldSetup.CreateWorlds()
	-- Create worlds folder
	local worldsFolder = Instance.new("Folder")
	worldsFolder.Name = "Worlds"
	worldsFolder.Parent = workspace
	
	for _, worldData in ipairs(WorldConfig.Worlds) do
		WorldSetup.CreateWorld(worldData, worldsFolder)
	end
end

function WorldSetup.CreateWorld(worldData, parent)
	local worldFolder = Instance.new("Folder")
	worldFolder.Name = worldData.Id
	worldFolder.Parent = parent
	
	-- Create spawn platform
	local spawnPlatform = Instance.new("Part")
	spawnPlatform.Name = "SpawnPlatform"
	spawnPlatform.Size = Vector3.new(50, 1, 50)
	spawnPlatform.Position = worldData.SpawnPosition
	spawnPlatform.Anchored = true
	spawnPlatform.BrickColor = BrickColor.new("Bright green")
	spawnPlatform.Material = Enum.Material.Grass
	spawnPlatform.Parent = worldFolder
	
	-- Create spawn location
	local spawnLocation = Instance.new("SpawnLocation")
	spawnLocation.Name = "SpawnLocation"
	spawnLocation.Size = Vector3.new(10, 1, 10)
	spawnLocation.Position = worldData.SpawnPosition + Vector3.new(0, 1, 0)
	spawnLocation.Anchored = true
	spawnLocation.Transparency = 0.5
	spawnLocation.CanCollide = false
	spawnLocation.BrickColor = BrickColor.new("Bright blue")
	spawnLocation.Parent = worldFolder
	
	-- Create egg stand
	local eggStand = Instance.new("Part")
	eggStand.Name = "EggStand"
	eggStand.Size = Vector3.new(8, 1, 8)
	eggStand.Position = worldData.SpawnPosition + Vector3.new(15, 0.5, 0)
	eggStand.Anchored = true
	eggStand.BrickColor = BrickColor.new("Gold")
	eggStand.Material = Enum.Material.Marble
	eggStand.Parent = worldFolder
	
	-- Create world sign
	local sign = Instance.new("Part")
	sign.Name = "WorldSign"
	sign.Size = Vector3.new(10, 5, 0.5)
	sign.Position = worldData.SpawnPosition + Vector3.new(0, 3, -20)
	sign.Anchored = true
	sign.BrickColor = BrickColor.new("Dark stone grey")
	sign.Material = Enum.Material.Wood
	sign.Parent = worldFolder
	
	local surfaceGui = Instance.new("SurfaceGui")
	surfaceGui.Face = Enum.NormalId.Front
	surfaceGui.Parent = sign
	
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = worldData.Name
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextSize = 48
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextStrokeTransparency = 0.5
	textLabel.Parent = surfaceGui
	
	-- Create decorative elements based on world theme
	WorldSetup.CreateWorldDecorations(worldData, worldFolder)
end

function WorldSetup.CreateWorldDecorations(worldData, worldFolder)
	-- Add theme-specific decorations
	if worldData.Id == "StarterForest" then
		-- Add trees
		for i = 1, 10 do
			local tree = Instance.new("Part")
			tree.Name = "Tree"
			tree.Size = Vector3.new(2, 10, 2)
			tree.Position = worldData.SpawnPosition + Vector3.new(
				math.random(-40, 40),
				5,
				math.random(-40, 40)
			)
			tree.Anchored = true
			tree.BrickColor = BrickColor.new("Brown")
			tree.Material = Enum.Material.Wood
			tree.Parent = worldFolder
			
			local leaves = Instance.new("Part")
			leaves.Name = "Leaves"
			leaves.Size = Vector3.new(8, 8, 8)
			leaves.Position = tree.Position + Vector3.new(0, 9, 0)
			leaves.Anchored = true
			leaves.BrickColor = BrickColor.new("Dark green")
			leaves.Material = Enum.Material.Grass
			leaves.Shape = Enum.PartType.Ball
			leaves.Parent = worldFolder
		end
	elseif worldData.Id == "CandyKingdom" then
		-- Add candy decorations
		for i = 1, 10 do
			local candy = Instance.new("Part")
			candy.Name = "Candy"
			candy.Size = Vector3.new(3, 3, 3)
			candy.Position = worldData.SpawnPosition + Vector3.new(
				math.random(-40, 40),
				1.5,
				math.random(-40, 40)
			)
			candy.Anchored = true
			candy.BrickColor = BrickColor.Random()
			candy.Material = Enum.Material.Neon
			candy.Shape = Enum.PartType.Ball
			candy.Parent = worldFolder
		end
	end
end

return WorldSetup