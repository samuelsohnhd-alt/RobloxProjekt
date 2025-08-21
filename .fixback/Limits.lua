--!strict
-- Raten (tokens/sec) & Burst-Kapazität je RemoteEvent-NAME
return {
	["SetADS"]         = { cap = 8,  rate = 8  },
	["SetCrouchState"] = { cap = 8,  rate = 8  },
	["ReloadEvent"]    = { cap = 2,  rate = 1  },
	["ShootEvent"]     = { cap = 12, rate = 10 },
	["EquipWeapon"]    = { cap = 3,  rate = 2  },
}
