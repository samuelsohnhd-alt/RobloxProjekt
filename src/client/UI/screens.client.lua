--!strict
local ok, App = pcall(function() return require(script.Parent:WaitForChild("App")) end)
if ok and App and App.mount then
	local ok2, res = pcall(App.mount)
	if ok2 then print("[RB7_UI Legacy] ✅ App mounted via screens") else warn("[RB7_UI Legacy] ⚠️ mount fail:", res) end
else
	warn("[RB7_UI Legacy] ⚠️ App nicht ladbar:", App)
end
