-- INIT-GUARD (automatically added) - verhindert doppelte Initialisierung
do
    if _G.RB7_InitGuard == nil then _G.RB7_InitGuard = {} end
    local ok,name = pcall(function() return (script and (pcall(function() return script:GetFullName() end) and script:GetFullName())) end)
    local id = "RB7_GUARD_" .. tostring((ok and name) or (script and script.Name) or tostring(debug.getinfo(1).source))
    if _G.RB7_InitGuard[id] then return end
    _G.RB7_InitGuard[id] = true
end

-- filepath: src/server/RB7_Telemetry.lua
-- ...existing code...
local Telemetry = {}
local _hooked = {}
local _connections = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function getEventsRoot()
    local ok, root = pcall(function()
        return ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Events")
    end)
    if ok and root then return root end
    return ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Events")
end

function Telemetry.Hook(eventName, handler)
    if _hooked[eventName] then return end
    local EventsRoot = getEventsRoot()
    local ev = EventsRoot and EventsRoot:FindFirstChild(eventName)
    if not ev or not ev.OnServerEvent then return end

    _hooked[eventName] = true
    _connections[eventName] = ev.OnServerEvent:Connect(function(...)
        pcall(handler, ...)
    end)
    print(string.format("[RB7][INFO] Telemetry hooked: %s", eventName))
end

function Telemetry.Cleanup()
    for _, conn in pairs(_connections) do
        pcall(function() conn:Disconnect() end)
    end
    _connections = {}
    _hooked = {}
end

return Telemetry
-- ...existing code...
