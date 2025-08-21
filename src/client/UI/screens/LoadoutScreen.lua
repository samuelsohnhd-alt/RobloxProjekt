local EventBridge = require(script.Parent.Parent.components.EventBridge)
local TextButtonPrimary = require(script.Parent.Parent.components.TextButtonPrimary)
local TabBar = require(script.Parent.Parent.components.TabBar)

local M = {}

local WEAPONS = {
    -- DisplayName, Id/Preset
    {name="FAMAS", id="FAMAS"},
    {name="MP5",   id="MP5"},
    {name="Pistol",id="Pistol"},
}

local function makeHeader(parent, text)
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.fromScale(1, 0.1)
    title.Position = UDim2.fromScale(0, 0)
    title.BackgroundTransparency = 1
    title.Text = text
    title.TextScaled = true
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBold
    title.Parent = parent
    return title
end

local function makeScroll(parent)
    local sc = Instance.new("ScrollingFrame")
    sc.Name = "List"
    sc.Size = UDim2.fromScale(1, 0.7)
    sc.Position = UDim2.fromScale(0, 0.12)
    sc.CanvasSize = UDim2.new(0,0,0,0)
    sc.ScrollBarThickness = 6
    sc.BackgroundTransparency = 0.2

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0,8)
    padding.PaddingLeft = UDim.new(0,8)
    padding.PaddingRight = UDim.new(0,8)
    padding.Parent = sc

    local list = Instance.new("UIListLayout")
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0,8)
    list.Parent = sc

    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sc.CanvasSize = UDim2.new(0,0,0,list.AbsoluteContentSize.Y+16)
    end)

    sc.Parent = parent
    return sc
end

function M.create()
    local gui = Instance.new("ScreenGui")
    gui.Name = "LoadoutScreen"

    local frame = Instance.new("Frame")
    frame.Name = "Root"
    frame.Size = UDim2.fromScale(0.6, 0.7)
    frame.Position = UDim2.fromScale(0.2, 0.15)
    frame.BackgroundTransparency = 0.05
    frame.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    makeHeader(frame, "Loadout")

    local selected = { weapon = nil }

    -- Tabbar
    local tabs = TabBar.create({"Weapons","Gear","Armor","Back"}, function(tab)
        if tab == "Back" then
            -- Zur Lobby zurück
            local ev = EventBridge.getEventsRoot()
            if ev and ev:FindFirstChild("OpenMenu") then
                ev.OpenMenu:FireServer("Lobby")
            end
            gui.Enabled = false
            return
        end
        -- (Platzhalter: weitere Tabs zukünftig)
    end)
    tabs.Position = UDim2.fromScale(0, 0.88)
    tabs.Parent = frame

    -- Waffenliste
    local list = makeScroll(frame)

    local function spawnWeaponRow(w)
        local row = Instance.new("Frame")
        row.Name = "Row_"..w.id
        row.Size = UDim2.new(1, -16, 0, 48)
        row.BackgroundTransparency = 0.3
        row.Parent = list

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = row

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.Size = UDim2.fromScale(0.6, 1)
        label.BackgroundTransparency = 1
        label.Text = w.name
        label.TextScaled = true
        label.TextColor3 = Color3.new(1,1,1)
        label.Parent = row

        local pick = TextButtonPrimary.create({ Size = UDim2.fromOffset(120, 36), Text = "Select" })
        pick.Position = UDim2.fromScale(0.7, 0.1)
        pick.Parent = row

        local status = Instance.new("TextLabel")
        status.Name = "Status"
        status.Size = UDim2.fromOffset(120, 36)
        status.Position = UDim2.fromScale(0.85, 0.1)
        status.BackgroundTransparency = 1
        status.TextScaled = true
        status.Text = ""
        status.TextColor3 = Color3.new(0.7,1,0.7)
        status.Parent = row

        local function updateStatus(active)
            status.Text = active and "Selected" or ""
        end

        pick.MouseButton1Click:Connect(function()
            selected.weapon = w.id
            -- Statusanzeigen aktualisieren
            for _,child in ipairs(list:GetChildren()) do
                if child:IsA("Frame") and child:FindFirstChild("Status") then
                    child.Status.Text = ""
                end
            end
            updateStatus(true)
        end)
    end

    for _,w in ipairs(WEAPONS) do
        spawnWeaponRow(w)
    end

    -- Apply-Button
    local apply = TextButtonPrimary.create({ Size = UDim2.fromOffset(180, 44), Text = "Apply Loadout" })
    apply.Position = UDim2.fromScale(0.35, 0.88)
    apply.Parent = frame

    apply.MouseButton1Click:Connect(function()
        local ev = EventBridge.getEventsRoot()
        if not ev then
            warn("[Loadout] EventsRoot nicht gefunden")
            return
        end
        local weapon = selected.weapon
        if weapon then
            -- Robust: feuere, was es gibt
            if ev:FindFirstChild("EquipWeapon") then
                ev.EquipWeapon:FireServer(weapon)
                print("[Loadout] EquipWeapon ->", weapon)
            end
            if ev:FindFirstChild("SaveWeaponChoice") then
                ev.SaveWeaponChoice:FireServer(weapon)
                print("[Loadout] SaveWeaponChoice ->", weapon)
            end
            if ev:FindFirstChild("OpenMenu") then
                ev.OpenMenu:FireServer("HUD") -- zurück ins Spiel/HUD
            end
            gui.Enabled = false
        else
            warn("[Loadout] Keine Waffe gewählt")
        end
    end)

    return gui
end

return M
