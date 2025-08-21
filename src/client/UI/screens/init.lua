local M = {}
local LobbyScreen   = require(script:WaitForChild("LobbyScreen"))
local LoadoutScreen = require(script:WaitForChild("LoadoutScreen"))
local Hud           = require(script:WaitForChild("Hud"))

local function setVisible(gui, on)
    if not gui then return end
    if gui:IsA("ScreenGui") then
        gui.Enabled = on
    else
        gui.Visible = on
    end
end

function M.boot(opts)
    opts = opts or {}
    local order = opts.displayOrder or {}
    local pg = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    local lobby = LobbyScreen.create(); lobby.DisplayOrder = order.Lobby or 50; lobby.Parent = pg
    print(("[RB7_UI] LobbyScreen created; DisplayOrder = %d"):format(lobby.DisplayOrder))

    local load  = LoadoutScreen.create(); load.DisplayOrder  = order.Loadout or 55; load.Enabled=false; load.Parent=pg
    print("[RB7_UI] LoadoutScreen created")

    local hud   = Hud.create(); hud.DisplayOrder = order.HUD or 100; hud.Parent = pg
    print("[RB7_UI] Hud created")

    -- Startzustand: Lobby + HUD sichtbar, Loadout aus
    setVisible(lobby, true)
    setVisible(hud,   true)
    setVisible(load,  false)

    -- Event-Bridge: ReplicatedStorage.Shared.Events[.v1].OpenMenu
    local RS = game:GetService("ReplicatedStorage")
    local shared = RS:FindFirstChild("Shared")
    local events = shared and shared:FindFirstChild("Events")
    local v1     = events and (events:FindFirstChild("v1") or events)
    local openMenu = v1 and v1:FindFirstChild("OpenMenu")

    if openMenu and openMenu:IsA("RemoteEvent") then
        openMenu.OnClientEvent:Connect(function(menu)
            -- menu: "Lobby" | "Loadout" | "HUD"
            local t = tostring(menu)
            setVisible(lobby,   t == "Lobby")
            setVisible(load,    t == "Loadout")
            setVisible(hud,     t == "HUD" or t == "Lobby") -- HUD bleibt in Lobby sichtbar
            print("[RB7_UI] OpenMenu ->", t)
        end)
        print("[RB7_UI] Event bridge active (OpenMenu).")
    else
        warn("[RB7_UI] OpenMenu RemoteEvent nicht gefunden (ReplicatedStorage.Shared.Events[.v1].OpenMenu)")
    end
end

return M
