--!strict
-- RB7: zentrale Event-Konstanten
local Events = {
	ROOT        = "Events",
	VERSION     = "v1",

	-- Core
	PING        = "Ping",

	-- Runden/Match
	ROUND_START = "RoundStart",    -- RemoteEvent (Server -> Client)
	ROUND_ENDED = "RoundEnded",    -- RemoteEvent (Server -> Client)
	TIMER_TICK  = "TimerTick",     -- RemoteEvent (Server -> Client), payload: { t = number }

	-- Profile
	GET_PROFILE     = "GetProfile",     -- RemoteFunction (Client -> Server), returns Profile
	PROFILE_UPDATED = "ProfileUpdated", -- RemoteEvent (Server -> Client)
}
return Events
