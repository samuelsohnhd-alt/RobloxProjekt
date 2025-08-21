--!strict
local RunService = game:GetService("RunService")
local DataStoreService = game:GetService("DataStoreService")
local inStudio = RunService:IsStudio()
local Store = {}
local mem:any = {}

function Store.getStore(name:string)
	if inStudio then
		mem[name] = mem[name] or {}
		local ns = mem[name]
		return {
			GetAsync = function(_, key:string) return ns[key] end,
			SetAsync = function(_, key:string, value:any) ns[key]=value return true end,
		}
	else
		local ds = DataStoreService:GetDataStore(name)
		return {
			GetAsync = function(_, key:string) return ds:GetAsync(key) end,
			SetAsync = function(_, key:string, value:any) return ds:SetAsync(key, value) end,
		}
	end
end

return Store
