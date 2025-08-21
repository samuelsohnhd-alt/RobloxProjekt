-- filepath: src/server/RB7_EventsEnsure.lua
-- ensures ReplicatedStorage.Shared.Events.v1 and ReplicatedStorage.Events plus placeholder RemoteEvents
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local function ensureFolder(parent, name)
    local f = parent:FindFirstChild(name)
    if not f then
        f = Instance.new("Folder")
        f.Name = name
        f.Parent = parent
    end
    return f
end

local topEvents = ensureFolder(ReplicatedStorage, "Events")
local shared = ensureFolder(ReplicatedStorage, "Shared")
local events = ensureFolder(shared, "Events")
local v1 = events:FindFirstChild("v1")
if not v1 then
    v1 = Instance.new("Folder")
    v1.Name = "v1"
    v1.Parent = events
end

local names = {
    "SetADS","SetCrouchState","ReloadEvent","EquipWeapon","ShootEvent",
    "RoundTimerTick","RoundTimeUpdated","RoundStateChanged","OpenMenu"
}
for _,n in ipairs(names) do
    if not v1:FindFirstChild(n) then
        local ev = Instance.new("RemoteEvent")
        ev.Name = n
        ev.Parent = v1
    end
    if not topEvents:FindFirstChild(n) then
        local ev2 = Instance.new("RemoteEvent")
        ev2.Name = n
        ev2.Parent = topEvents
    end
end

print("[RB7_EventsEnsure] ensured ReplicatedStorage.Events and Shared/Events/v1 placeholders")
return true
