local Theme = require(script.Parent.Parent.Styles.Theme)
local Store = require(script.Parent.Parent.State.Store)
local RunService = game:GetService("RunService"); local Stats = game:GetService("Stats")
return function()
  local frame=Instance.new("Frame"); frame.Name="RB7_StatusBar"; frame.Size=UDim2.new(1,0,0,28); frame.BackgroundTransparency=1; frame.ZIndex=Theme.Z.HUD
  local c=Instance.new("Frame"); c.Name="Container"; c.Parent=frame; c.Size=UDim2.fromScale(1,1); c.BackgroundColor3=Theme.Colors.Panel; c.BackgroundTransparency=0.2
  Instance.new("UICorner", c).CornerRadius=UDim.new(0,Theme.Corner)
  local pad=Instance.new("UIPadding", c); pad.PaddingLeft=UDim.new(0,Theme.Padding); pad.PaddingRight=UDim.new(0,Theme.Padding)
  local list=Instance.new("UIListLayout", c); list.FillDirection=Enum.FillDirection.Horizontal; list.HorizontalAlignment=Enum.HorizontalAlignment.Right; list.VerticalAlignment=Enum.VerticalAlignment.Center; list.Padding=UDim.new(0,12)
  local function mk(name) local l=Instance.new("TextLabel"); l.Name=name; l.BackgroundTransparency=1; l.Size=UDim2.fromOffset(100,28); l.Font=Theme.Fonts.Mono; l.TextSize=Theme.Sizes.Small; l.TextColor3=Theme.Colors.Subtle; l.TextXAlignment=Enum.TextXAlignment.Right; l.ZIndex=Theme.Z.HUD; return l end
  local fpsL=mk("FPS"); fpsL.Parent=c; local pingL=mk("Ping"); pingL.Parent=c
  local frames, last = 0, os.clock()
  RunService.Heartbeat:Connect(function()
    frames += 1; local now=os.clock()
    if now-last>=1 then fpsL.Visible=Store.get("showFPS",true); if fpsL.Visible then fpsL.Text=string.format("FPS %3d",frames) end; frames=0; last=now end
  end)
  task.spawn(function()
    while task.wait(0.5) do
      local it = Stats and Stats.Network and Stats.Network.ServerStatsItem and Stats.Network.ServerStatsItem["Data Ping"]
      local ping = it and tonumber(it:GetValueString():gsub(" ms","")) or nil
      pingL.Visible = Store.get("showPing",true) and ping~=nil; if pingL.Visible then pingL.Text = string.format("PING %3d ms", ping) end
    end
  end)
  return frame
end
