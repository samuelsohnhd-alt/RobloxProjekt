--!strict
local Players = game:GetService("Players")
local Theme = require(script.Parent.Parent.styles.Theme)
local function LoadoutScreen()
  local playerGui=Players.LocalPlayer:WaitForChild("PlayerGui")
  local gui=Instance.new("ScreenGui"); gui.Name="RB7_Loadout"; gui.IgnoreGuiInset=true; gui.ResetOnSpawn=false; gui.Enabled=false; gui.Parent=playerGui
  local bg=Instance.new("Frame"); bg.Size=UDim2.new(1,0,1,0); bg.BackgroundColor3=Theme.Colors.Bg; bg.BorderSizePixel=0; bg.Parent=gui
  local title=Instance.new("TextLabel"); title.Size=UDim2.new(1,0,0,50); title.BackgroundTransparency=1; title.Font=Theme.Fonts.Header; title.TextSize=24; title.TextColor3=Theme.Colors.Text; title.Text="LOADOUT"; title.Parent=bg
  local weapons=Instance.new("TextButton"); weapons.Size=UDim2.new(0,220,0,40); weapons.Position=UDim2.new(0,50,0,90); weapons.Text="Weapons"; weapons.BackgroundColor3=Theme.Colors.AccentDim; weapons.TextColor3=Theme.Colors.Text; weapons.Parent=bg
  local gear=Instance.new("TextButton"); gear.Size=UDim2.new(0,220,0,40); gear.Position=UDim2.new(0,50,0,140); gear.Text="Gear (Head/Arm/Shoulder/Chest/Leg/Clothes)"; gear.BackgroundColor3=Theme.Colors.AccentDim; gear.TextColor3=Theme.Colors.Text; gear.Parent=bg
  return gui,{Weapons=weapons,Gear=gear}
end
return LoadoutScreen
