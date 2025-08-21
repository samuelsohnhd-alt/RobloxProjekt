--!strict
-- Robuste App: lädt Components/init.lua sicher und mountet HUD
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local pg = Players.LocalPlayer:WaitForChild("PlayerGui")

local function getComponentsModule(): ModuleScript?
	local uiFolder = script.Parent
	local compFolder = uiFolder:FindFirstChild("Components") or uiFolder:WaitForChild("Components", 5)
	if not compFolder then
		warn("[UI/App] ❌ Components-Ordner nicht gefunden.")
		return nil
	end
	local mod = compFolder:FindFirstChild("init") or compFolder:FindFirstChildWhichIsA("ModuleScript")
	if not mod then
		warn("[UI/App] ❌ Components ModuleScript (init.lua) fehlt.")
		return nil
	end
	return mod :: ModuleScript
end

local ComponentsModule = getComponentsModule()
local Components = ComponentsModule and require(ComponentsModule) or nil

local v1 = ReplicatedStorage:WaitForChild("Events"):WaitForChild("v1")
local RoundTimeUpdated = v1:WaitForChild("RoundTimeUpdated")
local RoundStateChanged = v1:WaitForChild("RoundStateChanged")

local App = {}
local gui: ScreenGui? = nil
local timeLabel: TextLabel? = nil
local stateLabel: TextLabel? = nil

function App.mount()
	if gui then return gui end
	if not Components then
		warn("[UI/App] ⚠️ Components nicht geladen – HUD wird nicht gemountet.")
		return nil
	end

	gui = Instance.new("ScreenGui")
	gui.IgnoreGuiInset = true
	gui.Name = "RB7_HUD"
	gui.ResetOnSpawn = false
	gui.Parent = pg

	local panel = Components.MakePanel({Name="HUDPanel", Size=UDim2.fromScale(0.26,0.14), Position=UDim2.new(0,12,0,12)})
	panel.Parent = gui

	stateLabel = Components.MakeLabel({Name="State", Text="State: —", Size=UDim2.fromScale(1,0.45), Position=UDim2.new(0,0,0,0)})
	stateLabel.Parent = panel

	timeLabel = Components.MakeLabel({Name="Timer", Text="Time: —", Size=UDim2.fromScale(1,0.45), Position=UDim2.new(0,0,0.5,0)})
	timeLabel.Parent = panel

	RoundTimeUpdated.OnClientEvent:Connect(function(remaining: number)
		if timeLabel then timeLabel.Text = ("Time: %ds"):format(tonumber(remaining) or -1) end
	end)
	RoundStateChanged.OnClientEvent:Connect(function(state: string)
		if stateLabel then stateLabel.Text = ("State: %s"):format(tostring(state)) end
	end)

	print("[RB7_UI/App] ✅ mounted")
	return gui
end

return App
