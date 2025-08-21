-- INIT-GUARD (automatically added) - verhindert doppelte Initialisierung
do
    if _G.RB7_InitGuard == nil then _G.RB7_InitGuard = {} end
    local ok,name = pcall(function() return (script and (pcall(function() return script:GetFullName() end) and script:GetFullName())) end)
    local id = "RB7_GUARD_" .. tostring((ok and name) or (script and script.Name) or tostring(debug.getinfo(1).source))
    if _G.RB7_InitGuard[id] then return end
    _G.RB7_InitGuard[id] = true
end

-- RB7 UI App (safe)
local uiFolder = script.Parent
local components = uiFolder:FindFirstChild("Components")
if not components then
    warn("[UI/App] Components Ordner fehlte – wird erstellt")
    components = Instance.new("Folder")
    components.Name = "Components"
    components.Parent = uiFolder
end

local function req(name)
    local m = components:FindFirstChild(name)
    if not m then return end
    local ok, mod = pcall(function() return require(m) end)
    return ok and mod or nil
end

local HUDTimer = req("HUDTimer")
if HUDTimer and HUDTimer.mount then HUDTimer.mount(game:GetService("Players").LocalPlayer) end

local Menu = req("Menu")
if Menu and Menu.init then Menu.init() end

print("[RB7_UI] App initialisiert.")
