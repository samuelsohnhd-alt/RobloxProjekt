--!strict
-- Definiert erlaubte Payloads für Events/v1
export type PingPayload       = { t: number }?           -- optional, falls leer gesendet
export type TimerTickPayload  = { t: number }            -- verbleibende Zeit in s
export type RoundStartPayload = { duration: number, endsAt: number }
export type RoundEndedPayload = { reason: string }       -- z.B. "timeup", "score"

local Schema = {}

function Schema.IsPing(p:any): boolean
	if p == nil then return true end
	return type(p)=="table" and type(p.t)=="number"
end

function Schema.IsTimerTick(p:any): boolean
	return type(p)=="table" and type(p.t)=="number"
end

function Schema.IsRoundStart(p:any): boolean
	return type(p)=="table" and type(p.duration)=="number" and type(p.endsAt)=="number"
end

function Schema.IsRoundEnded(p:any): boolean
	return type(p)=="table" and type(p.reason)=="string"
end

return Schema
