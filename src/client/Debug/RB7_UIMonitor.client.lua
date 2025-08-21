local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer

local function full(n)
    local ok, path = pcall(function() return n:GetFullName() end)
    return ok and path or (n.Name .. " (?)")
end

local function onFound(node, origin)
    local msg = ("[RB7_UIMonitor] RB7_UI entdeckt (%s): %s"):format(origin, full(node))
    print(msg)
    -- Doppelstart-Schutz erzwingen
    if _G.RB7_UI_BOOTED then
        -- Falls jemand noch eine Kopie startet, sofort deaktivieren
        local ok = pcall(function()
            if node:IsA("LocalScript") then
                if node:FindFirstChild("screens") then
                    -- sehr wahrscheinlich legacy
                    print("[RB7_UIMonitor] deaktiviere vermutetes Legacy-Script.")
                end
                -- LocalScript hat die Eigenschaft Enabled
                node.Enabled = false
            end
        end)
        if not ok then
            warn("[RB7_UIMonitor] Konnte Legacy nicht deaktivieren (lief evtl. bereits).")
        end
    end
end

-- Frühe Überwachung: PlayerScripts + StarterPlayerScripts
task.defer(function()
    -- Bereits vorhandene
    local ps = plr:WaitForChild("PlayerScripts")
    for _,d in ipairs(ps:GetDescendants()) do
        if d:IsA("LocalScript") and d.Name == "RB7_UI" then
            onFound(d, "vorhanden")
        end
    end
    -- Live-Spawn
    ps.DescendantAdded:Connect(function(d)
        if d:IsA("LocalScript") and d.Name == "RB7_UI" then
            onFound(d, "spawn")
        end
    end)
end)
