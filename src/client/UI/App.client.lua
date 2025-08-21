-- RB7 UI App (idempotent) – sorgt für korrektes Laden von Components/
local Players = game:GetService("Players")
local player  = Players.LocalPlayer

local uiFolder = script.Parent
local componentsFolder = uiFolder:FindFirstChild("Components")
if not componentsFolder then
    warn("[RB7_UI] Components/ fehlt – lege Dummy-Ordner an")
    componentsFolder = Instance.new("Folder")
    componentsFolder.Name = "Components"
    componentsFolder.Parent = uiFolder
end

local function tryRequire(name)
    local m = componentsFolder:FindFirstChild(name)
    if not m then return nil end
    local ok, mod = pcall(function() return require(m) end)
    if ok then return mod end
    warn(("[RB7_UI] require(%s) fehlgeschlagen: %s"):format(name, tostring(mod)))
    return nil
end

-- Optional: HUDTimer mounten
local HUDTimer = tryRequire("HUDTimer")
if HUDTimer and HUDTimer.mount then
    HUDTimer.mount(player)
end

-- Optional: Menu initialisieren
local Menu = tryRequire("Menu")
if Menu and Menu.init then
    Menu.init()
end

print("[RB7_UI] App initialisiert (Components ready).")
