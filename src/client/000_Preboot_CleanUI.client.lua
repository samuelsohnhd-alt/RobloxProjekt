--!strict
-- Sicherer Preboot: entfernt NUR echte Legacy-Knoten.
-- WICHTIG: "Client/UI" und alles darunter wird NIE gelöscht.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer
local ps  = plr:WaitForChild("PlayerScripts")
local client = ps:FindFirstChild("Client")

local function isOurUI(inst: Instance): boolean
	-- Bewahre den offiziellen UI-Pfad
	return client ~= nil and inst:IsDescendantOf(client:FindFirstChild("UI") or client)
end

local LEGACY_NAMES = {
	["RB7_UI"] = true,    -- alte UI-Struktur
	["Client"] = false,   -- nur wenn es ein verschachteltes Duplikat wäre (selten)
}

local function shouldNukeTop(child: Instance): boolean
	if child.Name == "RB7_UI" then return true end
	-- NIEMALS den UI-Ordner selbst löschen
	if child.Name == "UI" then return false end
	-- Keine aggressiven Matches mehr
	return false
end

local function sweep()
	if not client then return end
	for _,child in ipairs(client:GetChildren()) do
		if shouldNukeTop(child) and not isOurUI(child) then
			child:Destroy()
			print(("[RB7_Preboot] entfernt: %s"):format(child.Name))
		end
	end
end

-- Einmal sauber laufen reicht
sweep()
print("[RB7_Preboot] ✅ Safe-Clean (UI bleibt unangetastet).")
