--!strict
-- Prüft, ob Components vorhanden sind (hilfreich für Logs)
local ok = script.Parent:FindFirstChild("Components") ~= nil
if ok then
	print("[RB7_UI] ✅ Components vorhanden")
else
	warn("[RB7_UI] ❌ Components fehlen")
end
