print("✅ Rojo Build Test: ServerScript wurde geladen.")

game:GetService("Players").PlayerAdded:Connect(function(p)
    print("👋 Spieler beigetreten:", p.Name)
end)
