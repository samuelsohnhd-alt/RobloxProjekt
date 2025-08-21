-- Minimaler Components-Fallback (sauber, keine Spiel-Logik)
local Components = {}

-- Erwartetes API: Components.mount(parent) — hier No-Op / sicherer Rückgabewert.
function Components.mount(parent)
	-- No operation in minimal project state.
	return nil
end

return Components
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

return Components
-- so dass Code, der explizit nach "Components" sucht, besser funktioniert.
pcall(function()
	if typeof(script) == "Instance" and script.Name ~= "Components" then
		script.Name = "Components"
	end
end)

return Components
