local TextButtonPrimary = require(script.Parent:WaitForChild("TextButtonPrimary"))
local M = {}
function M.create(tabNames, onSelect)
    local bar = Instance.new("Frame")
    bar.Name = "TabBar"
    bar.Size = UDim2.fromScale(1, 0.1)
    bar.BackgroundTransparency = 1

    local list = Instance.new("UIListLayout")
    list.FillDirection = Enum.FillDirection.Horizontal
    list.HorizontalAlignment = Enum.HorizontalAlignment.Left
    list.Padding = UDim.new(0, 8)
    list.Parent = bar

    for _,name in ipairs(tabNames) do
        local btn = TextButtonPrimary.create({ Size = UDim2.fromOffset(140, 36), Text = name })
        btn.Name = "Tab_"..name
        btn.Parent = bar
        btn.MouseButton1Click:Connect(function()
            if onSelect then onSelect(name) end
        end)
    end
    return bar
end
return M
