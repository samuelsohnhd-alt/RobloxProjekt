--[[
  RB7: R6V_TimerPublisher (server)
  Fix: saubere Variablen, 1s Tick, RemoteEvent "RoundTimerTick" unter ReplicatedStorage/Events/v1.
  Idempotent: Mehrfaches Starten erzeugt keine Duplikate.
]]
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Konfiguration
local RoundTimeSeconds  = 300
local PublishEverySecs  = 1

-- Helpers
local function ensureFolder(parent, name)
    local f = parent:FindFirstChild(name)
    if not f then
        f = Instance.new("Folder")
        f.Name = name
        f.Parent = parent
    end
    return f
end

local function ensureRemoteEvent(parent, name)
    local ev = parent:FindFirstChild(name)
    if not ev then
        ev = Instance.new("RemoteEvent")
        ev.Name = name
        ev.Parent = parent
    end
    return ev
end

-- Events/v1
local EventsRoot = ensureFolder(ReplicatedStorage, "Events")
local V1         = ensureFolder(EventsRoot, "v1")
local TickEvent  = ensureRemoteEvent(V1, "RoundTimerTick")

-- Einmaliger Loop per Flag
local Flag = ReplicatedStorage:FindFirstChild("_RB7_TimerPublisher_Running")
if not Flag then
    Flag = Instance.new("BoolValue")
    Flag.Name = "_RB7_TimerPublisher_Running"
    Flag.Value = false
    Flag.Parent = ReplicatedStorage
end

if not Flag.Value then
    Flag.Value = true
    task.spawn(function()
        local remaining = RoundTimeSeconds
        while remaining >= 0 do
            pcall(function() TickEvent:FireAllClients(remaining) end)
            task.wait(PublishEverySecs)
            remaining -= PublishEverySecs
        end
        pcall(function() TickEvent:FireAllClients(-1) end)
        Flag.Value = false
    end)
else
    warn("[R6V_TimerPublisher] Läuft bereits – kein zweiter Loop gestartet.")
end

print("[R6V_TimerPublisher] ✅ aktiv – RoundTimeSeconds =", RoundTimeSeconds)
