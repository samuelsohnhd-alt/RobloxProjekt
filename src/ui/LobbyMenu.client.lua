local Players = game:GetService("Players")
local player = Players.LocalPlayer or Players:GetPlayers()[1]
local pg = player:WaitForChild("PlayerGui")

-- Haupt-GUI
local gui = Instance.new("ScreenGui")
gui.Name = "LobbyGui"
gui.ResetOnSpawn = false
gui.Parent = pg

----------------------------------------------------------------------
-- MAP-VORSCHAU (unten links)
local mapPreview = Instance.new("Frame")
mapPreview.Name = "MapPreview"
mapPreview.Size = UDim2.new(0,200,0,200)
mapPreview.Position = UDim2.new(0,10,1,-210) -- 10px vom Rand, 210px hoch
mapPreview.BorderSizePixel = 2
mapPreview.Parent = gui

local mapImage = Instance.new("ImageLabel")
mapImage.Name = "Image"
mapImage.Size = UDim2.new(1,0,1,0)
mapImage.BackgroundTransparency = 1
mapImage.Image = "rbxassetid://0" -- hier deine Map-Vorschau-ID eintragen
mapImage.Parent = mapPreview
----------------------------------------------------------------------

----------------------------------------------------------------------
-- BUTTONS-LISTE (links, vertikal)
local buttonNames = {
    "Not Ready",
    "Change Team",
    "Loadouts",       -- führt zu Ausrüstung & Waffenstand
    "Match Settings",
    "Players",
    "Options",
    "Stats"
}

for i, name in ipairs(buttonNames) do
    local btn = Instance.new("TextButton")
    btn.Name = name:gsub(" ", "")
    btn.Text = name
    btn.Size = UDim2.new(0,160,0,40)
    btn.Position = UDim2.new(0,10,0,10 + (i-1)*45)
    btn.BackgroundColor3 = Color3.fromRGB(30,30,30)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Parent = gui
end
----------------------------------------------------------------------

----------------------------------------------------------------------
-- TEAM-TAFEL (rechts vom Button-Bereich)
local teamFrame = Instance.new("Frame")
teamFrame.Name = "Teams"
teamFrame.Size = UDim2.new(0,420,0,260)
teamFrame.Position = UDim2.new(0,180,0,10)
teamFrame.BackgroundTransparency = 1
teamFrame.Parent = gui

local teamNames = {"Alpha Team","Bravo Team"}
for t = 1,2 do
    local tf = Instance.new("Frame")
    tf.Name = teamNames[t]:gsub(" ","")
    tf.Size = UDim2.new(0.5,0,1,0)
    tf.Position = UDim2.new((t-1)*0.5,0,0,0)
    tf.Parent = teamFrame

    local header = Instance.new("TextLabel")
    header.Text = teamNames[t]
    header.Size = UDim2.new(1,0,0,30)
    header.BackgroundColor3 = Color3.fromRGB(40,40,40)
    header.TextColor3 = Color3.new(1,1,1)
    header.Parent = tf

    -- Platzhalter für Spieler-Zeilen
    for i = 1,4 do
        local entry = Instance.new("TextLabel")
        entry.Size = UDim2.new(1,0,0,25)
        entry.Position = UDim2.new(0,0,0,30 + (i-1)*25)
        entry.Text = "Player"..i.."    0    0"
        entry.TextXAlignment = Enum.TextXAlignment.Left
        entry.BackgroundColor3 = Color3.fromRGB(20,20,20)
        entry.TextColor3 = Color3.new(1,1,1)
        entry.Parent = tf
    end
end
----------------------------------------------------------------------

----------------------------------------------------------------------
-- LOADOUT-MENÜ (Ausrüstung & Waffenstand)
local loadoutMenu = Instance.new("Frame")
loadoutMenu.Name = "LoadoutMenu"
loadoutMenu.Size = UDim2.new(0.4,0,0.4,0)
loadoutMenu.Position = UDim2.new(0.3,0,0.3,0)
loadoutMenu.BackgroundColor3 = Color3.fromRGB(10,10,10)
loadoutMenu.Visible = false
loadoutMenu.Parent = gui

local backBtn = Instance.new("TextButton")
backBtn.Text = "Zurück"
backBtn.Size = UDim2.new(0,120,0,40)
backBtn.Position = UDim2.new(0,10,0,10)
backBtn.Parent = loadoutMenu
backBtn.MouseButton1Click:Connect(function()
    loadoutMenu.Visible = false
end)

local equipBtn = Instance.new("TextButton")
equipBtn.Text = "Ausrüstung"
equipBtn.Size = UDim2.new(0,140,0,40)
equipBtn.Position = UDim2.new(0,10,0,60)
equipBtn.Parent = loadoutMenu

local weaponsBtn = Instance.new("TextButton")
weaponsBtn.Text = "Waffenstand"
weaponsBtn.Size = UDim2.new(0,140,0,40)
weaponsBtn.Position = UDim2.new(0,10,0,110)
weaponsBtn.Parent = loadoutMenu

-- Öffnet das Loadout-Menü
gui.Loadouts.MouseButton1Click:Connect(function()
    loadoutMenu.Visible = true
end)
----------------------------------------------------------------------

print("Lobby-Menü erstellt.")

