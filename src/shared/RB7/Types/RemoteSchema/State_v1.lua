--!strict
local State = {}
function State.IsStatePayload(p:any): boolean
	return type(p)=="table"
		and type(p.userId)=="number"
		and type(p.state)=="table"
end
return State
