--!strict
local S = {}
function S.IsEquip(p:any): boolean
	return type(p)=="table" and type(p.name)=="string"
end
function S.IsShoot(p:any): boolean
	return type(p)=="table" and type(p.name)=="string"
end
function S.IsAmmoUpdate(p:any): boolean
	return type(p)=="table" and type(p.name)=="string"
		and type(p.mag)=="number" and type(p.reserve)=="number"
end
return S
