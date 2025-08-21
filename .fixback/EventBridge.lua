local RS = game:GetService("ReplicatedStorage")
local M = {}
function M.getEventsRoot()
    -- Erwartet: ReplicatedStorage.Shared.Events.v1
    local root = RS:FindFirstChild("Shared")
    if not root then
        warn("[Loadout/EventBridge] ReplicatedStorage.Shared fehlt")
        return nil
    end
    local ev = root:FindFirstChild("Events")
    if not ev then
        warn("[Loadout/EventBridge] Shared.Events fehlt")
        return nil
    end
    local v1 = ev:FindFirstChild("v1") or ev
    return v1
end
return M
