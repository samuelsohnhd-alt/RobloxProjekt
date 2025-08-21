--!strict
-- RB7: zentrale Event-Konstanten
local Events = {
	ROOT        = "Events",
	VERSION     = "v1",

	-- Core
	PING        = "Ping",

	-- Runden/Match
	ROUND_START = "RoundStart",    -- RemoteEvent (S->C)
	ROUND_ENDED = "RoundEnded",    -- RemoteEvent (S->C)
	TIMER_TICK  = "TimerTick",     -- RemoteEvent (S->C) payload: { t = number }

	-- Profile
	GET_PROFILE     = "GetProfile",     -- RemoteFunction (C->S) -> Profile
	PROFILE_UPDATED = "ProfileUpdated", -- RemoteEvent (S->C)

	-- Inputs (Client -> Server)
	SET_ADS         = "SetADS",         -- RemoteEvent payload: { on:boolean }
	SET_CROUCH      = "SetCrouchState", -- RemoteEvent payload: { on:boolean }
	RELOAD          = "ReloadEvent",    -- RemoteEvent payload: { }
}
return Events
