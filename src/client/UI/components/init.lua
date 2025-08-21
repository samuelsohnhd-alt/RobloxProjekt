--!strict
-- UI/Components/init.lua – kleines Komponenten-Bundle
local Components = {}

function Components.MakeLabel(props: {Name: string?, Text: string?, Size: UDim2?, Position: UDim2?})
	local l = Instance.new("TextLabel")
	l.Name = props.Name or "Label"
	l.Text = props.Text or ""
	l.Size = props.Size or UDim2.fromScale(0.3, 0.08)
	l.Position = props.Position or UDim2.new(0, 12, 0, 12)
	l.BackgroundTransparency = 0.25
	l.BackgroundColor3 = Color3.new(0,0,0)
	l.TextColor3 = Color3.new(1,1,1)
	l.TextScaled = true
	l.Font = Enum.Font.GothamMedium
	l.BorderSizePixel = 0
	return l
end

function Components.MakePanel(props: {Name: string?, Size: UDim2?, Position: UDim2?})
	local f = Instance.new("Frame")
	f.Name = props.Name or "Panel"
	f.Size = props.Size or UDim2.fromScale(0.35, 0.2)
	f.Position = props.Position or UDim2.new(0, 12, 0.1, 12)
	f.BackgroundTransparency = 0.2
	f.BackgroundColor3 = Color3.fromRGB(15,15,20)
	f.BorderSizePixel = 0
	local ui = Instance.new("UICorner"); ui.CornerRadius = UDim.new(0,10); ui.Parent = f
	local pad = Instance.new("UIPadding"); pad.PaddingLeft = UDim.new(0,10); pad.PaddingTop = UDim.new(0,8); pad.Parent = f
	return f
end

return Components
