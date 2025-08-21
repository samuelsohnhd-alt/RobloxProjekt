local Components = {}

-- Erwartetes Interface: require(Components).mount(playerGui)
function Components.mount(parent)
	assert(parent, "parent required for Components.mount")
	-- Einfaches ScreenGui als Fallback-HUD
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "RB7_FallbackComponents"
	screenGui.ResetOnSpawn = false

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0.25, 0, 0.08, 0)
	frame.Position = UDim2.new(0.01, 0, 0.01, 0)
	frame.BackgroundColor3 = Color3.fromRGB(28, 28, 30)
	frame.BorderSizePixel = 0
	frame.Parent = screenGui

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -8, 1, -8)
	label.Position = UDim2.new(0, 4, 0, 4)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(220,220,220)
	label.Text = "Fallback HUD (Components)"
	label.Font = Enum.Font.SourceSans
	label.TextSize = 18
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame

	screenGui.Parent = parent
	return screenGui
end

return Components
