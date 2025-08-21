--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Constants"):WaitForChild("Events"))
local InputsSchema = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Types"):WaitForChild("RemoteSchema"):WaitForChild("Inputs_v1"))

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

-- Events-Struktur
local RS = ReplicatedStorage
local Shared = ensureFolder(RS, "Shared")
local ERoot  = ensureFolder(Shared, Events.ROOT)
local EV     = ensureFolder(ERoot, Events.VERSION)

local RE_SetADS    = ensureRE(EV, Events.SET_ADS)
local RE_SetCrouch = ensureRE(EV, Events.SET_CROUCH)
local RE_Reload    = ensureRE(EV, Events.RELOAD)

RE_SetADS.OnServerEvent:Connect(function(player, payload)
	if not InputsSchema.IsSetADS(payload) then return end
	-- TODO: Spielerzustand aktualisieren (z.B. in PlayerState)
	-- print(("[INPUT][ADS] %s -> %s"):format(player.Name, tostring(payload.on)))
end)
RE_SetCrouch.OnServerEvent:Connect(function(player, payload)
	if not InputsSchema.IsSetCrouch(payload) then return end
	-- print(("[INPUT][CROUCH] %s -> %s"):format(player.Name, tostring(payload.on)))
end)
RE_Reload.OnServerEvent:Connect(function(player, payload)
	if not InputsSchema.IsReload(payload) then return end
	-- print(("[INPUT][RELOAD] %s"):format(player.Name))
end)

print("[RB7_InputService] ✅ Inputs bereit (ADS/Crouch/Reload)")
