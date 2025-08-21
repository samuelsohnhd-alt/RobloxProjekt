--!strict
-- RB7_RoundController: Minimaler Rundenloop mit Timer (Standard: 300s)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local EventsConst = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Constants"):WaitForChild("Events"))

local function ensureFolder(parent: Instance, name: string): Folder
	local f = parent:FindFirstChild(name)
	if not f then
		f = Instance.new("Folder")
		f.Name = name
		f.Parent = parent
	end
	return f :: Folder
end
local function ensureRemoteEvent(parent: Instance, name: string): RemoteEvent
	local r = parent:FindFirstChild(name)
	if not r then
		r = Instance.new("RemoteEvent")
		r.Name = name
		r.Parent = parent
	end
	return r :: RemoteEvent
end

-- Events-Struktur: ReplicatedStorage/Shared/Events/v1/*
local RSShared = ensureFolder(ReplicatedStorage, "Shared")
local ERoot    = ensureFolder(RSShared, EventsConst.ROOT)
local EV       = ensureFolder(ERoot, EventsConst.VERSION)

local E_RoundStart = ensureRemoteEvent(EV, EventsConst.ROUND_START)
local E_RoundEnded = ensureRemoteEvent(EV, EventsConst.ROUND_ENDED)
local E_TimerTick  = ensureRemoteEvent(EV, EventsConst.TIMER_TICK)

local ROUND_TIME_DEFAULT = 300 -- Sekunden
local roundActive = false
local roundEndsAt = 0

local function broadcastTick(remain: number)
	-- Server -> Client: verbleibende Zeit in Sekunden
	E_TimerTick:FireAllClients({ t = remain })
end

local function endRound()
	if not roundActive then return end
	roundActive = false
	E_RoundEnded:FireAllClients({ reason = "timeup" })
	print(string.format("[RB7_RoundController] ⏹ Runde ENDE (reason=%s)", "timeup"))
end

local function startRound(duration: number?)
	if roundActive then endRound() end
	local dur = typeof(duration) == "number" and duration or ROUND_TIME_DEFAULT
	roundActive = true
	roundEndsAt = os.time() + dur
	E_RoundStart:FireAllClients({ duration = dur, endsAt = roundEndsAt })
	print(string.format("[RB7_RoundController] ▶ Runde START (dauer=%ds)", dur))
	-- Ticker
	task.spawn(function()
		while roundActive do
			local remain = math.max(0, roundEndsAt - os.time())
			broadcastTick(remain)
			if remain <= 0 then
				endRound()
				break
			end
			task.wait(1)
		end
	end)
end

-- Auto-Start: Wenn erster Spieler joint oder bei Serverstart
local firstPlayerJoined = false
Players.PlayerAdded:Connect(function(p)
	if not firstPlayerJoined then
		firstPlayerJoined = true
		task.delay(2, function() startRound(ROUND_TIME_DEFAULT) end)
	end
end)

-- Falls bereits Spieler da (Play Solo etc.)
if #Players:GetPlayers() > 0 then
	task.delay(1, function() startRound(ROUND_TIME_DEFAULT) end)
end

print("[RB7_RoundController] ✅ bereit")
