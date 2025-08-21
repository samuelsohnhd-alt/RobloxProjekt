-- RB7 UI Screens (idempotent) – erwartet components als Sibling-Folder
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local componentsFolder = script.Parent:WaitForChild("components", 3)
if not componentsFolder then
    warn("[RB7_UI] components/ fehlt – lege Dummy an")
    componentsFolder = Instance.new("Folder")
    componentsFolder.Name = "components"
    componentsFolder.Parent = script.Parent
end

-- Beispiel-Komponenten laden (nur wenn vorhanden)
local ok, HUDTimer = pcall(function() return require(componentsFolder:FindFirstChild("HUDTimer")) end)
if ok and HUDTimer and HUDTimer.mount then
    HUDTimer.mount(player)
end

local ok2, Menu = pcall(function() return require(componentsFolder:FindFirstChild("Menu")) end)
if ok2 and Menu and Menu.init then
    Menu.init()
end

print("[RB7_UI] screens initialisiert.")
