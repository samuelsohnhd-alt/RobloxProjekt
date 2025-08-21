local Players = game:GetService("Players")

local UI      = script.Parent
local Styles  = UI:WaitForChild("Styles")
local State   = UI:WaitForChild("State")
local Comps   = UI:WaitForChild("Components")

local Theme      = require(Styles:WaitForChild("Theme"))
local Store      = require(State:WaitForChild("Store"))
local StatusBar  = require(Comps:WaitForChild("StatusBar"))
local MakeButton = require(Comps:WaitForChild("Button"))

local function ensureScreenGui(pg)
  local ex = pg:FindFirstChild("RB7_UI")
  if ex and ex:IsA("ScreenGui") then return ex end
  local gui = Instance.new("ScreenGui")
  gui.Name = "RB7_UI"
  gui.ResetOnSpawn = false
  gui.DisplayOrder = 10
  gui.IgnoreGuiInset = true
  gui.Parent = pg
  return gui
end

local function mount()
  local pg  = Players.LocalPlayer:WaitForChild("PlayerGui")
  local gui = ensureScreenGui(pg)

  local hud = Instance.new("Frame")
  hud.Name = "HUD"
  hud.Size = UDim2.fromScale(1, 0)
  hud.AutomaticSize = Enum.AutomaticSize.Y
  hud.BackgroundTransparency = 1
  hud.Parent = gui

  local top = StatusBar()
  top.Parent = hud

  local overlay = Instance.new("Frame")
  overlay.Name = "Overlay"
  overlay.AnchorPoint = Vector2.new(1,1)
  overlay.Position = UDim2.new(1, -16, 1, -16)
  overlay.Size = UDim2.fromOffset(180, 40)
  overlay.BackgroundTransparency = 1
  overlay.Parent = gui

  local toggleBtn = MakeButton({
    text = "HUD: FPS/Ping",
    onClick = function()
      Store.toggle("showFPS", true, false)
      Store.toggle("showPing", true, false)
    end,
    size = UDim2.fromOffset(180, 40)
  })
  toggleBtn.Parent = overlay

  local panel = Instance.new("Frame")
  panel.Name = "Panel"
  panel.Size = UDim2.new(0, 360, 0, 220)
  panel.Position = UDim2.fromOffset(16, 60)
  panel.BackgroundColor3 = Theme.Colors.Panel
  panel.BackgroundTransparency = 0.05
  panel.Parent = gui

  local corner = Instance.new("UICorner", panel)
  corner.CornerRadius = UDim.new(0, Theme.Corner)

  local pad = Instance.new("UIPadding", panel)
  pad.PaddingLeft = UDim.new(0, Theme.Padding)
  pad.PaddingTop = UDim.new(0, Theme.Padding)
  pad.PaddingRight = UDim.new(0, Theme.Padding)
  pad.PaddingBottom = UDim.new(0, Theme.Padding)

  local title = Instance.new("TextLabel")
  title.Name = "Title"
  title.BackgroundTransparency = 1
  title.Size = UDim2.new(1, -Theme.Padding*2, 0, 28)
  title.Font = Theme.Fonts.Header
  title.TextSize = Theme.Sizes.Title
  title.TextColor3 = Theme.Colors.Text
  title.TextXAlignment = Enum.TextXAlignment.Left
  title.Text = "RB7 — UI Panel"
  title.Parent = panel

  print("[RB7_UI] ✅ App mounted (HUD + Panel)")
end

task.defer(mount)
