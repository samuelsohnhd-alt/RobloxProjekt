local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

local function nukeLegacy()
    local ps = plr:FindFirstChild("PlayerScripts")
    if not ps then return end
    local client = ps:FindFirstChild("Client")
    if not client then return end
    local legacy = client:FindFirstChild("RB7_UI")
    if legacy then
        legacy:Destroy()
        print("[RB7_Preboot] entfernt: Client.RB7_UI (legacy)")
    end
end

-- Früh und wiederholt prüfen
for i=1,30 do
    nukeLegacy()
    RunService.Heartbeat:Wait()
end
-- Und auf spätere Hinzufügungen horchen
local ps = plr:WaitForChild("PlayerScripts")
ps.DescendantAdded:Connect(function(d)
    if d.Name == "RB7_UI" and d.Parent and d.Parent.Name == "Client" then
        task.defer(function()
            if d.Parent and d.Parent.Name == "Client" then
                d:Destroy()
                print("[RB7_Preboot] nachträglich entfernt: Client.RB7_UI")
            end
        end)
    end
end)
