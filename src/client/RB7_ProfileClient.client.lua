--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Events = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Constants"):WaitForChild("Events"))

local function get(path)
	local cur = ReplicatedStorage:WaitForChild("Shared"):WaitForChild(Events.ROOT):WaitForChild(Events.VERSION)
	return cur:WaitForChild(path)
end

local RF_GetProfile: RemoteFunction = get(Events.GET_PROFILE) :: any
local RE_ProfileUpdated: RemoteEvent = get(Events.PROFILE_UPDATED) :: any

local pg = player:WaitForChild("PlayerGui")
local hud = pg:FindFirstChild("RB7_HUD")
if hud then
	local label = hud:FindFirstChild("Status") :: TextLabel?
	if label then
		local ok, prof = pcall(function() return RF_GetProfile:InvokeServer() end)
		if ok and typeof(prof)=="table" then
			label.Text = string.format("RB7 HUD bereit • %s (XP %d)", prof.name or "?", prof.xp or 0)
		end
		RE_ProfileUpdated.OnClientEvent:Connect(function(pf)
			if typeof(pf)=="table" then
				label.Text = string.format("RB7 HUD bereit • %s (XP %d)", pf.name or "?", pf.xp or 0)
			end
		end)
	end
end
