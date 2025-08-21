--!strict
local Players = game:GetService("Players")
local Theme = require(script.Parent.Parent.styles.Theme)
local LeftMenu = require(script.Parent.Parent.components.LeftMenu)
local TeamPanel = require(script.Parent.Parent.components.TeamPanel)
local MapPreview = require(script.Parent.Parent.components.MapPreview)
local function LobbyScreen()
  local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
  local gui = Instance.new("ScreenGui"); gui.Name="RB7_Lobby"; gui.IgnoreGuiInset=true; gui.DisplayOrder=50; gui.ResetOnSpawn=false; gui.Parent=playerGui
  local bg=Instance.new("Frame"); bg.Size=UDim2.new(1,0,1,0); bg.BackgroundColor3=Theme.Colors.Bg; bg.BorderSizePixel=0; bg.Parent=gui
  local left = LeftMenu.new(bg, {"NOT READY","CHANGE TEAM","LOADOUT","MATCH SETTINGS","PLAYERS","OPTIONS","STATISTICS"}).Frame
  local preview = MapPreview(bg); preview.Position=UDim2.new(0,10,1,-180)
  local right=Instance.new("Frame"); right.Name="RightColumn"; right.Size=UDim2.new(1,-280,1,-20); right.Position=UDim2.new(0,270,0,10); right.BackgroundTransparency=1; right.Parent=bg
  local top=Instance.new("Frame"); top.Name="TeamsRow"; top.Size=UDim2.new(1,0,0,180); top.BackgroundTransparency=1; top.Parent=right
  local h=Instance.new("UIListLayout"); h.FillDirection=Enum.FillDirection.Horizontal; h.Padding=UDim.new(0,12); h.Parent=top
  local alpha = TeamPanel(top,"ALPHA TEAM",{{"World x Famous",38,12,false},{"[NwO]JeeNiNe",34,14,false},{"NwO x DoNTe",62,21,true},{"[X]TxkEoVeR",70,22,false}})
  alpha.Size=UDim2.new(0.5,-6,1,0)
  local bravo = TeamPanel(top,"BRAVO TEAM",{{"[GOD]Able In The Cut",36,5,true},{"Methodz",99,4,false},{"Fams Ringer Tag",44,6,false},{"CnC Killa Chris",47,6,false}})
  bravo.Size=UDim2.new(0.5,-6,1,0)
  local footer=Instance.new("TextLabel"); footer.Name="Footer"; footer.BackgroundTransparency=1; footer.Size=UDim2.new(1,-10,0,18); footer.Position=UDim2.new(0,270,1,-22)
  footer.Font=Theme.Fonts.Mono; footer.TextXAlignment=Enum.TextXAlignment.Right; footer.TextSize=14; footer.TextColor3=Theme.Colors.SubText; footer.Text="XP MODIFIER: -20%"; footer.Parent=bg
  return gui
end
return LobbyScreen
