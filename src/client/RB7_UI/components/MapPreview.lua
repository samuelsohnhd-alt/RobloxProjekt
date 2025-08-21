--!strict
local Theme = require(script.Parent.Parent.styles.Theme)
local function MapPreview(parent: Instance)
    local frame=Instance.new("Frame"); frame.Name="MapPreview"; frame.Size=UDim2.new(0,260,0,160); frame.BackgroundColor3=Theme.Colors.Panel; frame.BorderSizePixel=0; frame.Parent=parent
    local img=Instance.new("ImageLabel"); img.Name="Image"; img.Size=UDim2.new(1,-12,1,-12); img.Position=UDim2.new(0,6,0,6); img.BackgroundTransparency=1; img.ScaleType=Enum.ScaleType.Crop; img.Image="rbxassetid://1234567890"; img.Parent=frame
    local caption=Instance.new("TextLabel"); caption.Name="Caption"; caption.BackgroundTransparency=1; caption.Size=UDim2.new(1,-12,0,18); caption.Position=UDim2.new(0,6,1,-22); caption.Font=Theme.Fonts.Body; caption.TextXAlignment=Enum.TextXAlignment.Left; caption.TextSize=14; caption.TextColor3=Theme.Colors.Text; caption.Text="TOTAL CONQUEST  •  COB TRAINING"; caption.Parent=frame
    return frame
end
return MapPreview
