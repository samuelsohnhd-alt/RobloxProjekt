--!strict
-- RB7_RoundHud: Zeigt Runden-Timer an und reagiert auf Start/Ende
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Events = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Constants"):WaitForChild("Events"))

local function getEvent(name: string): RemoteEvent
	return (ReplicatedStorage
		:WaitForChild("Shared")
		:WaitForChild(Events.ROOT)
		:WaitForChild(Events.VERSION)
		:WaitForChild(name)) :: any
end

local E_RoundStart: RemoteEvent = getEvent(Events.ROUND_START)
local E_RoundEnded: RemoteEvent = getEvent(Events.ROUND_ENDED)
local E_TimerTick : RemoteEvent = getEvent(Events.TIMER_TICK)

-- HUD vorbereiten / wiederverwenden
local pg = player:WaitForChild("PlayerGui")
local hud = pg:FindFirstChild("RB7_HUD") or Instance.new("ScreenGui")
hud.Name = "RB7_HUD"
hud.ResetOnSpawn = false
hud.IgnoreGuiInset = true
hud.Parent = pg

local timerLabel = hud:FindFirstChild("Timer") :: TextLabel?
if not timerLabel then
	timerLabel = Instance.new("TextLabel")
	timerLabel.Name = "Timer"
	timerLabel.Size = UDim2.new(0, 140, 0, 28)
	timerLabel.Position = UDim2.new(0, 12, 0, 44)
	timerLabel.BackgroundTransparency = 0.3
	timerLabel.Text = "⏳ --:--"
	timerLabel.Parent = hud
end

local statusLabel = hud:FindFirstChild("Status") :: TextLabel?
if not statusLabel then
	statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "Status"
	statusLabel.Size = UDim2.new(0, 260, 0, 28)
	statusLabel.Position = UDim2.new(0, 12, 0, 12)
	statusLabel.BackgroundTransparency = 0.3
	statusLabel.TextWrapped = true
	statusLabel.Text = "RB7 HUD bereit"
	statusLabel.Parent = hud
end

local function fmt(sec: number): string
	sec = math.max(0, math.floor(sec))
	local m = math.floor(sec/60)
	local s = sec % 60
	return string.format("%02d:%02d", m, s)
end

E_RoundStart.OnClientEvent:Connect(function(payload)
	statusLabel.Text = "▶ Runde gestartet"
	if typeof(payload) == "table" and payload.duration then
		timerLabel.Text = "⏳ " .. fmt(payload.duration)
	end
end)

E_RoundEnded.OnClientEvent:Connect(function(payload)
	statusLabel.Text = "⏹ Runde beendet"
end)

E_TimerTick.OnClientEvent:Connect(function(payload)
	if typeof(payload) == "table" and payload.t then
		timerLabel.Text = "⏳ " .. fmt(payload.t)
	end
end)
