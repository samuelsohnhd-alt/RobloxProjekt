--!strict
local LobbyScreen = require(script.Parent.screens.LobbyScreen)
local Loadout = require(script.Parent.screens.LoadoutScreen)

local lobby = LobbyScreen()
local loadoutGui = (select(1, Loadout()))

for _,desc in ipairs(lobby:GetDescendants()) do
    if desc:IsA("TextButton") and desc.Text == "LOADOUT" then
        desc.MouseButton1Click:Connect(function()
            lobby.Enabled = false
            loadoutGui.Enabled = true
        end)
    end
end
