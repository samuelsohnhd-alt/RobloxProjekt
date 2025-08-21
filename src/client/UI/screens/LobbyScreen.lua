local M = {}
function M.create()
    local gui = Instance.new("ScreenGui")
    gui.Name = "LobbyScreen"
    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(0.3, 0.08)
    label.Position = UDim2.fromScale(0.02, 0.03)
    label.TextScaled = true
    label.Text = "RB7 • Lobby"
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Parent = gui
    return gui
end
return M
