--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Events = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Constants"):WaitForChild("Events"))

local function get(path)
	local cur = ReplicatedStorage:WaitForChild("Shared"):WaitForChild(Events.ROOT):WaitForChild(Events.VERSION)
	return cur:WaitForChild(path)
end

local RF_GetState: RemoteFunction = get(Events.GET_STATE) :: any
local RE_StateChanged: RemoteEvent = get(Events.STATE_CHANGED) :: any

local pg = player:WaitForChild("PlayerGui")
local hud = pg:FindFirstChild("RB7_HUD")
local status = hud and hud:FindFirstChild("Status") :: TextLabel?

local function render(st:any)
	if not status or type(st)~="table" then return end
	local flags = {}
	if st.ads then table.insert(flags, "ADS") end
	if st.crouch then table.insert(flags, "Crouch") end
	status.Text = ("RB7 HUD bereit • %s"):format(#flags>0 and table.concat(flags, " | ") or "neutral")
end

-- Initial holen
local ok, st = pcall(function() return RF_GetState:InvokeServer() end)
if ok then render(st) end

-- Live-Änderungen
RE_StateChanged.OnClientEvent:Connect(function(payload)
	if type(payload)=="table" and payload.userId == player.UserId then
		render(payload.state)
	end
end)
