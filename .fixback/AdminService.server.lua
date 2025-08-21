--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Events = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Constants"):WaitForChild("Events"))
local Env    = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Config"):WaitForChild("Env"))
local Build  = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Meta"):WaitForChild("Build"))
local Admins = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Config"):WaitForChild("Admins"))

local START = os.clock()

local function ensureFolder(parent: Instance, name: string): Folder
	local f = parent:FindFirstChild(name)
	if not f then f = Instance.new("Folder"); f.Name = name; f.Parent = parent end
	return f :: Folder
end
local function ensureRF(parent: Instance, name: string): RemoteFunction
	local r = parent:FindFirstChild(name)
	if not r then r = Instance.new("RemoteFunction"); r.Name = name; r.Parent = parent end
	return r :: RemoteFunction
end

local RS     = ReplicatedStorage
local Shared = ensureFolder(RS, "Shared")
local ERoot  = ensureFolder(Shared, Events.ROOT)
local EV     = ensureFolder(ERoot, Events.VERSION)

local RF_GetServerStats = ensureRF(EV, Events.GET_SERVER_STATS)

local lastCall:{[number]:number} = {}

local function makeStats()
	local players = #Players:GetPlayers()
	local uptime  = math.floor(os.clock() - START)
	return {
		env     = Env.NAME,
		build   = Build.Version,
		players = players,
		uptime  = uptime,
	}
end

RF_GetServerStats.OnServerInvoke = function(player)
	if not Admins.isAdmin(player.UserId, player.Name) then
		return { ok=false, error="forbidden" }
	end
	local now = os.clock()
	local prev = lastCall[player.UserId] or 0
	if now - prev < 3 then
		return { ok=false, error="rate_limited" }
	end
	lastCall[player.UserId] = now
	return { ok=true, data=makeStats() }
end

print("[RB7_AdminService] ✅ GetServerStats aktiv (RBAC + RateLimit)")
