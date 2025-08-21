local M = {}
function M.create()
    local gui = Instance.new("ScreenGui")
    gui.Name = "HUD"
    local ammo = Instance.new("TextLabel")
    ammo.Name = "Ammo"
    ammo.Size = UDim2.fromScale(0.18, 0.08)
    ammo.Position = UDim2.fromScale(0.80, 0.90)
    ammo.BackgroundTransparency = 1
    ammo.TextScaled = true
    ammo.Text = "Ammo: 30/90"
    ammo.TextColor3 = Color3.new(1,1,1)
    ammo.Parent = gui
    local xp = Instance.new("TextLabel")
    xp.Name = "XP"
    xp.Size = UDim2.fromScale(0.18, 0.08)
    xp.Position = UDim2.fromScale(0.02, 0.90)
    xp.BackgroundTransparency = 1
    xp.TextScaled = true
    xp.Text = "XP: 0"
    xp.TextColor3 = Color3.new(1,1,1)
    xp.Parent = gui
    return gui
end
return M
