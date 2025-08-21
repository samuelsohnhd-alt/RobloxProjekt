--!strict
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")
local inStudio = RunService:IsStudio()

local Adapter = require(script.Parent:WaitForChild("DataStoreAdapter"))

export type SaveData = {
	equipped: string?,
	ammo: { [string]: { mag:number, reserve:number } }?,
}

local Store = {}
local ds = Adapter.getStore("RB7_LoadoutAmmo")

function Store.get(userId:number): SaveData?
	local key = tostring(userId)
	local ok, result = pcall(function() return ds:GetAsync(key) end)
	if ok then return result else warn("[LoadoutStore:Get] "..tostring(result)); return nil end
end

function Store.set(userId:number, data:SaveData)
	local key = tostring(userId)
	local ok, err = pcall(function() return ds:SetAsync(key, data) end)
	if not ok then warn("[LoadoutStore:Set] "..tostring(err)) end
end

return Store
