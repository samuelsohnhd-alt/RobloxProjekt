--!strict
local RunService = game:GetService("RunService")
local Env = { NAME = RunService:IsStudio() and "dev" or "prod" }
return Env
