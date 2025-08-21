local UIState = require(script.Parent.Parent.Components.UIState)
local Button = require(script.Parent.Parent.Components.TextButtonPrimary)

local M = {}
function M.create()
    local gui = Instance.new("ScreenGui")
    gui.Name = "HUD"

    -- Ammo
    local ammo = Instance.new("TextLabel")
    ammo.Name = "Ammo"; ammo.Size = UDim2.fromScale(0.18, 0.08); ammo.Position = UDim2.fromScale(0.80, 0.90)
    ammo.BackgroundTransparency = 1; ammo.TextScaled = true; ammo.Text = "Ammo: 30/90"; ammo.TextColor3 = Color3.new(1,1,1)
    ammo.Parent = gui

    -- XP
    local xp = Instance.new("TextLabel")
    xp.Name = "XP"; xp.Size = UDim2.fromScale(0.18, 0.08); xp.Position = UDim2.fromScale(0.02, 0.90)
    xp.BackgroundTransparency = 1; xp.TextScaled = true; xp.Text = "XP: 0"; xp.TextColor3 = Color3.new(1,1,1)
    xp.Parent = gui

    -- Menu-Button
    local menuBtn = Button.create({ Name = "MenuButton", Text = "Menu", Size = UDim2.fromOffset(120, 36) })
    menuBtn.AnchorPoint = Vector2.new(1,0)
    menuBtn.Position = UDim2.fromScale(0.985, 0.02)
    menuBtn.Parent = gui
    menuBtn.MouseButton1Click:Connect(function()
        UIState.show("Lobby")
    end)

    return gui
end
return M
