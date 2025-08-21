--!strict
-- R6V_UnlocksManager.server.lua
-- Robuste Unlock-Verwaltung (verhindert nil calls, validiert Eingaben)
local Players            = game:GetService("Players")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")

-- ===== Events/v1 sichern =====
local Events = ReplicatedStorage:FindFirstChild("Events")
if not Events then
	Events = Instance.new("Folder")
	Events.Name = "Events"
	Events.Parent = ReplicatedStorage
end

local v1 = Events:FindFirstChild("v1")
if not v1 then
	v1 = Instance.new("Folder")
	v1.Name = "v1"
	v1.Parent = Events
end

local UnlocksChanged = v1:FindFirstChild("UnlocksChanged")
if not UnlocksChanged then
	UnlocksChanged = Instance.new("RemoteEvent")
	UnlocksChanged.Name = "UnlocksChanged"
	UnlocksChanged.Parent = v1
end

local GetUnlocks = v1:FindFirstChild("GetUnlocks")
if not GetUnlocks then
	GetUnlocks = Instance.new("RemoteFunction")
	GetUnlocks.Name = "GetUnlocks"
	GetUnlocks.Parent = v1
end

-- ===== Datenhaltung =====
type UnlockState = { [string]: boolean }
local PlayerUnlocks: { [number]: UnlockState } = {}

local function getState(userId: number): UnlockState
	PlayerUnlocks[userId] = PlayerUnlocks[userId] or {}
	return PlayerUnlocks[userId]
end

local function setUnlocked(userId: number, key: string, value: boolean)
	local state = getState(userId)
	state[key] = value
end

local function tableClone(t: UnlockState): UnlockState
	local out: UnlockState = {}
	for k,v in pairs(t) do out[k] = v end
	return out
end

-- ===== API (Server-seitig) =====
local function validateKey(key: any): (boolean, string?)
	if typeof(key) ~= "string" or #key == 0 or #key > 64 then
		return false, "bad_key"
	end
	return true, nil
end

local function validateBool(b: any): (boolean, string?)
	if typeof(b) ~= "boolean" then
		return false, "bad_value"
	end
	return true, nil
end

-- Clients können ihren aktuellen Stand abrufen
GetUnlocks.OnServerInvoke = function(player: Player)
	local ok, result = pcall(function()
		return tableClone(getState(player.UserId))
	end)
	if ok then return result end
	warn("[R6V_UnlocksManager] GetUnlocks pcall fail:", result)
	return {}
end

-- Serverseitige Setter-API (z. B. aus GameLogic/Rewards aufrufen)
local function SafeSet(player: Player, key: string, value: boolean)
	local ok1, err1 = validateKey(key)
	if not ok1 then return false, err1 end
	local ok2, err2 = validateBool(value)
	if not ok2 then return false, err2 end

	local ok, err = pcall(function()
		setUnlocked(player.UserId, key, value)
		UnlocksChanged:FireClient(player, key, value)
	end)
	if not ok then
		warn("[R6V_UnlocksManager] SafeSet pcall fail:", err)
		return false, "set_failed"
	end
	return true, nil
end

-- Beispiel-Hooks (optional): gewähre Basis-Unlocks beim Join
Players.PlayerAdded:Connect(function(plr)
	local state = getState(plr.UserId)
	-- Initial Defaults (nur wenn leer)
	if next(state) == nil then
		state["Loadout/Primary/Default"] = true
		state["Loadout/Secondary/Default"] = true
	end
	-- Client initial informieren
	task.defer(function()
		for k,v in pairs(state) do
			UnlocksChanged:FireClient(plr, k, v)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(plr)
	PlayerUnlocks[plr.UserId] = nil
end)

-- ===== Exporte für andere ServerScripts =====
local Module = {}
function Module.Get(player: Player): UnlockState
	return tableClone(getState(player.UserId))
end
function Module.Set(player: Player, key: string, value: boolean): boolean
	local ok = SafeSet(player, key, value)
	return ok and true or false
end
function Module.Grant(player: Player, key: string): boolean
	return Module.Set(player, key, true)
end
function Module.Revoke(player: Player, key: string): boolean
	return Module.Set(player, key, false)
end

print("[R6V_UnlocksManager] ✅ bereit.")
return Module
