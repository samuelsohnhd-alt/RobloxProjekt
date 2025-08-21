--!strict
local Players = game:GetService("Players")
local Theme = require(script.Parent.Parent.styles.Theme)

local function LoadoutScreen()
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "RB7_Loadout"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Enabled = false
    gui.Parent = playerGui

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = Theme.Colors.Bg
    bg.BorderSizePixel = 0
    bg.Parent = gui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,50)
    title.BackgroundTransparency = 1
    title.Font = Theme.Fonts.Header
    title.TextSize = 24
    title.TextColor3 = Theme.Colors.Text
    title.Text = "LOADOUT"
    title.Parent = bg

    local weaponsBtn = Instance.new("TextButton")
    weaponsBtn.Size = UDim2.new(0,220,0,40)
    weaponsBtn.Position = UDim2.new(0,50,0,90)
    weaponsBtn.Text = "Weapons"
    weaponsBtn.BackgroundColor3 = Theme.Colors.AccentDim
    weaponsBtn.TextColor3 = Theme.Colors.Text
    weaponsBtn.Parent = bg

    local gearBtn = Instance.new("TextButton")
    gearBtn.Size = UDim2.new(0,220,0,40)
    gearBtn.Position = UDim2.new(0,50,0,140)
    gearBtn.Text = "Gear (Head/Arm/Shoulder/Chest/Leg/Clothes)"
    gearBtn.BackgroundColor3 = Theme.Colors.AccentDim
    gearBtn.TextColor3 = Theme.Colors.Text
    gearBtn.Parent = bg

    return gui, {Weapons = weaponsBtn, Gear = gearBtn}
end

return LoadoutScreen
