local Players = game:GetService("Players")
print("[RB7_UI] Init starting…")
local Screens = require(script.Parent:WaitForChild("UI"):WaitForChild("screens"))
Screens.boot({
    displayOrder = { Lobby = 50, Loadout = 55, HUD = 100 }
})
print("[RB7_UI] Init done.")
