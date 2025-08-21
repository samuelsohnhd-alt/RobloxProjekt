local UIState = require(script.Parent.Parent.components.UIState)
local Button = require(script.Parent.Parent.components.TextButtonPrimary)

local M = {}

local function makeTitle(parent, text)
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

function M.create()
    local gui = Instance.new("ScreenGui")
    gui.Name = "LobbyScreen"

    local root = Instance.new("Frame")
    root.Name = "Root"
    root.Size = UDim2.fromScale(0.45, 0.6)
    root.Position = UDim2.fromScale(0.05, 0.2)
    root.BackgroundTransparency = 0.05
    root.Parent = gui

    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 12); corner.Parent = root
    makeTitle(root, "RB7 • Lobby")

    local list = Instance.new("Frame")
    list.Name = "Menu"
    list.Size = UDim2.fromScale(1, 0.78)
    list.Position = UDim2.fromScale(0, 0.16)
    list.BackgroundTransparency = 1
    list.Parent = root

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.Parent = list

    local function addItem(name, click)
        local b = Button.create({ Text = name, Size = UDim2.fromOffset(260, 44) })
        b.Parent = list
        b.MouseButton1Click:Connect(click)
        return b
    end

    -- Menüeinträge mit Funktion:
    addItem("▶ Loadout", function() UIState.show("Loadout") end)
    addItem("▶ Gear (demnächst)", function() end)
    addItem("▶ Armor (demnächst)", function() end)
    addItem("↩ Zurück ins HUD", function() UIState.show("HUD") end)

    return gui
end
return M
