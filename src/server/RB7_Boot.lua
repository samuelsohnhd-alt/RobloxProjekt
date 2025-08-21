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
