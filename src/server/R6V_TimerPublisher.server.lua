-- RB7: R6V_TimerPublisher (server) – sendet RoundTimerTick über Shared/Events/v1
local RS = game:GetService("ReplicatedStorage")

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

local Shared = ensureFolder(RS, "Shared")
local Events = ensureFolder(Shared, "Events")
local V1     = ensureFolder(Events, "v1")
local TickEvent = ensureRemoteEvent(V1, "RoundTimerTick")

local RoundTimeSeconds = 300
local PublishEverySecs = 1

local Flag = RS:FindFirstChild("_RB7_TimerPublisher_Running")
if not Flag then
    Flag = Instance.new("BoolValue")
    Flag.Name = "_RB7_TimerPublisher_Running"
    Flag.Parent = RS
    Flag.Value = false
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

print("[R6V_TimerPublisher] ✅ aktiv – RoundTimerTick unter Shared/Events/v1")
