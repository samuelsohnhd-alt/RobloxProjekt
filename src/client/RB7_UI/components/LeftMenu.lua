--!strict
local Theme = require(script.Parent.Parent.styles.Theme)
local LeftMenu = {}; LeftMenu.__index = LeftMenu
function LeftMenu.new(parent: Instance, items: {string})
    local f = Instance.new("Frame"); f.Name="LeftMenu"
    f.Size = UDim2.new(0,260,1,0); f.BackgroundColor3=Theme.Colors.Panel; f.BorderSizePixel=0; f.Parent=parent
    local header = Instance.new("TextLabel"); header.Name="Header"; header.Size=UDim2.new(1,0,0,40)
    header.BackgroundTransparency=1; header.Font=Theme.Fonts.Header; header.TextSize=18; header.TextXAlignment=Enum.TextXAlignment.Left
    header.TextColor3=Theme.Colors.Text; header.Text="GAME LOBBY"; header.Position=UDim2.new(0,12,0,6); header.Parent=f
    local listHolder = Instance.new("Frame"); listHolder.Name="List"; listHolder.BackgroundTransparency=1; listHolder.Size=UDim2.new(1,-20,1,-70)
    listHolder.Position=UDim2.new(0,10,0,50); listHolder.Parent=f
    local layout = Instance.new("UIListLayout"); layout.Padding=UDim.new(0,6); layout.SortOrder=Enum.SortOrder.LayoutOrder; layout.Parent=listHolder
    local buttons = {}
    for _,name in ipairs(items) do
        local b = Instance.new("TextButton"); b.Name=(name:gsub("%s","")); b.Size=UDim2.new(1,0,0,28)
        b.BackgroundColor3=Theme.Colors.AccentDim; b.BorderSizePixel=0; b.AutoButtonColor=false
        b.Font=Theme.Fonts.Body; b.TextSize=16; b.TextXAlignment=Enum.TextXAlignment.Left; b.TextColor3=Theme.Colors.Text; b.Text=name; b.Parent=listHolder
        local line = Instance.new("Frame"); line.Size=UDim2.new(1,0,0,1); line.BackgroundColor3=Theme.Colors.Line; line.BorderSizePixel=0; line.Position=UDim2.new(0,0,1,0); line.Parent=b
        b.MouseEnter:Connect(function() b.BackgroundColor3=Theme.Colors.Accent end)
        b.MouseLeave:Connect(function() b.BackgroundColor3=Theme.Colors.AccentDim end)
        table.insert(buttons,b)
    end
    return setmetatable({ Frame=f; Items=buttons; }, LeftMenu)
end
return LeftMenu
