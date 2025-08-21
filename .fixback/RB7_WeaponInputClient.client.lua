--!strict
local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local Events  = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Constants"):WaitForChild("Events"))
local WConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Weapons"):WaitForChild("Config"))

local function getEvent(name: string): any
	return (ReplicatedStorage
		:WaitForChild("Shared")
		:WaitForChild(Events.ROOT)
		:WaitForChild(Events.VERSION)
		:WaitForChild(name))
end

local RE_Equip : RemoteEvent = getEvent(Events.EQUIP_WEAPON)
local RE_Shoot : RemoteEvent = getEvent(Events.SHOOT)
local RE_AmmoUp: RemoteEvent = getEvent(Events.AMMO_UPDATE)
local RF_Loadout: RemoteFunction = getEvent(Events.GET_LOADOUT)

local equipped = "FAMAS"

-- HUD-Hook
local pg = player:WaitForChild("PlayerGui")
local hud = pg:FindFirstChild("RB7_HUD") or Instance.new("ScreenGui")
hud.Name = "RB7_HUD"; hud.ResetOnSpawn=false; hud.IgnoreGuiInset=true; hud.Parent = pg

local ammoLabel = hud:FindFirstChild("Ammo") :: TextLabel?
if not ammoLabel then
	ammoLabel = Instance.new("TextLabel")
	ammoLabel.Name = "Ammo"
	ammoLabel.Size = UDim2.new(0, 160, 0, 28)
	ammoLabel.Position = UDim2.new(0, 12, 0, 76)
	ammoLabel.BackgroundTransparency = 0.3
	ammoLabel.Text = "🔫 --/--"
	ammoLabel.Parent = hud
end

local function renderAmmo(name:string, mag:number?, reserve:number?)
	if mag and reserve then
		ammoLabel.Text = ("🔫 %s  %d/%d"):format(name, mag, reserve)
	end
end

-- Initial: Loadout & Start-Anzeige
local ok, loadout = pcall(function() return RF_Loadout:InvokeServer() end)
if ok and typeof(loadout)=="table" then
	equipped = loadout.Equipped or equipped
end
RE_Equip:FireServer({ name = equipped })

-- Bindings: Equip 1/2/3, Shoot (LMB)
local function bindEquip1(_,state) if state==Enum.UserInputState.Begin then equipped="FAMAS"; RE_Equip:FireServer({name=equipped}) end return Enum.ContextActionResult.Sink end
local function bindEquip2(_,state) if state==Enum.UserInputState.Begin then equipped="MP5";   RE_Equip:FireServer({name=equipped}) end return Enum.ContextActionResult.Sink end
local function bindEquip3(_,state) if state==Enum.UserInputState.Begin then equipped="PISTOL";RE_Equip:FireServer({name=equipped}) end return Enum.ContextActionResult.Sink end
local function bindShoot(_,state)
	if state==Enum.UserInputState.Begin then
		RE_Shoot:FireServer({ name = equipped })
	end
	return Enum.ContextActionResult.Sink
end

ContextActionService:BindAction("RB7_EQUIP_1", bindEquip1, true, Enum.KeyCode.One)
ContextActionService:BindAction("RB7_EQUIP_2", bindEquip2, true, Enum.KeyCode.Two)
ContextActionService:BindAction("RB7_EQUIP_3", bindEquip3, true, Enum.KeyCode.Three)
ContextActionService:BindAction("RB7_SHOOT",   bindShoot,  true, Enum.UserInputType.MouseButton1)

-- Live-Ammo-Updates vom Server
RE_AmmoUp.OnClientEvent:Connect(function(payload)
	if typeof(payload)=="table" then
		renderAmmo(payload.name, payload.mag, payload.reserve)
	end
end)
