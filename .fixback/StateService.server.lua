--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Events  = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Constants"):WaitForChild("Events"))
local STypes  = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("State"):WaitForChild("PlayerState"))
local StateSchema = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Types"):WaitForChild("RemoteSchema"):WaitForChild("State_v1"))

local function ensureFolder(parent: Instance, name: string): Folder
	local f = parent:FindFirstChild(name)
	if not f then f = Instance.new("Folder"); f.Name = name; f.Parent = parent end
	return f :: Folder
end
local function ensureRE(parent: Instance, name: string): RemoteEvent
	local r = parent:FindFirstChild(name)
	if not r then r = Instance.new("RemoteEvent"); r.Name = name; r.Parent = parent end
	return r :: RemoteEvent
end
local function ensureRF(parent: Instance, name: string): RemoteFunction
	local r = parent:FindFirstChild(name)
	if not r then r = Instance.new("RemoteFunction"); r.Name = name; r.Parent = parent end
	return r :: RemoteFunction
end

-- Events-Struktur
local RS = ReplicatedStorage
local Shared = ensureFolder(RS, "Shared")
local ERoot  = ensureFolder(Shared, Events.ROOT)
local EV     = ensureFolder(ERoot, Events.VERSION)

-- Eingangs-Events (vom Client)
local RE_SetADS    = ensureRE(EV, Events.SET_ADS)
local RE_SetCrouch = ensureRE(EV, Events.SET_CROUCH)
local RE_Reload    = ensureRE(EV, Events.RELOAD)

-- State-Schnittstellen (Server -> Client, Client -> Server)
local RE_StateChanged = ensureRE(EV, Events.STATE_CHANGED)
local RF_GetState     = ensureRF(EV, Events.GET_STATE)

-- interner Cache
local cache: {[number]: any} = {}

local function getOrCreate(uid:number)
	local st = cache[uid]
	if not st then
		st = STypes.default(uid)
		cache[uid] = st
	end
	return st
end

local function syncToClient(uid:number)
	local st = cache[uid]; if not st then return end
	local payload = { userId = uid, state = st }
	if StateSchema.IsStatePayload(payload) then
		RE_StateChanged:FireAllClients(payload)
	end
end

-- RemoteFunction: Client fragt aktuellen eigenen Zustand ab
RF_GetState.OnServerInvoke = function(player)
	return getOrCreate(player.UserId)
end

-- Input-Events: Zustand setzen + syncen
RE_SetADS.OnServerEvent:Connect(function(player, payload)
	if type(payload)=="table" and type(payload.on)=="boolean" then
		local st = getOrCreate(player.UserId)
		st.ads = payload.on
		st.updatedAt = os.time()
		syncToClient(player.UserId)
	end
end)

RE_SetCrouch.OnServerEvent:Connect(function(player, payload)
	if type(payload)=="table" and type(payload.on)=="boolean" then
		local st = getOrCreate(player.UserId)
		st.crouch = payload.on
		st.updatedAt = os.time()
		syncToClient(player.UserId)
	end
end)

RE_Reload.OnServerEvent:Connect(function(player, _)
	-- Platzhalter: Hier später Munition prüfen/setzen
	local st = getOrCreate(player.UserId)
	st.updatedAt = os.time()
	syncToClient(player.UserId)
end)

-- Lifecycle
Players.PlayerAdded:Connect(function(plr)
	getOrCreate(plr.UserId)
	syncToClient(plr.UserId)
end)
Players.PlayerRemoving:Connect(function(plr)
	cache[plr.UserId] = nil
end)

print("[RB7_StateService] ✅ PlayerState aktiv (ADS/Crouch/Reload Hooks)")
