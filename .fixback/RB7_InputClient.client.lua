--!strict
local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local Events  = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Constants"):WaitForChild("Events"))
local Actions = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Input"):WaitForChild("Actions"))

local function getEvent(name: string): RemoteEvent
	return (ReplicatedStorage
		:WaitForChild("Shared")
		:WaitForChild(Events.ROOT)
		:WaitForChild(Events.VERSION)
		:WaitForChild(name)) :: any
end

local RE_SetADS    : RemoteEvent = getEvent(Events.SET_ADS)
local RE_SetCrouch : RemoteEvent = getEvent(Events.SET_CROUCH)
local RE_Reload    : RemoteEvent = getEvent(Events.RELOAD)

local adsOn = false
local crouchOn = false

local function bindADS(actionName, inputState, inputObject)
	if inputState == Enum.UserInputState.Begin then
		adsOn = not adsOn
		RE_SetADS:FireServer({ on = adsOn })
	end
	return Enum.ContextActionResult.Sink
end

local function bindCrouch(actionName, inputState, inputObject)
	if inputState == Enum.UserInputState.Begin then
		crouchOn = not crouchOn
		RE_SetCrouch:FireServer({ on = crouchOn })
	end
	return Enum.ContextActionResult.Sink
end

local function bindReload(actionName, inputState, inputObject)
	if inputState == Enum.UserInputState.Begin then
		RE_Reload:FireServer({})
	end
	return Enum.ContextActionResult.Sink
end

-- Bindings
ContextActionService:BindAction(Actions.ADS_TOGGLE, bindADS, true, Enum.UserInputType.MouseButton2)
ContextActionService:BindAction(Actions.CROUCH_TOGGLE, bindCrouch, true, Enum.KeyCode.C)
ContextActionService:BindAction(Actions.RELOAD, bindReload, true, Enum.KeyCode.R)

print("[RB7_InputClient] ✅ Bindings aktiv (ADS:right mouse, Crouch:C, Reload:R)")
