--!strict
-- Trage hier deine UserIds ein, um Admin-RF nutzen zu können.
-- Beispiel: [123456]=true
local Admins:{[number]:boolean} = {
}
function Admins.isAdmin(userId:number): boolean
	return Admins[userId] == true
end
return Admins
