-- RB7 UI screens (idempotent)
local uiFolder = script.Parent
local components = uiFolder:FindFirstChild("Components")
if not components then
    warn("[RB7_UI] Components fehlen – lege Ordner an")
    components = Instance.new("Folder")
    components.Name = "Components"
    components.Parent = uiFolder
end

local function tryRequire(name)
    local m = components:FindFirstChild(name)
    if not m then return end
    local ok, mod = pcall(function() return require(m) end)
    if ok then return mod end
    warn(("[RB7_UI] require(%s) fehlgeschlagen"):format(name))
end

local HUDTimer = tryRequire("HUDTimer")
if HUDTimer and HUDTimer.mount then HUDTimer.mount(game:GetService("Players").LocalPlayer) end

local Menu = tryRequire("Menu")
if Menu and Menu.init then Menu.init() end

print("[RB7_UI] screens initialisiert.")
