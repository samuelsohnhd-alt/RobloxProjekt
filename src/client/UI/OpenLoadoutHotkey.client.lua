local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local events = ReplicatedStorage:FindFirstChild("Shared")
events = events and events:FindFirstChild("Events")
events = events and (events:FindFirstChild("v1") or events)

local OpenMenu = events and events:FindFirstChild("OpenMenu")

local ACTION = "RB7_OpenLoadout"

local function handler(_, state, _)
    if state ~= Enum.UserInputState.Begin then return end
    if OpenMenu and OpenMenu:IsA("RemoteEvent") then
        OpenMenu:FireServer("Loadout")
        print("[RB7_UI] Hotkey L -> OpenMenu('Loadout')")
    else
        warn("[RB7_UI] Hotkey: OpenMenu RemoteEvent nicht gefunden.")
    end
end

-- Taste L als Hotkey
ContextActionService:BindAction(ACTION, handler, false, Enum.KeyCode.L)
print("[RB7_UI] Hotkey 'L' zum Öffnen des Loadouts aktiv.")
