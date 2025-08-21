--!strict
-- Läuft so früh wie möglich: Entfernt alte/fehlplatzierte UI-Skripte,
-- die unter PlayerScripts/Client/UI liegen und unsere neue Struktur stören.
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer
local ps  = plr:WaitForChild("PlayerScripts")
local client = ps:FindFirstChild("Client")

local function isSrcUI(inst: Instance): boolean
	-- Unsere gewünschte Struktur: Client/src/client/UI/...
	-- Also darf nur dieser Pfad bleiben.
	if not client then return false end
	local src = client:FindFirstChild("src/client")
	if not src then return false end
	local ui = src:FindFirstChild("UI")
	return ui ~= nil and inst:IsDescendantOf(ui)
end

local function shouldNuke(inst: Instance): boolean
	-- Falsch einsortierte UI-Knoten: direkt unter Client: UI, RB7_UI, screens, App, components etc.
	if not client then return false end
	if isSrcUI(inst) then return false end
	local badNames = {
		UI = true, RB7_UI = true, screens = true, App = true, components = true,
		["RB7_UI.stub"] = true, ["UI.stub"] = true
	}
	return badNames[inst.Name] == true
end

local function nuke(inst: Instance)
	if shouldNuke(inst) then
		inst:Destroy()
		print(("[RB7_Preboot] entfernt: %s"):format(inst.Name))
	end
end

local function sweep()
	if not client then return end
	for _,child in ipairs(client:GetChildren()) do
		nuke(child)
		-- auch tiefer schauen: falls es doch Unterordner UI gibt
		for _,g in ipairs(child:GetChildren()) do
			nuke(g)
		end
	end
end

-- Früher Mehrfachlauf, um Rennbedingungen zu vermeiden
for i = 1, 30 do
	sweep()
	RunService.Heartbeat:Wait()
end

-- Wachhund für spätes Nachladen
if client then
	client.ChildAdded:Connect(function(c) nuke(c) end)
	client.DescendantAdded:Connect(function(d) nuke(d) end)
end

print("[RB7_Preboot] ✅ Legacy-UI gesäubert")
