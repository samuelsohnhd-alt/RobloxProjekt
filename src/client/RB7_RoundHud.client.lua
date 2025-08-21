--!strict
-- RB7_RoundHud: Zeigt Runden-Timer an und reagiert auf Start/Ende (mit Theme)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Events = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Constants"):WaitForChild("Events"))
local Theme  = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Config"):WaitForChild("UITheme"))

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

local pg = player:WaitForChild("PlayerGui")
local hud = pg:FindFirstChild("RB7_HUD") or Instance.new("ScreenGui")
hud.Name = "RB7_HUD"
hud.ResetOnSpawn = false
hud.IgnoreGuiInset = true
hud.Parent = pg

local function styleLabel(lb: TextLabel, w: number, y: number)
	lb.Size = UDim2.new(0, w, 0, 28)
	lb.Position = UDim2.new(0, 12, 0, y)
	lb.BackgroundColor3 = Theme.Color.PanelBg
	lb.BackgroundTransparency = 0.3
	lb.BorderSizePixel = 0
	lb.FontFace = Font.new(Theme.Font.Family, Enum.FontWeight.SemiBold)
	lb.TextColor3 = Theme.Color.Text
end

local statusLabel = hud:FindFirstChild("Status") :: TextLabel?
if not statusLabel then
	statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "Status"
	statusLabel.TextWrapped = true
	statusLabel.Parent = hud
end
styleLabel(statusLabel, 260, 12)
statusLabel.Text = "RB7 HUD bereit"

local timerLabel = hud:FindFirstChild("Timer") :: TextLabel?
if not timerLabel then
	timerLabel = Instance.new("TextLabel")
	timerLabel.Name = "Timer"
	timerLabel.Parent = hud
end
styleLabel(timerLabel, 140, 44)
timerLabel.Text = "⏳ --:--"

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
