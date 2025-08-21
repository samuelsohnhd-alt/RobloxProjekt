-- RB7 HUD Timer (client)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local plr = Players.LocalPlayer
local PlayerGui = plr:WaitForChild("PlayerGui")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Events = Shared:WaitForChild("Events")
local V1     = Events:WaitForChild("v1")
local RoundTimerTick = V1:WaitForChild("RoundTimerTick")

local hud = PlayerGui:FindFirstChild("RB7_HUD") or Instance.new("ScreenGui")
hud.Name = "RB7_HUD"
hud.ResetOnSpawn = false
hud.IgnoreGuiInset = true
hud.DisplayOrder = 100
hud.Parent = PlayerGui

local label = hud:FindFirstChild("TimerLabel")
if not label then
    label = Instance.new("TextLabel")
    label.Name = "TimerLabel"
    label.Size = UDim2.fromOffset(180, 44)
    label.AnchorPoint = Vector2.new(0.5, 0)
    label.Position = UDim2.new(0.5, 0, 0, 18)
    label.BackgroundTransparency = 0.25
    label.BackgroundColor3 = Color3.fromRGB(10,10,10)
    label.BorderSizePixel = 0
    label.Font = Enum.Font.GothamBold
    label.TextSize = 28
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextStrokeTransparency = 0.5
    label.Text = "05:00"
    label.Parent = hud
end

local function fmt(seconds:number): string
    seconds = math.max(-1, math.floor(seconds))
    if seconds < 0 then return "00:00" end
    local m = math.floor(seconds / 60)
    local s = seconds % 60
    return string.format("%02d:%02d", m, s)
end

RoundTimerTick.OnClientEvent:Connect(function(remaining)
    label.Text = fmt(remaining)
end)

print("[RB7_HUD Timer] ✅ aktiv (RoundTimerTick)")
