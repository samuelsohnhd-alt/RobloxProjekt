--!strict
local folder = script.Parent:FindFirstChild("Components")
local mod = folder and folder:FindFirstChildWhichIsA("ModuleScript")
if folder and mod then
	print("[RB7_UI] ✅ Components vorhanden (", mod.Name, ")")
else
	warn("[RB7_UI] ❌ Components fehlen oder kein ModuleScript gefunden")
end
