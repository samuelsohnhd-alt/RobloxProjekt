--!strict
export type PlayerState = {
	userId: number,
	ads: boolean,
	crouch: boolean,
	ammo: number?,
	updatedAt: number,
}

local S = {}
function S.default(userId:number): PlayerState
	return {
		userId   = userId,
		ads      = false,
		crouch   = false,
		ammo     = nil,     -- Platzhalter für Waffensystem
		updatedAt= os.time(),
	}
end
return S
