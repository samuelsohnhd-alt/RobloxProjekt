--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataStore = require(script.Parent:WaitForChild("DataStoreAdapter"))
local ProfileTypes = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Types"):WaitForChild("PlayerProfile"))

local store = DataStore.getStore("RB7_PlayerProfiles")
local cache:{[number]:ProfileTypes.Profile} = {}

local ProfileStore = {}

function ProfileStore.get(userId:number, name:string?): ProfileTypes.Profile
	local p = cache[userId]
	if p then return p end
	local key = tostring(userId)
	local data = store:GetAsync(key)
	if typeof(data)=="table" and data.userId == userId then
		cache[userId]=data; return data
	end
	local fresh = ProfileTypes.default(userId, name or ("User"..userId))
	cache[userId]=fresh
	store:SetAsync(key, fresh)
	return fresh
end

function ProfileStore.save(userId:number)
	local p = cache[userId]; if not p then return end
	p.updatedAt = os.time()
	store:SetAsync(tostring(userId), p)
end

function ProfileStore.addXp(userId:number, amount:number)
	local p = ProfileStore.get(userId)
	p.xp = math.max(0, (p.xp or 0) + amount)
	ProfileStore.save(userId)
	return p
end

Players.PlayerRemoving:Connect(function(plr)
	ProfileStore.save(plr.UserId)
end)

return ProfileStore
