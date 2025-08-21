--!strict
-- Basiskonfig für Waffen (vereinfachtes Gerüst)
local W = {}

W.Weapons = {
	FAMAS = { slot="Primary",  magSize=30, reserve=90, rpm=900, burst=false },
	MP5   = { slot="Primary",  magSize=30, reserve=120, rpm=800, burst=false },
	PISTOL= { slot="Secondary",magSize=15, reserve=45, rpm=450, burst=false },
}

W.DefaultLoadout = { Primary="FAMAS", Secondary="PISTOL" }

return W
