local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage
    :WaitForChild("Shared")
    :WaitForChild("Events")
    :WaitForChild("v1")

local M = {}

function M.init()
    local OpenMenu = Events:FindFirstChild("OpenMenu")
    if OpenMenu and OpenMenu:IsA("RemoteEvent") then
        print("[RB7_UI] OpenMenu RemoteEvent ✅ vorhanden")
    else
        warn("[RB7_UI] OpenMenu RemoteEvent fehlt")
    end
end

return M
