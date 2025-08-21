local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local function log(level, msg)
	print(string.format("[%s] %s", level, msg))
end

local function inspectComponents(container)
	if not container then
		return nil, "not found"
	end
	local child = container:FindFirstChild("Components")
	if not child then
		return nil, "Components not found in container (" .. container:GetFullName() .. ")"
	end
	if child:IsA("ModuleScript") then
		return true, "Components is a ModuleScript at " .. child:GetFullName()
	end
	if child:IsA("Folder") then
		-- check if folder contains any ModuleScripts
		for _, v in ipairs(child:GetChildren()) do
			if v:IsA("ModuleScript") then
				return true, "Components is a Folder containing ModuleScripts at " .. child:GetFullName()
			end
		end
		return nil, "Components is a Folder but contains no ModuleScript (invalid for require) at " .. child:GetFullName()
	end
	return nil, "Components exists but is neither ModuleScript nor Folder (type=" .. child.ClassName .. ") at " .. child:GetFullName()
end

local function createFallbackModule(targetParent)
	if not targetParent then return nil, "no target" end
	-- create ModuleScript with minimal mount() implementation
	local source = [[
local Components = {}
function Components.mount(parent)
	assert(parent, "parent required")
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
]]
	local ms = Instance.new("ModuleScript")
	ms.Name = "Components"
	-- Source is writable in Studio/runtime for ModuleScripts created at runtime
	ms.Source = source
	ms.Parent = targetParent
	return ms, "created"
end

local function runCheck()
	local checks = {
		ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("UI") or nil,
		ReplicatedStorage:FindFirstChild("UI"),
		StarterGui,
		script.Parent,
	}
	local found = false
	for i, container in ipairs(checks) do
		local ok, msg = inspectComponents(container)
		if ok then
			log("DIAG-OK", msg)
			found = true
			break
		else
			log("DIAG-ERR", msg)
		end
	end

	if not found then
		-- attempt to create fallback under best-effort paths
		local target = ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("UI") or ReplicatedStorage:FindFirstChild("UI")
		if not target and ReplicatedStorage:FindFirstChild("Shared") then
			-- ensure Shared.UI exists
			local shared = ReplicatedStorage:FindFirstChild("Shared")
			local ui = Instance.new("Folder")
			ui.Name = "UI"
			ui.Parent = shared
			target = ui
		elseif not target and not ReplicatedStorage:FindFirstChild("Shared") and not ReplicatedStorage:FindFirstChild("UI") then
			-- create Shared->UI for fallback
			local shared = Instance.new("Folder")
			shared.Name = "Shared"
			shared.Parent = ReplicatedStorage
			local ui = Instance.new("Folder")
			ui.Name = "UI"
			ui.Parent = shared
			target = ui
		end

		if target then
			local ms, status = createFallbackModule(target)
			if ms then
				log("DIAG-FALLBACK", "Components ModuleScript created at " .. ms:GetFullName())
			else
				log("DIAG-ERR", "Fallback creation failed: " .. tostring(status))
			end
		else
			log("DIAG-ERR", "Kein geeigneter Zielpfad für Fallback gefunden (ReplicatedStorage.Shared.UI / ReplicatedStorage.UI)")
		end

		log("DIAG-INFO", "Fallback: Wenn Components als Folder vorhanden ist, muss mindestens ein ModuleScript mit dem App-Interface vorhanden sein.")
		log("DIAG-INFO", "Empfohlen: Lege ein ModuleScript namens 'Components' unter einem der Pfade an:")
		log("DIAG-INFO", "- ReplicatedStorage.Shared.UI.Components (empfohlen), oder")
		log("DIAG-INFO", "- ReplicatedStorage.UI.Components, oder")
		log("DIAG-INFO", "- StarterGui.Components (nur wenn client-seitig erwartet).")
		log("DIAG-TEST", "Teste jetzt: Starte den Client (Play/Join). Suche im Output nach 'DIAG-OK' oder 'DIAG-FALLBACK'. Wenn 'DIAG-OK' erscheint, ist das Problem gelöst. Wenn 'DIAG-FALLBACK' erscheint, überprüfe, ob das HUD sichtbar ist.")
	end
end

-- Run on player added (client-side)
local player = Players.LocalPlayer
if player then
	runCheck()
else
	Players.PlayerAdded:Wait()
	runCheck()
end
