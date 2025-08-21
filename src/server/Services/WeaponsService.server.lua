--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Events   = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Constants"):WaitForChild("Events"))
local WConfig  = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Weapons"):WaitForChild("Config"))
local WSchema  = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Types"):WaitForChild("RemoteSchema"):WaitForChild("Weapons_v1"))
local LoadoutStore = require(script.Parent.Parent:WaitForChild("Stores"):WaitForChild("LoadoutStore"))

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

-- Event-Struktur
local RS = ReplicatedStorage
local Shared = ensureFolder(RS, "Shared")
local ERoot  = ensureFolder(Shared, Events.ROOT)
local EV     = ensureFolder(ERoot, Events.VERSION)

local RE_Equip      = ensureRE(EV, Events.EQUIP_WEAPON)
local RE_Shoot      = ensureRE(EV, Events.SHOOT)
local RE_Reload     = ensureRE(EV, Events.RELOAD)
local RE_AmmoUp     = ensureRE(EV, Events.AMMO_UPDATE)
local RF_GetLoadout = ensureRF(EV, Events.GET_LOADOUT)

-- Per-Player Ammo/Zustand
type AmmoState = { [string]: { mag:number, reserve:number } }
local ammoCache: {[number]: AmmoState} = {}
local equipped:  {[number]: string}    = {}

local function cloneAmmoState(src: AmmoState): AmmoState
	local t: AmmoState = {}
	for k,v in pairs(src) do t[k] = { mag = v.mag, reserve = v.reserve } end
	return t
end

local function initDefaults(): AmmoState
	local a:AmmoState = {}
	for name,cfg in pairs(WConfig.Weapons) do
		a[name] = { mag = cfg.magSize, reserve = cfg.reserve }
	end
	return a
end

local function initPlayer(uid:number)
	if ammoCache[uid] then return end
	-- Laden
	local saved = LoadoutStore.get(uid)
	if typeof(saved)=="table" then
		ammoCache[uid] = {}
		local defaults = initDefaults()
		-- Merge: nur bekannte Waffen übernehmen
		for name,cfg in pairs(WConfig.Weapons) do
			local s = (saved.ammo and saved.ammo[name]) or defaults[name]
			ammoCache[uid][name] = { mag = s.mag, reserve = s.reserve }
		end
		equipped[uid] = saved.equipped or WConfig.DefaultLoadout.Primary
	else
		ammoCache[uid] = initDefaults()
		equipped[uid] = WConfig.DefaultLoadout.Primary
	end
end

local function persist(uid:number)
	local data = {
		equipped = equipped[uid],
		ammo = ammoCache[uid] and cloneAmmoState(ammoCache[uid]) or nil,
	}
	LoadoutStore.set(uid, data)
end

local function sendAmmo(player: Player, name:string)
	local a = ammoCache[player.UserId]
	if not a or not a[name] then return end
	local payload = { name=name, mag=a[name].mag, reserve=a[name].reserve }
	if WSchema.IsAmmoUpdate(payload) then
		RE_AmmoUp:FireClient(player, payload)
	end
end

RF_GetLoadout.OnServerInvoke = function(player)
	initPlayer(player.UserId)
	return {
		Primary = WConfig.DefaultLoadout.Primary,
		Secondary = WConfig.DefaultLoadout.Secondary,
		Equipped = equipped[player.UserId],
	}
end

RE_Equip.OnServerEvent:Connect(function(player, payload)
	if not WSchema.IsEquip(payload) then return end
	initPlayer(player.UserId)
	local name = payload.name
	if WConfig.Weapons[name] then
		equipped[player.UserId] = name
		sendAmmo(player, name)
		persist(player.UserId)
	end
end)

RE_Shoot.OnServerEvent:Connect(function(player, payload)
	if not WSchema.IsShoot(payload) then return end
	initPlayer(player.UserId)
	local name = payload.name
	local a = ammoCache[player.UserId]; if not a or not a[name] then return end
	if a[name].mag > 0 then
		a[name].mag -= 1
		sendAmmo(player, name)
		persist(player.UserId)
	end
end)

RE_Reload.OnServerEvent:Connect(function(player, _)
	initPlayer(player.UserId)
	local curr = equipped[player.UserId]; if not curr then return end
	local cfg = WConfig.Weapons[curr]; if not cfg then return end
	local a = ammoCache[player.UserId][curr]; if not a then return end
	local needed = cfg.magSize - a.mag
	if needed > 0 and a.reserve > 0 then
		local take = math.min(needed, a.reserve)
		a.mag += take
		a.reserve -= take
		sendAmmo(player, curr)
		persist(player.UserId)
	end
end)

Players.PlayerAdded:Connect(function(plr)
	initPlayer(plr.UserId)
	task.defer(function()
		sendAmmo(plr, equipped[plr.UserId])
	end)
end)
Players.PlayerRemoving:Connect(function(plr)
	if ammoCache[plr.UserId] or equipped[plr.UserId] then
		persist(plr.UserId)
	end
	ammoCache[plr.UserId] = nil
	equipped[plr.UserId] = nil
end)

print("[RB7_WeaponsService] ✅ aktiv (Equip/Shoot/Reload/Ammo, persistiert)")
