--!strict
local Theme = require(script.Parent.Parent.styles.Theme)
local function mkRow(parent: Instance, idx: number, name: string, kills: number, deaths: number, highlight: boolean?)
    local row=Instance.new("Frame"); row.Name="Row"..idx; row.Size=UDim2.new(1,0,0,22); row.BackgroundTransparency=1; row.Parent=parent
    local i=Instance.new("TextLabel"); i.Size=UDim2.new(0,22,1,0); i.BackgroundTransparency=1; i.Font=Theme.Fonts.Mono; i.TextSize=14; i.TextColor3=Theme.Colors.SubText; i.Text=tostring(idx).."."; i.Parent=row
    local n=Instance.new("TextLabel"); n.Position=UDim2.new(0,26,0,0); n.Size=UDim2.new(1,-160,1,0); n.BackgroundTransparency=1; n.Font=Theme.Fonts.Body; n.TextXAlignment=Enum.TextXAlignment.Left; n.TextSize=14; n.TextColor3=highlight and Theme.Colors.Good or Theme.Colors.Text; n.Text=name; n.Parent=row
    local k=Instance.new("TextLabel"); k.Size=UDim2.new(0,40,1,0); k.Position=UDim2.new(1,-90,0,0); k.BackgroundTransparency=1; k.Font=Theme.Fonts.Mono; k.TextSize=14; k.Text=tostring(kills); k.TextColor3=Theme.Colors.Text; k.Parent=row
    local d=Instance.new("TextLabel"); d.Size=UDim2.new(0,40,1,0); d.Position=UDim2.new(1,-40,0,0); d.BackgroundTransparency=1; d.Font=Theme.Fonts.Mono; d.TextSize=14; d.Text=tostring(deaths); d.TextColor3=Theme.Colors.Text; d.Parent=row
end
local function TeamPanel(parent, title, rows)
    local panel=Instance.new("Frame"); panel.Name=title:gsub("%s","").."Panel"; panel.BackgroundColor3=Theme.Colors.Panel; panel.BorderSizePixel=0; panel.Size=UDim2.new(0.49,-6,0,170); panel.Parent=parent
    local header=Instance.new("TextLabel"); header.Name="Header"; header.Size=UDim2.new(1,0,0,28); header.BackgroundColor3=Theme.Colors.Line; header.BorderSizePixel=0; header.Font=Theme.Fonts.Header; header.TextSize=16; header.TextColor3=Theme.Colors.Text; header.Text=title:upper(); header.Parent=panel
    local body=Instance.new("Frame"); body.Name="Body"; body.BackgroundTransparency=1; body.Position=UDim2.new(0,10,0,36); body.Size=UDim2.new(1,-20,1,-46); body.Parent=panel
    local layout=Instance.new("UIListLayout"); layout.Padding=UDim.new(0,4); layout.Parent=body
    for i,r in ipairs(rows) do mkRow(body,i,r[1],r[2],r[3],r[4]) end
    return panel
end
return TeamPanel
