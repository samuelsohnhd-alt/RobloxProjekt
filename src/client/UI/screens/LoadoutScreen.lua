local M = {}
function M.create()
    local gui = Instance.new("ScreenGui")
    gui.Name = "LoadoutScreen"
    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromScale(0.5, 0.6)
    frame.Position = UDim2.fromScale(0.25, 0.2)
    frame.BackgroundTransparency = 0.2
    frame.Name = "LoadoutFrame"
    frame.Parent = gui
    local title = Instance.new("TextLabel")
    title.Size = UDim2.fromScale(1, 0.12)
    title.BackgroundTransparency = 1
    title.Text = "Loadout"
    title.TextScaled = true
    title.TextColor3 = Color3.new(1,1,1)
    title.Parent = frame
    return gui
end
return M
