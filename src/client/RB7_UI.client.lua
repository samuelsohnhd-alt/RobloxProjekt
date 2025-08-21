local Players = game:GetService("Players")
local player  = Players.LocalPlayer

if _G.RB7_UI_BOOTED then
    warn("[RB7_UI] bereits geladen – überspringe.")
    return
end
_G.RB7_UI_BOOTED = true

print("[RB7_UI] Init starting…")

-- Robust: Finde UI/screens, egal wo das Script hängt
local ps = player:WaitForChild("PlayerScripts")
local root = script.Parent
if root.Name ~= "Client" then
    root = ps:FindFirstChild("Client") or ps
end

local uiFolder = root:FindFirstChild("UI") or ps:FindFirstChild("UI") or script.Parent:FindFirstChild("UI")
assert(uiFolder, "[RB7_UI] UI folder not found")
local screensMod = uiFolder:FindFirstChild("screens")
assert(screensMod, "[RB7_UI] 'screens' Module not found under UI")
local Screens = require(screensMod)

Screens.boot({
    displayOrder = { Lobby = 50, Loadout = 55, HUD = 100 }
})

print("[RB7_UI] Init done.")
