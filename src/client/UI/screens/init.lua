local M = {}
local LobbyScreen   = require(script:WaitForChild("LobbyScreen"))
local LoadoutScreen = require(script:WaitForChild("LoadoutScreen"))
local Hud           = require(script:WaitForChild("Hud"))

function M.boot(opts)
    opts = opts or {}
    local order = opts.displayOrder or {}
    local CoreGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local lobbyGui = LobbyScreen.create()
    lobbyGui.DisplayOrder = order.Lobby or 50
    lobbyGui.Parent = CoreGui
    print(("[RB7_UI] LobbyScreen created; DisplayOrder = %d"):format(lobbyGui.DisplayOrder))

    local loadoutGui = LoadoutScreen.create()
    loadoutGui.DisplayOrder = order.Loadout or 55
    loadoutGui.Enabled = false
    loadoutGui.Parent = CoreGui
    print("[RB7_UI] LoadoutScreen created")

    local hudGui = Hud.create()
    hudGui.DisplayOrder = order.HUD or 100
    hudGui.Parent = CoreGui
    print("[RB7_UI] Hud created")

    local RS = game:GetService("ReplicatedStorage")
    local EventsRoot = RS:FindFirstChild("Shared") and RS.Shared:FindFirstChild("Events")
    if EventsRoot and EventsRoot:FindFirstChild("OpenMenu") then
        EventsRoot.OpenMenu.OnClientEvent:Connect(function(menu)
            lobbyGui.Enabled   = (menu == "Lobby")
            loadoutGui.Enabled = (menu == "Loadout")
            hudGui.Enabled     = (menu == "HUD")
        end)
        print("[RB7_UI] Event bridge active (OpenMenu).")
    end
end

return M
