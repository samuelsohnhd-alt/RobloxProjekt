-- Minimaler Client-Stub nach Cleanup
local function info(msg)
	print("[PROJECT-MINIMAL] " .. tostring(msg))
end

info("Client stub active. Spiel-Code entfernt. Verwende Git/Rojo/Launch-Agent für weiteren Aufbau.")

return nil
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

local function tryRequireModuleScript(ms)
	if not ms or not ms:IsA("ModuleScript") then
		return nil, "not a ModuleScript"
	end
	local ok, result = pcall(require, ms)
	if not ok then
		return nil, "require failed: " .. tostring(result)
	end
	if type(result) ~= "table" or type(result.mount) ~= "function" then
		return nil, "module has no mount(parent) function"
	end
	return result, "ok"
end

local function findAndUseFallback(player)
	local candidates = {}

	-- common containers to search
	local sharedUI = ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("UI")
	if sharedUI then table.insert(candidates, sharedUI) end
	local rsUI = ReplicatedStorage:FindFirstChild("UI")
	if rsUI then table.insert(candidates, rsUI) end
	if StarterGui then table.insert(candidates, StarterGui) end
	if script.Parent then table.insert(candidates, script.Parent) end

	-- also search root of ReplicatedStorage
	table.insert(candidates, ReplicatedStorage)

	for _, container in ipairs(candidates) do
		for _, name in ipairs({"Components", "DefaultApp", "DefaultApp.module"}) do
			local child = container:FindFirstChild(name)
			if child and child:IsA("ModuleScript") then
				local mod, msg = tryRequireModuleScript(child)
				if mod then
					local playerGui = player:FindFirstChild("PlayerGui") or player:WaitForChild("PlayerGui")
					local ok, res = pcall(function() return mod.mount(playerGui) end)
					if ok then
						log("DIAG-FALLBACK-USED", ("Used module %s at %s; mount ok"):format(child.Name, child:GetFullName()))
						return true
					else
						log("DIAG-ERR", ("Module %s mount failed: %s"):format(child:GetFullName(), tostring(res)))
						-- even if mount failed, we continue searching other candidates
					end
				else
					log("DIAG-ERR", ("Found %s at %s but can't use it: %s"):format(name, container:GetFullName(), msg))
				end
			end
		end
	end

	-- nothing usable found
	return false
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
		log("DIAG-INFO", "Keine gültige 'Components' ModuleScript gefunden. Versuche vorhandene Fallback-Module (DefaultApp / Components) zu nutzen...")
		local player = Players.LocalPlayer
		if not player then
			Players.PlayerAdded:Wait()
			player = Players.LocalPlayer
		end
		local used = findAndUseFallback(player)
		if used then
			log("DIAG-OK", "Fallback-Modul erfolgreich verwendet.")
			return
		end

		log("DIAG-INFO", "Kein geeignetes ModuleScript gefunden oder mount ist fehlgeschlagen.")
		log("DIAG-INFO", "Bitte erstelle manuell ein ModuleScript 'Components' unter einem dieser Pfade:")
		log("DIAG-INFO", "- ReplicatedStorage.Shared.UI.Components (empfohlen)")
		log("DIAG-INFO", "- ReplicatedStorage.UI.Components")
		log("DIAG-INFO", "- StarterGui.Components (nur wenn client-seitig erwartet)")
		log("DIAG-TEST", "Teste jetzt: Starte den Client (Play/Join). Suche im Output nach 'DIAG-OK' oder 'DIAG-ERR'.")
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
local player = Players.LocalPlayer
if player then
	runCheck()
else
	Players.PlayerAdded:Wait()
	runCheck()
end
