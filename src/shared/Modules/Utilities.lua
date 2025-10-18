-- Pet Quest Legends - Utility Functions
-- Common utility functions used throughout the game

local Utilities = {}

-- Format large numbers with suffixes (K, M, B, T)
function Utilities.FormatNumber(number)
if number < 1000 then
return tostring(math.floor(number))
elseif number < 1000000 then
return string.format("%.1fK", number / 1000)
elseif number < 1000000000 then
return string.format("%.1fM", number / 1000000)
elseif number < 1000000000000 then
return string.format("%.1fB", number / 1000000000)
else
return string.format("%.1fT", number / 1000000000000)
end
end

-- Format time in seconds to readable format
function Utilities.FormatTime(seconds)
if seconds < 60 then
return string.format("%ds", seconds)
elseif seconds < 3600 then
local minutes = math.floor(seconds / 60)
local secs = seconds % 60
return string.format("%dm %ds", minutes, secs)
else
local hours = math.floor(seconds / 3600)
local minutes = math.floor((seconds % 3600) / 60)
return string.format("%dh %dm", hours, minutes)
end
end

-- Deep copy a table
function Utilities.DeepCopy(original)
local copy
if type(original) == "table" then
copy = {}
for key, value in pairs(original) do
copy[Utilities.DeepCopy(key)] = Utilities.DeepCopy(value)
end
setmetatable(copy, Utilities.DeepCopy(getmetatable(original)))
else
copy = original
end
return copy
end

-- Merge two tables
function Utilities.MergeTables(t1, t2)
local result = Utilities.DeepCopy(t1)
for key, value in pairs(t2) do
if type(value) == "table" and type(result[key]) == "table" then
result[key] = Utilities.MergeTables(result[key], value)
else
result[key] = value
end
end
return result
end

-- Check if table contains value
function Utilities.TableContains(table, value)
for _, v in pairs(table) do
if v == value then
return true
end
end
return false
end

-- Get table length (works with non-sequential tables)
function Utilities.TableLength(table)
local count = 0
for _ in pairs(table) do
count = count + 1
end
return count
end

-- Shuffle table randomly
function Utilities.ShuffleTable(table)
local shuffled = Utilities.DeepCopy(table)
for i = #shuffled, 2, -1 do
local j = math.random(i)
shuffled[i], shuffled[j] = shuffled[j], shuffled[i]
end
return shuffled
end

-- Get random element from table
function Utilities.GetRandomElement(table)
if #table == 0 then return nil end
return table[math.random(#table)]
end

-- Weighted random selection
function Utilities.WeightedRandom(weights)
local totalWeight = 0
for _, weight in pairs(weights) do
totalWeight = totalWeight + weight
end

local random = math.random() * totalWeight
local currentWeight = 0

for key, weight in pairs(weights) do
currentWeight = currentWeight + weight
if random <= currentWeight then
return key
end
end

-- Fallback
return next(weights)
end

-- Clamp value between min and max
function Utilities.Clamp(value, min, max)
return math.max(min, math.min(max, value))
end

-- Lerp between two values
function Utilities.Lerp(a, b, t)
return a + (b - a) * t
end

-- Round number to decimal places
function Utilities.Round(number, decimals)
local mult = 10 ^ (decimals or 0)
return math.floor(number * mult + 0.5) / mult
end

-- Generate unique ID
function Utilities.GenerateId()
return game:GetService("HttpService"):GenerateGUID(false)
end

-- Wait for child with timeout
function Utilities.WaitForChildTimeout(parent, childName, timeout)
local startTime = tick()
while not parent:FindFirstChild(childName) do
if tick() - startTime > timeout then
return nil
end
task.wait(0.1)
end
return parent:FindFirstChild(childName)
end

-- Safe player removal check
function Utilities.IsPlayerValid(player)
return player and player.Parent and player:IsDescendantOf(game)
end

-- Get distance between two positions
function Utilities.GetDistance(pos1, pos2)
return (pos1 - pos2).Magnitude
end

-- Check if position is within bounds
function Utilities.IsInBounds(position, center, radius)
return Utilities.GetDistance(position, center) <= radius
end

-- Create tween info
function Utilities.CreateTweenInfo(duration, easingStyle, easingDirection, repeatCount, reverses, delayTime)
return TweenInfo.new(
duration or 1,
easingStyle or Enum.EasingStyle.Linear,
easingDirection or Enum.EasingDirection.Out,
repeatCount or 0,
reverses or false,
delayTime or 0
)
end

-- Debounce function
function Utilities.Debounce(func, delay)
local lastCall = 0
return function(...)
local args = {...}
local now = tick()
if now - lastCall >= delay then
lastCall = now
return func(table.unpack(args))
end
end
end

-- Throttle function
function Utilities.Throttle(func, delay)
local lastCall = 0
local scheduled = false

return function(...)
local args = {...}
local now = tick()
if now - lastCall >= delay then
lastCall = now
return func(table.unpack(args))
elseif not scheduled then
scheduled = true
task.delay(delay - (now - lastCall), function()
scheduled = false
lastCall = tick()
func(table.unpack(args))
end)
end
end
end

-- Retry function with exponential backoff
function Utilities.RetryWithBackoff(func, maxRetries, initialDelay)
local retries = 0
local delay = initialDelay or 1

while retries < maxRetries do
local success, result = pcall(func)
if success then
return true, result
end

retries = retries + 1
if retries < maxRetries then
task.wait(delay)
delay = delay * 2
end
end

return false, nil
end

-- Safe division (prevents division by zero)
function Utilities.SafeDivide(a, b, default)
if b == 0 then
return default or 0
end
return a / b
end

-- Calculate percentage
function Utilities.CalculatePercentage(value, total)
return Utilities.SafeDivide(value * 100, total, 0)
end

-- Check if value is in range
function Utilities.InRange(value, min, max)
return value >= min and value <= max
end

return Utilities
