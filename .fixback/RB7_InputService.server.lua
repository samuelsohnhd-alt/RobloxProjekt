--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Constants"):WaitForChild("Events"))
local Limits = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Constants"):WaitForChild("Limits"))
local InputsSchema = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Types"):WaitForChild("RemoteSchema"):WaitForChild("Inputs_v1"))
local RateLimiter = require(script.Parent:WaitForChild("Lib"):WaitForChild("RateLimiter"))

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

local RS     = ReplicatedStorage
local Shared = ensureFolder(RS, "Shared")
local ERoot  = ensureFolder(Shared, Events.ROOT)
local EV     = ensureFolder(ERoot, Events.VERSION)

local RE_SetADS    = ensureRE(EV, Events.SET_ADS)
local RE_SetCrouch = ensureRE(EV, Events.SET_CROUCH)
local RE_Reload    = ensureRE(EV, Events.RELOAD)

local function allowed(uid:number, eventName:string): boolean
	local lim = Limits[eventName]
	if not lim then return true end
	return RateLimiter.check(uid, eventName, lim.cap, lim.rate)
end

RE_SetADS.OnServerEvent:Connect(function(player, payload)
	if not InputsSchema.IsSetADS(payload) then return end
	if not allowed(player.UserId, Events.SET_ADS) then return end
	-- (StateService setzt flags & broadcastet bereits)
end)

RE_SetCrouch.OnServerEvent:Connect(function(player, payload)
	if not InputsSchema.IsSetCrouch(payload) then return end
	if not allowed(player.UserId, Events.SET_CROUCH) then return end
end)

RE_Reload.OnServerEvent:Connect(function(player, payload)
	if not InputsSchema.IsReload(payload) then return end
	if not allowed(player.UserId, Events.RELOAD) then return end
end)

print("[RB7_InputService] ✅ mit Rate-Limiter aktiv")
