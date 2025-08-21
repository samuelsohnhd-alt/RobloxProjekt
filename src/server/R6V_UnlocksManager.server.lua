--[[
  RB7: R6V_UnlocksManager (server)
  Fix: Verhindert "attempt to call a nil value" mit stabilem Tabellen-API
       und __call-Guard. Stubs sind defensiv & idempotent.
]]
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local UnlocksManager = {
    _initialized = false,
    _profiles = {},
}

function UnlocksManager.Init()
    if UnlocksManager._initialized then return end
    UnlocksManager._initialized = true

    local Events = ReplicatedStorage:FindFirstChild("Events")
    if Events then
        local V1 = Events:FindFirstChild("v1")
        if V1 then
            local GrantXP = V1:FindFirstChild("GrantXP")
            if GrantXP and GrantXP:IsA("RemoteEvent") then
                GrantXP.OnServerEvent:Connect(function(plr, amount)
                    if typeof(amount) ~= "number" then
                        warn("[UnlocksManager] GrantXP: amount ungültig", amount)
                        return
                    end
                    UnlocksManager:AddXP(plr, amount)
                end)
            end
        end
    end

    Players.PlayerAdded:Connect(function(p)
        UnlocksManager:_ensureProfile(p)
    end)
    Players.PlayerRemoving:Connect(function(p)
        UnlocksManager._profiles[p] = nil
    end)

    print("[R6V_UnlocksManager] ✅ Init abgeschlossen")
end

function UnlocksManager:_ensureProfile(player)
    self._profiles[player] = self._profiles[player] or { xp = 0, unlocks = {} }
    return self._profiles[player]
end

function UnlocksManager:AddXP(player, amount)
    local prof = self:_ensureProfile(player)
    prof.xp = math.max(0, (prof.xp or 0) + amount)
    return prof.xp
end

function UnlocksManager:HasUnlock(player, key)
    local prof = self:_ensureProfile(player)
    return prof.unlocks[key] == true
end

function UnlocksManager:GrantUnlock(player, key)
    local prof = self:_ensureProfile(player)
    prof.unlocks[key] = true
    return true
end

setmetatable(UnlocksManager, {
    __call = function(_, ...)
        warn("[R6V_UnlocksManager] Hinweis: Script als Funktion aufgerufen – gebe Manager-Tabelle zurück.")
        return UnlocksManager
    end
})

UnlocksManager.Init()
_G.RB7_UnlocksManager = UnlocksManager
