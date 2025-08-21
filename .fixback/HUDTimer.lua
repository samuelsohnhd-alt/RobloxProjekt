local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage
    :WaitForChild("Shared")
    :WaitForChild("Events")
    :WaitForChild("v1")

local M = {}

function M.mount(player)
    local RoundTimerTick = Events:FindFirstChild("RoundTimerTick")
    if not RoundTimerTick or not RoundTimerTick:IsA("RemoteEvent") then
        warn("[RB7_HUD Timer] RoundTimerTick nicht gefunden")
        return
    end
    RoundTimerTick.OnClientEvent:Connect(function(t)
        -- hier könnte UI aktualisiert werden
        -- print(("[RB7_HUD Timer] t=%s"):format(t))
    end)
    print("[RB7_HUD Timer] ✅ aktiv (RoundTimerTick)")
end

return M
