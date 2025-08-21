local UIState        = require(script.Parent.Parent.Components.UIState)
local LobbyScreen    = require(script:WaitForChild("LobbyScreen"))
local LoadoutScreen  = require(script:WaitForChild("LoadoutScreen"))
local Hud            = require(script:WaitForChild("Hud"))

local M = {}

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

    -- Screens registrieren
    UIState.register("Lobby", lobby)
    UIState.register("Loadout", load)
    UIState.register("HUD", hud)

    -- Startzustand: Lobby + HUD sichtbar
    lobby.Enabled = true
    hud.Enabled   = true
    load.Enabled  = false
end

return M
