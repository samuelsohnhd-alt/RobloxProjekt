-- INIT-GUARD (automatically added) - verhindert doppelte Initialisierung
do
    if _G.RB7_InitGuard == nil then _G.RB7_InitGuard = {} end
    local ok,name = pcall(function() return (script and (pcall(function() return script:GetFullName() end) and script:GetFullName())) end)
    local id = "RB7_GUARD_" .. tostring((ok and name) or (script and script.Name) or tostring(debug.getinfo(1).source))
    if _G.RB7_InitGuard[id] then return end
    _G.RB7_InitGuard[id] = true
end

print("RB7: Client boot ok")
