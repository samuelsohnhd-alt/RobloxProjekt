--!strict
-- Safe Preboot: räumt NUR RB7_UI auf. UI wird NIE gelöscht.
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local ps  = plr:WaitForChild("PlayerScripts")
local client = ps:FindFirstChild("Client")
if client then
	for _,ch in ipairs(client:GetChildren()) do
		if ch.Name == "RB7_UI" then
			ch:Destroy()
			print("[RB7_Preboot] entfernt: RB7_UI")
		end
	end
end
print("[RB7_Preboot] ✅ Safe-Clean (UI bleibt unangetastet).")
