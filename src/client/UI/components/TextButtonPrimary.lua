local M = {}
function M.create(props)
    props = props or {}
    local b = Instance.new("TextButton")
    b.AutoButtonColor = true
    b.BackgroundTransparency = 0.1
    b.Size = props.Size or UDim2.fromOffset(160, 40)
    b.Text = props.Text or "Button"
    b.TextScaled = true
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = b
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = b
    return b
end
return M
