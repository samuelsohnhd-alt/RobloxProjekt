local Players = game:GetService("Players")
local player  = Players.LocalPlayer

-- Doppelstart-Schutz (gemeinsamer Guard für alle UI-Entrypoints)
if _G.RB7_UI_BOOTED then
    warn("[RB7_UI Stub] bereits geladen – überspringe.")
    return
end
_G.RB7_UI_BOOTED = true

print("[RB7_UI Stub] delegiere auf UI/screens …")

-- Unabhängig vom Ort: greife immer auf PlayerScripts/UI/screens zu
local ps = player:WaitForChild("PlayerScripts")
local ui = ps:WaitForChild("UI")
local screensMod = ui:WaitForChild("screens")
local Screens = require(screensMod)

Screens.boot({
    displayOrder = { Lobby = 50, Loadout = 55, HUD = 100 }
})

print("[RB7_UI Stub] done.")
