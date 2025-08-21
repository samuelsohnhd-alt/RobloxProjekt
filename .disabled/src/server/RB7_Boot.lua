-- INIT-GUARD (automatically added) - verhindert doppelte Initialisierung
do
    if _G.RB7_InitGuard == nil then _G.RB7_InitGuard = {} end
    local ok,name = pcall(function() return (script and (pcall(function() return script:GetFullName() end) and script:GetFullName())) end)
    local id = "RB7_GUARD_" .. tostring((ok and name) or (script and script.Name) or tostring(debug.getinfo(1).source))
    if _G.RB7_InitGuard[id] then return end
    _G.RB7_InitGuard[id] = true
end

-- filepath: src/server/RB7_Boot.lua
-- ...existing code...
local Boot = {}
local _started = false

function Boot.Init()
    if _started then return end
    _started = true

    -- Bestehende Boot-Logik hier einfügen oder einmalig aufrufen.
    -- Beispiel-Log:
    print("RB7: Server boot ok")
end

return Boot
-- ...existing code...
