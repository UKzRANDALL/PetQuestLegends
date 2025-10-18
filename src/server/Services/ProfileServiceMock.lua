-- Mock ProfileService for development
-- Replace this with the actual ProfileService module from Roblox

local ProfileServiceMock = {}

local ProfileStore = {}
ProfileStore.__index = ProfileStore

local Profile = {}
Profile.__index = Profile

function ProfileServiceMock.GetProfileStore(name, template)
	local store = setmetatable({
		Name = name,
		Template = template,
		Profiles = {}
	}, ProfileStore)
	return store
end

function ProfileStore:LoadProfileAsync(key, forceLoad)
	-- Simulate loading
	task.wait(0.1)
	
	local profile = setmetatable({
		Key = key,
		Data = self:DeepCopy(self.Template),
		Store = self,
		Released = false,
		ReleaseCallbacks = {}
	}, Profile)
	
	self.Profiles[key] = profile
	return profile
end

function ProfileStore:DeepCopy(original)
	local copy
	if type(original) == "table" then
		copy = {}
		for key, value in pairs(original) do
			copy[self:DeepCopy(key)] = self:DeepCopy(value)
		end
	else
		copy = original
	end
	return copy
end

function Profile:AddUserId(userId)
	self.UserId = userId
end

function Profile:Reconcile()
	-- Merge template with existing data
	local function reconcile(data, template)
		for key, value in pairs(template) do
			if data[key] == nil then
				if type(value) == "table" then
					data[key] = {}
					reconcile(data[key], value)
				else
					data[key] = value
				end
			elseif type(value) == "table" and type(data[key]) == "table" then
				reconcile(data[key], value)
			end
		end
	end
	reconcile(self.Data, self.Store.Template)
end

function Profile:ListenToRelease(callback)
	table.insert(self.ReleaseCallbacks, callback)
end

function Profile:Release()
	if not self.Released then
		self.Released = true
		for _, callback in ipairs(self.ReleaseCallbacks) do
			task.spawn(callback)
		end
		self.Store.Profiles[self.Key] = nil
	end
end

return ProfileServiceMock