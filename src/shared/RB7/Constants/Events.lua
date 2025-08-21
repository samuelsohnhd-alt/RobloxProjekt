--!strict
-- RB7: zentrale Event-Konstanten (stabile Schnittstelle)
local Events = {
	ROOT            = "Events",
	VERSION         = "v1",

	-- Core
	PING            = "Ping",

	-- Runden/Match
	ROUND_START     = "RoundStart",
	ROUND_ENDED     = "RoundEnded",
	TIMER_TICK      = "TimerTick",

	-- Profile
	GET_PROFILE     = "GetProfile",
	PROFILE_UPDATED = "ProfileUpdated",

	-- Inputs (Client -> Server)
	SET_ADS         = "SetADS",
	SET_CROUCH      = "SetCrouchState",
	RELOAD          = "ReloadEvent",

	-- PlayerState
	GET_STATE       = "GetState",
	STATE_CHANGED   = "PlayerStateChanged",

	-- Weapons
	EQUIP_WEAPON    = "EquipWeapon",
	SHOOT           = "ShootEvent",
	AMMO_UPDATE     = "AmmoUpdated",
	GET_LOADOUT     = "GetLoadout",

	-- Admin / Diagnostics
	GET_SERVER_STATS = "GetServerStats", -- RemoteFunction (C->S) -> { ok, data|error }
}
return Events
