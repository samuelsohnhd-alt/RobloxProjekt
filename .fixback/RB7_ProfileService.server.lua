--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Events = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Constants"):WaitForChild("Events"))
local ProfileTypes = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Types"):WaitForChild("PlayerProfile"))
-- Stores liegt unter ServerScriptService/Server/Stores → vom Skript aus: script.Parent:WaitForChild("Stores")
local ProfileStore = require(script.Parent:WaitForChild("Stores"):WaitForChild("ProfileStore"))

local function ensureFolder(parent: Instance, name: string): Folder
	local f = parent:FindFirstChild(name)
	if not f then f = Instance.new("Folder"); f.Name = name; f.Parent = parent end
	return f :: Folder
end
local function ensureRemoteEvent(parent: Instance, name: string): RemoteEvent
	local r = parent:FindFirstChild(name)
	if not r then r = Instance.new("RemoteEvent"); r.Name = name; r.Parent = parent end
	return r :: RemoteEvent
end
local function ensureRemoteFunction(parent: Instance, name: string): RemoteFunction
	local r = parent:FindFirstChild(name)
	if not r then r = Instance.new("RemoteFunction"); r.Name = name; r.Parent = parent end
	return r :: RemoteFunction
end

-- Events-Struktur
local RS = ReplicatedStorage
local Shared = ensureFolder(RS, "Shared")
local ERoot  = ensureFolder(Shared, Events.ROOT)
local EV     = ensureFolder(ERoot, Events.VERSION)

local RF_GetProfile = ensureRemoteFunction(EV, Events.GET_PROFILE)
local RE_ProfileUpdated = ensureRemoteEvent(EV, Events.PROFILE_UPDATED)

RF_GetProfile.OnServerInvoke = function(player)
	local prof = ProfileStore.get(player.UserId, player.Name)
	return prof
end

Players.PlayerAdded:Connect(function(plr)
	local prof = ProfileStore.get(plr.UserId, plr.Name)
	RE_ProfileUpdated:FireClient(plr, prof)
end)

print("[RB7_ProfileService] ✅ Profile RF/RE aktiv")
