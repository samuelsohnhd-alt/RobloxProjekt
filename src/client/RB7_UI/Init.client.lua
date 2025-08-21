--!strict
print("[RB7_UI] Init starting…")
local LobbyScreen = require(script.Parent.screens.LobbyScreen)
local Loadout = require(script.Parent.screens.LoadoutScreen)

local lobby = LobbyScreen()
lobby.Enabled = true
print("[RB7_UI] LobbyScreen created; DisplayOrder =", lobby.DisplayOrder)

local loadoutGui = (select(1, Loadout()))
loadoutGui.Enabled = false
print("[RB7_UI] LoadoutScreen created")

for _,d in ipairs(lobby:GetDescendants()) do
    if d:IsA("TextButton") and d.Text == "LOADOUT" then
        d.MouseButton1Click:Connect(function()
            print("[RB7_UI] LOADOUT clicked")
            lobby.Enabled = false
            loadoutGui.Enabled = true
        end)
    end
end
print("[RB7_UI] Init done.")
