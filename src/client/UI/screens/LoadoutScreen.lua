--!strict
local Players = game:GetService("Players")
local Theme = require(script.Parent.Parent.styles.Theme)

local function LoadoutScreen()
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "RB7_Loadout"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Enabled = false
    gui.Parent = playerGui

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = Theme.Colors.Bg
    bg.BorderSizePixel = 0
    bg.Parent = gui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,50)
    title.BackgroundTransparency = 1
    title.Font = Theme.Fonts.Header
    title.TextSize = 24
    title.TextColor3 = Theme.Colors.Text
    title.Text = "LOADOUT"
    title.Parent = bg

    local weaponsBtn = Instance.new("TextButton")
    weaponsBtn.Size = UDim2.new(0,200,0,40)
    weaponsBtn.Position = UDim2.new(0,50,0,80)
    weaponsBtn.Text = "Weapons"
    weaponsBtn.BackgroundColor3 = Theme.Colors.AccentDim
    weaponsBtn.TextColor3 = Theme.Colors.Text
    weaponsBtn.Parent = bg

    local gearBtn = Instance.new("TextButton")
    gearBtn.Size = UDim2.new(0,200,0,40)
    gearBtn.Position = UDim2.new(0,50,0,130)
    gearBtn.Text = "Gear"
    gearBtn.BackgroundColor3 = Theme.Colors.AccentDim
    gearBtn.TextColor3 = Theme.Colors.Text
    gearBtn.Parent = bg

    return gui, {Weapons = weaponsBtn, Gear = gearBtn}
end

return LoadoutScreen
EOF \
&& perl -0777 -pe 's/(LobbyScreen\(\))/local Lobby=LobbyScreen()\nlocal Loadout=require\(script.Parent.screens.LoadoutScreen\)\nlocal LoadoutGui,LoadoutBtns=Loadout()\n-- Navigation: Klick auf "Loadout" zeigt LoadoutScreen\nfor _,b in ipairs\(Lobby:GetDescendants\(\)\) do if b:IsA\("TextButton"\) and b.Text=="LOADOUT" then b.MouseButton1Click:Connect\(function\(\)\n Lobby.Enabled=false; LoadoutGui.Enabled=true end\) end end\n\n\1/' -i src/client/UI/Init.client.lua \
&& echo "✅ Menü aktualisiert: 'Outfitting' → 'Loadout', 'A.C.E.S.' entfernt. Basis-LoadoutScreen hinzugefügt."

cat >/tmp/rb7_ui_fix.sh <<'SCRIPT'
#!/usr/bin/env bash
set -euo pipefail

cd ~/RobloxProjekt
git pull

echo "🔎 Suche nach kollidierenden UI-Skripten in src/client …"
FOUND=$(ls src/client | grep -E '^UI(\.client\.(lua|luau)|\.(lua|luau))$' || true)
if [ -n "$FOUND" ]; then
  echo "⚠️  Gefunden und lösche:"
  echo "$FOUND" | sed 's/^/   - /'
  rm -f src/client/UI.client.lua src/client/UI.client.luau src/client/UI.lua src/client/UI.luau
fi

# Ordnerstruktur sicherstellen
mkdir -p src/client/UI/{components,screens,styles,utils}

# Menü anpassen: OUTFITTING->LOADOUT, A.C.E.S. entfernen
perl -0777 -pe 's/\{"NOT READY","CHANGE TEAM","OUTFITTING","MATCH SETTINGS","PLAYERS","OPTIONS","A\.C\.E\.S\.","STATISTICS"\}/{"NOT READY","CHANGE TEAM","LOADOUT","MATCH SETTINGS","PLAYERS","OPTIONS","STATISTICS"}/' -i src/client/UI/screens/LobbyScreen.lua || true

# LoadoutScreen anlegen/aktualisieren
cat > src/client/UI/screens/LoadoutScreen.lua <<'EOF'
--!strict
local Players = game:GetService("Players")
local Theme = require(script.Parent.Parent.styles.Theme)

local function LoadoutScreen()
    local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "RB7_Loadout"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.Enabled = false
    gui.Parent = playerGui

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = Theme.Colors.Bg
    bg.BorderSizePixel = 0
    bg.Parent = gui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,50)
    title.BackgroundTransparency = 1
    title.Font = Theme.Fonts.Header
    title.TextSize = 24
    title.TextColor3 = Theme.Colors.Text
    title.Text = "LOADOUT"
    title.Parent = bg

    local weaponsBtn = Instance.new("TextButton")
    weaponsBtn.Size = UDim2.new(0,220,0,40)
    weaponsBtn.Position = UDim2.new(0,50,0,90)
    weaponsBtn.Text = "Weapons"
    weaponsBtn.BackgroundColor3 = Theme.Colors.AccentDim
    weaponsBtn.TextColor3 = Theme.Colors.Text
    weaponsBtn.Parent = bg

    local gearBtn = Instance.new("TextButton")
    gearBtn.Size = UDim2.new(0,220,0,40)
    gearBtn.Position = UDim2.new(0,50,0,140)
    gearBtn.Text = "Gear (Head/Arm/Shoulder/Chest/Leg/Clothes)"
    gearBtn.BackgroundColor3 = Theme.Colors.AccentDim
    gearBtn.TextColor3 = Theme.Colors.Text
    gearBtn.Parent = bg

    return gui, {Weapons = weaponsBtn, Gear = gearBtn}
end

return LoadoutScreen
