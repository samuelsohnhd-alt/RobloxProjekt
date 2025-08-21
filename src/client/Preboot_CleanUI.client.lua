-- RB7 Preboot-CleanUI (client): Entfernt Legacy-LocalScripts "RB7_UI" aggressiv
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

local function nukeRB7UI(root)
    if not root then return end
    for _,d in ipairs(root:GetDescendants()) do
        if d:IsA("LocalScript") and d.Name == "RB7_UI" then
            d.Disabled = true
            d:Destroy()
            warn("[RB7_Preboot] entfernt: " .. d:GetFullName())
        end
    end
end

local function sweep()
    local ps = plr:FindFirstChild("PlayerScripts")
    if ps then
        nukeRB7UI(ps)
        for _,c in ipairs(ps:GetChildren()) do nukeRB7UI(c) end
    end
end

-- früh mehrfach scannen
for i=1,60 do
    sweep()
    RunService.Heartbeat:Wait()
end
-- danach auf Änderungen horchen
local ps = plr:WaitForChild("PlayerScripts")
ps.DescendantAdded:Connect(function(d) if d:IsA("LocalScript") and d.Name=="RB7_UI" then d:Destroy() end end)
ps.ChildAdded:Connect(function(d) if d:IsA("LocalScript") and d.Name=="RB7_UI" then d:Destroy() end end)

-- Fallback nachgeladen
task.defer(sweep)
