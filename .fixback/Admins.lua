--!strict
-- Admin-Allowlist: numerische IDs & Fallback über Username
local Admins = {}

Admins.IDs = {
  [9195365111] = true,
}

Admins.Usernames = {
  ["RorsTheGod"] = true,
}

function Admins.isAdmin(userId:number, playerName:string?)
  if Admins.IDs[userId] then return true end
  if playerName and Admins.Usernames[playerName] then return true end
  return false
end

return Admins
