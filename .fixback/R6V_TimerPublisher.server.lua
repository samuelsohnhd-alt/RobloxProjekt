-- INIT-GUARD (automatically added) - verhindert doppelte Initialisierung
do
    if _G.RB7_InitGuard == nil then _G.RB7_InitGuard = {} end
    local ok,name = pcall(function() return (script and (pcall(function() return script:GetFullName() end) and script:GetFullName())) end)
    local id = "RB7_GUARD_" .. tostring((ok and name) or (script and script.Name) or tostring(debug.getinfo(1).source))
    if _G.RB7_InitGuard[id] then return end
    _G.RB7_InitGuard[id] = true
end

--!strict
-- R6V_TimerPublisher.server.lua
-- Robuster Runden-Timer Publisher (ersetzt fehlerhafte Zuweisungen wie "RoundTime: 300")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")

-- Fallback-Konfiguration
local ROUND_TIME_SECONDS: number = 300

-- Optional: GameConfig laden, falls vorhanden
do
	local Modules = ReplicatedStorage:FindFirstChild("Modules")
	if Modules and Modules:FindFirstChild("Shared") then
		local Config = Modules.Shared:FindFirstChild("Config")
		if Config and Config:FindFirstChild("GameConfig") and Config.GameConfig:IsA("ModuleScript") then
			local ok, cfg = pcall(require, Config.GameConfig)
			if ok and type(cfg) == "table" and tonumber(cfg.RoundTime) then
				ROUND_TIME_SECONDS = tonumber(cfg.RoundTime) :: number
			end
		end
	end
end

-- Events/v1 Pfad sicherstellen
local Events = ReplicatedStorage:FindFirstChild("Events")
if not Events then
	Events = Instance.new("Folder")
	Events.Name = "Events"
	Events.Parent = ReplicatedStorage
end

local v1 = Events:FindFirstChild("v1")
if not v1 then
	v1 = Instance.new("Folder")
	v1.Name = "v1"
	v1.Parent = Events
end

local RoundTimeUpdated = v1:FindFirstChild("RoundTimeUpdated")
if not RoundTimeUpdated then
	RoundTimeUpdated = Instance.new("RemoteEvent")
	RoundTimeUpdated.Name = "RoundTimeUpdated"
	RoundTimeUpdated.Parent = v1
end

-- Timer-Logik
local startClock = os.clock()
local lastSent = -1

local function getRemainingSeconds(): number
	local elapsed = os.clock() - startClock
	local remaining = ROUND_TIME_SECONDS - math.floor(elapsed)
	if remaining < 0 then remaining = 0 end
	return remaining
end

-- Initial push
RoundTimeUpdated:FireAllClients(getRemainingSeconds())

-- Herzschlag: nur senden, wenn sich der Sekundenwert ändert
RunService.Heartbeat:Connect(function()
	local remaining = getRemainingSeconds()
	if remaining ~= lastSent then
		lastSent = remaining
		RoundTimeUpdated:FireAllClients(remaining)
		if remaining == 0 then
			-- Hier könnte man eine neue Runde triggern o. Ä.
		end
	end
end)

print(("[R6V_TimerPublisher] ✅ läuft. RoundTime=%d s"):format(ROUND_TIME_SECONDS))
