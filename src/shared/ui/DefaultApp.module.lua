-- Minimaler Fallback-App-Module für UI-Mount (Client-seitig).
local DefaultApp = {}

-- Erwartetes Interface:
-- DefaultApp.mount(parent: PlayerGui | GuiObject) -> ScreenGui
function DefaultApp.mount(parent)
	assert(parent, "parent required")
	-- Erstelle ein minimales ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "RB7_DefaultApp"
	screenGui.ResetOnSpawn = false

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0.25, 0, 0.1, 0)
	frame.Position = UDim2.new(0.01, 0, 0.01, 0)
	frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
	frame.Parent = screenGui

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -8, 1, -8)
	label.Position = UDim2.new(0, 4, 0, 4)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255,255,255)
	label.Text = "Default HUD (Fallback)"
	label.Parent = frame

	screenGui.Parent = parent
	return screenGui
end

return DefaultApp
