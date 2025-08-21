--!strict
-- RB7_ClientMain: erstellt minimales HUD und sendet periodisch Ping an den Server
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Events = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Constants"):WaitForChild("Events"))

-- Resolve RemoteEvent
local Ping: RemoteEvent = ReplicatedStorage
	:WaitForChild("Shared")
	:WaitForChild(Events.ROOT)
	:WaitForChild(Events.VERSION)
	:WaitForChild(Events.PING) :: any

-- HUD konstruieren (unter StarterGui/RB7_UI gemappt; zur Laufzeit im PlayerGui)
local pg = player:WaitForChild("PlayerGui")
local existing = pg:FindFirstChild("RB7_HUD")
local hud = existing or Instance.new("ScreenGui")
hud.Name = "RB7_HUD"
hud.ResetOnSpawn = false
hud.IgnoreGuiInset = true
hud.Parent = pg

local label = hud:FindFirstChild("Status") :: TextLabel?
if not label then
	label = Instance.new("TextLabel")
	label.Name = "Status"
	label.Size = UDim2.new(0, 260, 0, 28)
	label.Position = UDim2.new(0, 12, 0, 12)
	label.BackgroundTransparency = 0.3
	label.TextWrapped = true
	label.Parent = hud
end
label.Text = "RB7 HUD bereit • Verbunden"

-- Pings senden als Lebenszeichen
task.spawn(function()
	while true do
		task.wait(5)
		label.Text = "RB7 Ping → Server …"
		local ok = pcall(function()
			Ping:FireServer({ t = os.time() })
		end)
		label.Text = ok and "RB7 Ping gesendet" or "RB7 Ping FEHLER"
	end
end)
