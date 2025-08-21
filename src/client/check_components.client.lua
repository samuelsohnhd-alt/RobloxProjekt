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

local function runCheck()
	local checks = {
		ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("UI") or nil,
		ReplicatedStorage:FindFirstChild("UI"),
		StarterGui,
		script.Parent,
	}
	for i, container in ipairs(checks) do
		local ok, msg = inspectComponents(container)
		if ok then
			log("DIAG-OK", msg)
			return
		else
			log("DIAG-ERR", msg)
		end
	end
	log("DIAG-INFO", "Fallback: Wenn Components als Folder vorhanden ist, muss mindestens ein ModuleScript mit dem App-Interface vorhanden sein.")
	log("DIAG-INFO", "Empfohlen: Lege ein ModuleScript namens 'Components' unter einem der Pfade an:")
	log("DIAG-INFO", "- ReplicatedStorage.Shared.UI.Components (empfohlen), oder")
	log("DIAG-INFO", "- ReplicatedStorage.UI.Components, oder")
	log("DIAG-INFO", "- StarterGui.Components (nur wenn client-seitig erwartet).")
	log("DIAG-TEST", "Teste jetzt: Starte den Client (Play/Join). Suche im Output nach 'DIAG-OK' oder 'DIAG-ERR'. Wenn 'DIAG-OK' erscheint, ist das Problem gelöst.")
end

-- Run on player added (client-side)
local player = Players.LocalPlayer
if player then
	runCheck()
else
	Players.PlayerAdded:Wait()
	runCheck()
end
