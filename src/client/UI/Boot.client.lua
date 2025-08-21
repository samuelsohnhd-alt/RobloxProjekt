--!strict
-- UI/Boot.client.lua – lädt App und mountet
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)

local App = require(script.Parent:WaitForChild("App"))
App.mount()
