local UIState = require(script.Parent.Parent.Components.UIState)
local Button = require(script.Parent.Parent.Components.TextButtonPrimary)

local M = {}

local WEAPONS = {
    {name="FAMAS", id="FAMAS"},
    {name="MP5",   id="MP5"},
    {name="Pistol",id="Pistol"},
}

local function header(parent, text)
    local t = Instance.new("TextLabel")
    t.Size = UDim2.fromScale(1, 0.12)
    t.Position = UDim2.fromScale(0,0)
    t.BackgroundTransparency = 1
    t.Text = text
    t.TextScaled = true
    t.Font = Enum.Font.GothamBold
    t.TextColor3 = Color3.new(1,1,1)
    t.Parent = parent
end

local function scroll(parent)
    local sc = Instance.new("ScrollingFrame")
    sc.Name = "List"; sc.Size = UDim2.fromScale(1, 0.70); sc.Position = UDim2.fromScale(0, 0.14)
    sc.CanvasSize = UDim2.new(0,0,0,0); sc.ScrollBarThickness = 6; sc.BackgroundTransparency = 0.2
    local padding = Instance.new("UIPadding"); padding.PaddingTop = UDim.new(0,8); padding.PaddingLeft = UDim.new(0,8); padding.PaddingRight = UDim.new(0,8); padding.Parent = sc
    local ly = Instance.new("UIListLayout"); ly.SortOrder = Enum.SortOrder.LayoutOrder; ly.Padding = UDim.new(0,8); ly.Parent = sc
    ly:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sc.CanvasSize = UDim2.new(0,0,0,ly.AbsoluteContentSize.Y+16)
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
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 12); corner.Parent = frame

    header(frame, "Loadout")

    -- Back-Button
    local back = Button.create({ Text = "← Zurück", Size = UDim2.fromOffset(140, 36) })
    back.Position = UDim2.fromScale(0.02, 0.02)
    back.Parent = frame
    back.MouseButton1Click:Connect(function() UIState.show("Lobby") end)

    -- Weapon List
    local list = scroll(frame)
    local selected = { weapon = nil }

    local function addRow(w)
        local row = Instance.new("Frame")
        row.Name = "Row_"..w.id; row.Size = UDim2.new(1, -16, 0, 48); row.BackgroundTransparency = 0.3; row.Parent = list
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0,8); c.Parent = row

        local label = Instance.new("TextLabel")
        label.Name = "Label"; label.Size = UDim2.fromScale(0.6, 1); label.BackgroundTransparency = 1
        label.Text = w.name; label.TextScaled = true; label.TextColor3 = Color3.new(1,1,1); label.Parent = row

        local pick = Button.create({ Text = "Select", Size = UDim2.fromOffset(120, 36) })
        pick.Position = UDim2.fromScale(0.7, 0.1); pick.Parent = row

        local status = Instance.new("TextLabel")
        status.Name = "Status"; status.Size = UDim2.fromOffset(120, 36); status.Position = UDim2.fromScale(0.85, 0.1)
        status.BackgroundTransparency = 1; status.TextScaled = true; status.Text = ""; status.TextColor3 = Color3.fromRGB(160,255,160)
        status.Parent = row

        local function mark(active) status.Text = active and "Selected" or "" end

        pick.MouseButton1Click:Connect(function()
            selected.weapon = w.id
            for _,child in ipairs(list:GetChildren()) do
                if child:IsA("Frame") and child:FindFirstChild("Status") then child.Status.Text = "" end
            end
            mark(true)
        end)
    end

    for _,w in ipairs(WEAPONS) do addRow(w) end

    -- Apply
    local apply = Button.create({ Text = "Apply Loadout", Size = UDim2.fromOffset(180, 44) })
    apply.Position = UDim2.fromScale(0.35, 0.88); apply.Parent = frame
    apply.MouseButton1Click:Connect(function()
        local weapon = selected.weapon
        if weapon then
            print("[Loadout] Selected:", weapon)
            UIState.show("HUD")
        else
            warn("[Loadout] Keine Waffe gewählt")
        end
    end)

    return gui
end

return M
