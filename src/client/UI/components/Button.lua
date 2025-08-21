local Theme = require(script.Parent.Parent.Styles.Theme)
return function(props)
  props = props or {}
  local btn = Instance.new("TextButton")
  btn.Name="RB7_Button"; btn.AutoButtonColor=false
  btn.Text = props.text or "Button"; btn.Size = props.size or UDim2.fromOffset(160,36)
  btn.BackgroundColor3 = Theme.Colors.Accent; btn.TextColor3 = Theme.Colors.Bg
  btn.Font = Theme.Fonts.Body; btn.TextSize = Theme.Sizes.Base
  Instance.new("UICorner", btn).CornerRadius = UDim.new(0, Theme.Corner)
  local pad=Instance.new("UIPadding", btn); pad.PaddingLeft=UDim.new(0,Theme.Padding); pad.PaddingRight=UDim.new(0,Theme.Padding)
  btn.MouseButton1Click:Connect(function() if typeof(props.onClick)=="function" then task.spawn(props.onClick) end end)
  btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Theme.Colors.Accent2 end)
  btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Theme.Colors.Accent end)
  return btn
end
