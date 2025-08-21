--!strict
-- RB7_RoundController: Minimaler Rundenloop mit Timer (verwendet Game-Config)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local EventsConst = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Constants"):WaitForChild("Events"))
local GameConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Config"):WaitForChild("Game"))
local Schema     = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Types"):WaitForChild("RemoteSchema"):WaitForChild("Events_v1"))

local function ensureFolder(parent: Instance, name: string): Folder
	local f = parent:FindFirstChild(name)
	if not f then f = Instance.new("Folder"); f.Name = name; f.Parent = parent end
	return f :: Folder
end
local function ensureRemoteEvent(parent: Instance, name: string): RemoteEvent
	local r = parent:FindFirstChild(name)
	if not r then r = Instance.new("RemoteEvent"); r.Name = name; r.Parent = parent end
	return r :: RemoteEvent
end

local RSShared = ensureFolder(ReplicatedStorage, "Shared")
local ERoot    = ensureFolder(RSShared, EventsConst.ROOT)
local EV       = ensureFolder(ERoot, EventsConst.VERSION)

local E_RoundStart = ensureRemoteEvent(EV, EventsConst.ROUND_START)
local E_RoundEnded = ensureRemoteEvent(EV, EventsConst.ROUND_ENDED)
local E_TimerTick  = ensureRemoteEvent(EV, EventsConst.TIMER_TICK)

local roundActive = false
local roundEndsAt = 0

local function broadcastTick(remain: number)
	local payload = { t = remain }
	if Schema.IsTimerTick(payload) then
		E_TimerTick:FireAllClients(payload)
	end
end

local function endRound()
	if not roundActive then return end
	roundActive = false
	E_RoundEnded:FireAllClients({ reason = "timeup" })
	print("[RB7_RoundController] ⏹ Runde ENDE (reason=timeup)")
end

local function startRound(duration: number?)
	if roundActive then endRound() end
	local dur = typeof(duration) == "number" and duration or GameConfig.ROUND_TIME_DEFAULT
	roundActive = true
	roundEndsAt = os.time() + dur
	E_RoundStart:FireAllClients({ duration = dur, endsAt = roundEndsAt })
	print(("[RB7_RoundController] ▶ Runde START (dauer=%ds)"):format(dur))
	task.spawn(function()
		while roundActive do
			local remain = math.max(0, roundEndsAt - os.time())
			broadcastTick(remain)
			if remain <= 0 then endRound() break end
			task.wait(1)
		end
	end)
end

local firstPlayerJoined = false
game:GetService("Players").PlayerAdded:Connect(function(_)
	if not firstPlayerJoined then
		firstPlayerJoined = true
		task.delay(2, function() startRound(GameConfig.ROUND_TIME_DEFAULT) end)
	end
end)
if #Players:GetPlayers() > 0 then
	task.delay(1, function() startRound(GameConfig.ROUND_TIME_DEFAULT) end)
end

print("[RB7_RoundController] ✅ bereit (Config-gestützt)")
