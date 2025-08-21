local Players = game:GetService("Players")
local player  = Players.LocalPlayer

local GUI_NAME = "RB7_Crosshair"
local GAP      = 6
local THICK    = 2
local LENGTH   = 12
local COLOR    = Color3.fromRGB(255,255,255)
local ALPHA    = 0

local function clearOld(pg)
	if not pg then return end
	local old = pg:FindFirstChild(GUI_NAME)
	if old then old:Destroy() end
end

local function makeLine(w, h, dx, dy, parent)
	local f = Instance.new("Frame")
	f.Size = UDim2.new(0, w, 0, h)
	f.AnchorPoint = Vector2.new(0.5, 0.5)
	f.Position = UDim2.fromScale(0.5, 0.5) + UDim2.new(0, dx, 0, dy)
	f.BorderSizePixel = 0
	f.BackgroundColor3 = COLOR
	f.BackgroundTransparency = ALPHA
	f.Name = ("Line_%d_%d"):format(dx, dy)
	f.Parent = parent
	return f
end

local function build(pg)
	clearOld(pg)
	local gui = Instance.new("ScreenGui")
	gui.Name = GUI_NAME
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.Parent = pg

	makeLine(LENGTH, THICK, -(GAP + math.floor(LENGTH/2)), 0, gui)
	makeLine(LENGTH, THICK,  (GAP + math.floor(LENGTH/2)), 0, gui)
	makeLine(THICK,  LENGTH, 0, -(GAP + math.floor(LENGTH/2)), gui)
	makeLine(THICK,  LENGTH, 0,  (GAP + math.floor(LENGTH/2)), gui)
end

local function ensure()
	local pg = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui")
	build(pg)
end

ensure()
player.CharacterAdded:Connect(function()
	task.defer(ensure)
end)
