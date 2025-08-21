local uiFolder = script.Parent
if uiFolder:FindFirstChild("Components") then
    print("[RB7_UI] ✅ Components vorhanden")
else
    warn("[RB7_UI] ⚠️ Components fehlen – werden von App/screens bei Bedarf erzeugt")
end
