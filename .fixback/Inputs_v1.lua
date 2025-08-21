--!strict
local Inputs = {}

function Inputs.IsSetADS(p:any): boolean
	return type(p)=="table" and type(p.on)=="boolean"
end
function Inputs.IsSetCrouch(p:any): boolean
	return type(p)=="table" and type(p.on)=="boolean"
end
function Inputs.IsReload(p:any): boolean
	return p==nil or type(p)=="table"
end

return Inputs
