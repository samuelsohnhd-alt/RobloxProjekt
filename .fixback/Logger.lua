--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Env = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Config"):WaitForChild("Env"))
local Logger = {}
local function tag(l) return ("[RB7][%s] "):format(l) end
function Logger.info(...) if Env.NAME=="dev" then print(tag("INFO"), ...) end end
function Logger.warn(...) warn(tag("WARN"), ...) end
function Logger.err(...) warn(tag("ERR"), ...) end
return Logger
