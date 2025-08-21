--!strict
-- UI/Boot.client.lua – lädt App und mountet (mit sauberem Fehlerlog)
local App = require(script.Parent:WaitForChild("App"))
local ok, res = pcall(function() return App.mount() end)
if ok then
	print("[RB7_UI] App initialisiert.")
else
	warn("[RB7_UI] App-Start fehlgeschlagen:", res)
end
