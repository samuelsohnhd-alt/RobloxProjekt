local Players = game:GetService("Players")
local pg = Players.LocalPlayer:WaitForChild("PlayerGui")

local M = {
    _screens = {}, -- name -> ScreenGui
}

function M.register(name, gui)
    M._screens[name] = gui
end

function M.show(name)
    for n, gui in pairs(M._screens) do
        if gui and gui.Parent then
            if gui:IsA("ScreenGui") then
                gui.Enabled = (n == name) or (n == "HUD" and (name == "HUD" or name == "Lobby"))
            else
                gui.Visible = (n == name)
            end
        end
    end
    print("[UIState] show ->", name)
end

return M
