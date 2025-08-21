--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage:WaitForChild("Events")
local v1     = Events:WaitForChild("v1")
local UnlocksChanged = v1:WaitForChild("UnlocksChanged")

UnlocksChanged.OnClientEvent:Connect(function(key, value)
	print(("[UnlocksDebug] %s = %s"):format(tostring(key), tostring(value)))
end)
