--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Events = ReplicatedStorage:WaitForChild("Events")
local v1 = Events:WaitForChild("v1")
local RequestReadyToggle = v1:WaitForChild("RequestReadyToggle")
local PlayerReadyChanged = v1:WaitForChild("PlayerReadyChanged")
local RoundStateChanged = v1:WaitForChild("RoundStateChanged")
local GetRoundState = v1:WaitForChild("GetRoundState")

-- Taste R toggelt Ready (nur zum Testen)
game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.R then
		RequestReadyToggle:FireServer()
	end
end)

PlayerReadyChanged.OnClientEvent:Connect(function(userId: number, isReady: boolean)
	print(("[ReadyDebug] uid=%d ready=%s"):format(userId, tostring(isReady)))
end)

RoundStateChanged.OnClientEvent:Connect(function(state: string)
	print(("[RoundState] %s"):format(state))
end)

local ok, state = pcall(function()
	return GetRoundState:InvokeServer()
end)
if ok then print("[RoundState] initial:", state) end
