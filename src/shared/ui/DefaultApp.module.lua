-- Minimaler Components-Fallback (sauber, keine Spiel-Logik)
local Components = {}

-- Erwartetes API: Components.mount(parent) — hier No-Op / sicherer Rückgabewert.
function Components.mount(parent)
	-- No operation in minimal project state.
	return nil
end

return Components
-- so dass Code, der explizit nach "Components" sucht, besser funktioniert.
pcall(function()
	if typeof(script) == "Instance" and script.Name ~= "Components" then
		script.Name = "Components"
	end
end)

return Components
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
