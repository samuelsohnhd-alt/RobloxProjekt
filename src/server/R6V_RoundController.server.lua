--!strict
-- R6V_RoundController.server.lua
-- Zustandsmaschine für Lobby/Countdown/In-Round/Post-Round
-- Stellt fehlende Funktionen setState / markPlayerReady bereit und sichert Events.

local Players            = game:GetService("Players")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local RunService         = game:GetService("RunService")

-- ==== Konfig (Fallback, kann via Modules.Shared.Config.GameConfig überschrieben werden) ====
local CFG = {
	RoundTime = 300,      -- Sekunden
	TargetScore = 25,
	RespawnTime = 5,
	FriendlyFire = false,
	MinReadyToStart = 1,  -- Mindestanzahl "Ready"-Spieler zum Starten
	Countdown = 3         -- Sekunden Lobby -> InRound
}

do
	local Modules = ReplicatedStorage:FindFirstChild("Modules")
	if Modules and Modules:FindFirstChild("Shared") then
		local Config = Modules.Shared:FindFirstChild("Config")
		if Config and Config:FindFirstChild("GameConfig") and Config.GameConfig:IsA("ModuleScript") then
			local ok, userCfg = pcall(require, Config.GameConfig)
			if ok and type(userCfg) == "table" then
				for k,v in pairs(userCfg) do CFG[k] = v end
			end
		end
	end
end

-- ==== Events/v1 sichern ====
local function ensureFolder(parent: Instance, name: string): Instance
	local f = parent:FindFirstChild(name)
	if not f then
		f = Instance.new("Folder")
		f.Name = name
		f.Parent = parent
	end
	return f
end

local function ensureRemoteEvent(parent: Instance, name: string): RemoteEvent
	local ev = parent:FindFirstChild(name)
	if not ev then
		ev = Instance.new("RemoteEvent")
		ev.Name = name
		ev.Parent = parent
	end
	return ev :: RemoteEvent
end

local function ensureRemoteFunction(parent: Instance, name: string): RemoteFunction
	local rf = parent:FindFirstChild(name)
	if not rf then
		rf = Instance.new("RemoteFunction")
		rf.Name = name
		rf.Parent = parent
	end
	return rf :: RemoteFunction
end

local Events = ensureFolder(ReplicatedStorage, "Events")
local v1     = ensureFolder(Events, "v1")

local RequestReadyToggle  = ensureRemoteEvent(v1, "RequestReadyToggle")   -- Client -> Server: ready toggeln
local PlayerReadyChanged  = ensureRemoteEvent(v1, "PlayerReadyChanged")   -- Server -> Client: ready eines Spielers
local RoundStateChanged   = ensureRemoteEvent(v1, "RoundStateChanged")    -- Server -> Client: neuer RoundState
local RequestStartRound   = ensureRemoteEvent(v1, "RequestStartRound")    -- (optional) Client -> Server: Startwunsch
local GetRoundState       = ensureRemoteFunction(v1, "GetRoundState")     -- Client -> Server: aktuellen State abfragen

-- ==== interner Zustand ====
export type RoundStateT = "LOBBY" | "COUNTDOWN" | "IN_ROUND" | "POST_ROUND"
local RoundState: RoundStateT = "LOBBY"
local RoundStartedAt: number = 0
local Ready: { [number]: boolean } = {}        -- userId -> ready?
local Score: { [number]: number } = {}         -- userId -> score (Beispiel)

-- ==== Hilfen ====
local function broadcastReady(plr: Player, val: boolean)
	PlayerReadyChanged:FireAllClients(plr.UserId, val)
end

local function everyoneReadyCount(): number
	local n = 0
	for _,plr in ipairs(Players:GetPlayers()) do
		if Ready[plr.UserId] then n += 1 end
	end
	return n
end

local function secondsSince(t0: number): number
	return os.clock() - t0
end

-- ==== API: setState / markPlayerReady (die vorher fehlten) ====
local function setState(nextState: RoundStateT)
	if RoundState == nextState then return end
	RoundState = nextState
	RoundStateChanged:FireAllClients(RoundState)
	print(("[R6V_RoundController][STATE] ➜ %s"):format(RoundState))

	if RoundState == "COUNTDOWN" then
		task.spawn(function()
			for i = CFG.Countdown,1,-1 do
				print(("[R6V_RC][COUNTDOWN] %d"):format(i))
				task.wait(1)
				-- Falls während Countdown die Voraussetzungen wegfallen, abbrechen:
				if everyoneReadyCount() < math.max(CFG.MinReadyToStart, 1) then
					print("[R6V_RC] ❌ Countdown abgebrochen (zu wenige Ready).")
					setState("LOBBY")
					return
				end
			end
			setState("IN_ROUND")
		end)
	elseif RoundState == "IN_ROUND" then
		RoundStartedAt = os.clock()
		task.spawn(function()
			while RoundState == "IN_ROUND" do
				local elapsed = secondsSince(RoundStartedAt)
				if elapsed >= CFG.RoundTime then
					print("[R6V_RC] ⏱️ RoundTime abgelaufen.")
					setState("POST_ROUND")
					break
				end
				task.wait(0.25)
			end
		end)
	elseif RoundState == "POST_ROUND" then
		-- Kurze Auswertung / Reset
		task.delay(3, function()
			-- Reset:
			for uid,_ in pairs(Ready) do Ready[uid] = false end
			for uid,_ in pairs(Score) do Score[uid] = 0 end
			for _,plr in ipairs(Players:GetPlayers()) do
				broadcastReady(plr, false)
			end
			setState("LOBBY")
		end)
	end
end

local function markPlayerReady(plr: Player, isReady: boolean)
	Ready[plr.UserId] = isReady and true or false
	broadcastReady(plr, Ready[plr.UserId])
	print(("[R6V_RoundController] ▶ %s ready=%s"):format(plr.Name, tostring(Ready[plr.UserId])))

	-- Auto-Start-Logik: Wenn genug Spieler ready, in Countdown wechseln:
	if RoundState == "LOBBY" and everyoneReadyCount() >= math.max(CFG.MinReadyToStart, 1) then
		setState("COUNTDOWN")
	end
end

-- ==== Remote-Bindings ====
RequestReadyToggle.OnServerEvent:Connect(function(plr: Player, want: any?)
	-- nur bool oder nil (toggle)
	local wantBool: boolean
	if typeof(want) == "boolean" then
		wantBool = want
	else
		wantBool = not (Ready[plr.UserId] == true)
	end
	markPlayerReady(plr, wantBool)
end)

RequestStartRound.OnServerEvent:Connect(function(plr: Player)
	-- Nur in LOBBY erlaubt und wenn genug Ready
	if RoundState == "LOBBY" and everyoneReadyCount() >= math.max(CFG.MinReadyToStart, 1) then
		setState("COUNTDOWN")
	end
end)

GetRoundState.OnServerInvoke = function(_plr: Player)
	return RoundState
end

-- ==== Player-Lifecycle ====
Players.PlayerAdded:Connect(function(plr)
	Ready[plr.UserId] = false
	Score[plr.UserId] = 0
	broadcastReady(plr, false)
end)

Players.PlayerRemoving:Connect(function(plr)
	Ready[plr.UserId] = nil
	Score[plr.UserId] = nil
	-- Falls LOBBY und jetzt zu wenige ready ➜ bleibt einfach LOBBY.
end)

-- ==== Boot-Log ====
print(("R6V_RoundController bereit: RoundTime=%d, TargetScore=%d, Respawn=%d, FF=%s")
	:format(CFG.RoundTime, CFG.TargetScore, CFG.RespawnTime, tostring(CFG.FriendlyFire)))
print("[R6V_RC] ✅ Events-Ordner gefunden")
print("[R6V_RC] ✅ RequestReadyToggle gefunden")

-- Falls jemand anders setState/markPlayerReady erwartet:
_G.R6V_RoundController = {
	setState = setState,
	markPlayerReady = markPlayerReady
}

-- Start in LOBBY
setState("LOBBY")
