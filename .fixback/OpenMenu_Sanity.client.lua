-- RB7 OpenMenu Sanity (client)
local RS = game:GetService("ReplicatedStorage")
local ok = pcall(function()
    local Shared = RS:WaitForChild("Shared", 5)
    local Events = Shared and Shared:WaitForChild("Events", 5)
    local V1     = Events and Events:WaitForChild("v1", 5)
    local OpenMenu = V1 and V1:WaitForChild("OpenMenu", 5)
    if OpenMenu and OpenMenu:IsA("RemoteEvent") then
        print("[RB7_UI] OpenMenu RemoteEvent ✅ vorhanden")
        OpenMenu.OnClientEvent:Connect(function(...)
            print("[RB7_UI] OpenMenu signal empfangen")
        end)
    else
        warn("[RB7_UI] OpenMenu RemoteEvent fehlt ❌")
    end
end)
if not ok then
    warn("[RB7_UI] OpenMenu Sanity: Zugriff auf Remotes fehlgeschlagen.")
end
