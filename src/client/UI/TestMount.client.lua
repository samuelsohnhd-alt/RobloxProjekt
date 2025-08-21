--!strict
-- Läuft clientseitig automatisch über StarterPlayerScripts (Rojo Mapping).
-- Prüft Events und mountet die UI-App, loggt verständlich.

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

local function log(ok: boolean, msg: string, ...)
	if ok then
		print("[TEST] ✅ "..msg:format(...))
	else
		warn("[TEST] ❌ "..msg:format(...))
	end
end

-- 1) Events prüfen
local ok1, v1 = pcall(function()
	local ev = RS:WaitForChild("Events", 10)
	return ev and ev:WaitForChild("v1", 10) or nil
end)
if not ok1 or not v1 then
	warn("[TEST] ❌ Events/v1 nicht gefunden (ReplicatedStorage/Events/v1).")
	return
end

local haveRoundTime = v1:FindFirstChild("RoundTimeUpdated") ~= nil
local haveRoundState = v1:FindFirstChild("RoundStateChanged") ~= nil
log(haveRoundTime and haveRoundState, "Events vorhanden: RoundTimeUpdated=%s, RoundStateChanged=%s", tostring(haveRoundTime), tostring(haveRoundState))
if not (haveRoundTime and haveRoundState) then return end

-- 2) App mounten
local ok2, res = pcall(function()
	local app = require(script.Parent:WaitForChild("App"))
	return app.mount()
end)
if ok2 then
	log(true, "App mounted (ScreenGui aktiv).")
else
	log(false, "App mount fehlgeschlagen: %s", tostring(res))
end
