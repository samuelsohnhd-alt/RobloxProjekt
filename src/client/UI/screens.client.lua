--!strict
-- UI/screens.client.lua – Legacy-Bridge
-- Stellt `script.components` als ModuleScript bereit, das die neuen UI/Components exportiert.
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function ensureModule(name: string): ModuleScript
	local m = script:FindFirstChild(name)
	if m and m:IsA("ModuleScript") then return m end
	m = Instance.new("ModuleScript")
	m.Name = name
	m.Source = "-- legacy components shim\nreturn require(script.Parent:WaitForChild(\"Components\"):WaitForChild(\"init\"))"
	m.Parent = script
	return m
end

-- Stelle script.components als ModuleScript zur Verfügung
local shim = ensureModule("components")

-- Optional: kleine Probe, ob require funktioniert
local ok, res = pcall(function() return require(shim) end)
if ok then
	print("[RB7_UI LegacyBridge] ✅ script.components verfügbar")
else
	warn("[RB7_UI LegacyBridge] ⚠️ require(script.components) fehlgeschlagen:", res)
end
