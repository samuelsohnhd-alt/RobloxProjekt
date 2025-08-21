--!strict
export type Profile = {
	userId: number,
	name: string,
	xp: number,
	rank: number,
	createdAt: number,
	updatedAt: number,
}
local T = {}
function T.default(userId:number, name:string): Profile
	return {
		userId = userId,
		name = name,
		xp = 0,
		rank = 1,
		createdAt = os.time(),
		updatedAt = os.time(),
	}
end
return T
