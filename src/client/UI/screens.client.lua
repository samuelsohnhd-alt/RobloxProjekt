--!strict
-- Legacy screens-loader: delegiert auf App
local App = require(script.Parent:WaitForChild("App"))
local ok, res = pcall(function() return App.mount() end)
if ok then
	print("[RB7_UI Legacy] ✅ App mounted via screens")
else
	warn("[RB7_UI Legacy] ⚠️ mount fail:", res)
end
