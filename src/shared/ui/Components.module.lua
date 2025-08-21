local Components = {}

-- Erwartetes Interface:
-- Components.mount(parent: PlayerGui | GuiObject) -> ScreenGui
function Components.mount(parent)
	assert(parent, "parent required")
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "RB7_Components"
	screenGui.ResetOnSpawn = false

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0.28, 0, 0.09, 0)
	frame.Position = UDim2.new(0.01, 0, 0.01, 0)
	frame.BackgroundColor3 = Color3.fromRGB(34, 34, 36)
	frame.BorderSizePixel = 0
	frame.Parent = screenGui

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -12, 1, -12)
	label.Position = UDim2.new(0, 6, 0, 6)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(230,230,230)
	label.Text = "Components Fallback HUD"
	label.Font = Enum.Font.SourceSans
	label.TextSize = 18
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	screenGui.Parent = parent
	return screenGui
end

return Components
