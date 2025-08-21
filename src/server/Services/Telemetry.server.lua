--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Logger = require(script.Parent.Parent:WaitForChild("Lib"):WaitForChild("Logger"))
local Events = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Constants"):WaitForChild("Events"))

local function ensureFolder(parent: Instance, name: string): Folder
	local f = parent:FindFirstChild(name)
	if not f then f = Instance.new("Folder"); f.Name = name; f.Parent = parent end
	return f :: Folder
end
local RS = ReplicatedStorage
local Shared = ensureFolder(RS, "Shared")
local ERoot  = ensureFolder(Shared, Events.ROOT)
local EV     = ensureFolder(ERoot, Events.VERSION)

-- Wir hängen uns nur LESEND an RemoteEvents (keine Logikänderung)
local EVENT_NAMES = {
	Events.SET_ADS,
	Events.SET_CROUCH,
	Events.RELOAD,
	Events.EQUIP_WEAPON,
	Events.SHOOT,
}

local counters : {[string]: number} = {}
local perUser  : {[number]: {[string]: number}} = {}

local function inc(name:string, uid:number)
	counters[name] = (counters[name] or 0) + 1
	local u = perUser[uid]; if not u then u = {}; perUser[uid] = u end
	u[name] = (u[name] or 0) + 1
end

local function tryConnect(evName:string)
	local ok, inst = pcall(function() return EV:WaitForChild(evName, 1) end)
	if ok and inst and inst:IsA("RemoteEvent") then
		(inst :: RemoteEvent).OnServerEvent:Connect(function(player: Player, _payload)
			inc(evName, player.UserId)
		end)
		Logger.info("Telemetry hooked:", evName)
	else
		Logger.warn("Telemetry miss: RemoteEvent nicht gefunden:", tostring(evName))
	end
end

for _,n in ipairs(EVENT_NAMES) do
	if typeof(n)=="string" then tryConnect(n) end
end

-- alle 60s kurze Zusammenfassung (nur dev)
task.spawn(function()
	while true do
		task.wait(60)
		Logger.info("Telemetry snapshot:", counters)
	end
end)

print("[RB7_Telemetry] ✅ aktiv (RemoteEvent-Counter, read-only)")
