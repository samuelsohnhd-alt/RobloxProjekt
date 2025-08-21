--!strict
local LobbyScreen = require(script.Parent.screens.LobbyScreen)
local Loadout = require(script.Parent.screens.LoadoutScreen)

local lobby = LobbyScreen()
local loadoutGui, _ = Loadout()

-- Navigation: Klick auf "LOADOUT" öffnet den Loadout-Screen
for _,desc in ipairs(lobby:GetDescendants()) do
    if desc:IsA("TextButton") and desc.Text == "LOADOUT" then
        desc.MouseButton1Click:Connect(function()
            lobby.Enabled = false
            loadoutGui.Enabled = true
        end)
    end
end
