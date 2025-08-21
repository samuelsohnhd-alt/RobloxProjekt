-- RB7_EventsEnsure: vereinheitlicht Remotes unter ReplicatedStorage/Shared/Events/v1
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

local Shared  = ensureFolder(RS, "Shared")
local Events  = ensureFolder(Shared, "Events")
local V1      = ensureFolder(Events, "v1")

local function ensureRemoteEvent(parent, name)
    local ev = parent:FindFirstChild(name)
    if not ev then
        ev = Instance.new("RemoteEvent")
        ev.Name = name
        ev.Parent = parent
    end
    return ev
end

local function ensureRemoteFunction(parent, name)
    local rf = parent:FindFirstChild(name)
    if not rf then
        rf = Instance.new("RemoteFunction")
        rf.Name = name
        rf.Parent = parent
    end
    return rf
end

-- Kern-Remotes, die UI/Services erwarten
local neededEvents = {
    "OpenMenu",
    "RoundTimerTick",
    "ReloadEvent",
    "EquipWeapon",
    "ShootEvent",
}
for _,n in ipairs(neededEvents) do
    ensureRemoteEvent(V1, n)
end

-- Migration: falls noch altes 'ReplicatedStorage/Events/v1' existiert → Kinder nach Shared/Events/v1 verschieben
do
    local oldRoot = RS:FindFirstChild("Events")
    if oldRoot and oldRoot:FindFirstChild("v1") then
        local oldV1 = oldRoot.v1
        for _,child in ipairs(oldV1:GetChildren()) do
            if not V1:FindFirstChild(child.Name) then
                child.Parent = V1
            end
        end
        -- optional: alten Knoten bereinigen
        oldRoot:Destroy()
    end
end

print("[RB7_EventsEnsure] ✅ Remotes unter ReplicatedStorage/Shared/Events/v1 vereinheitlicht")
