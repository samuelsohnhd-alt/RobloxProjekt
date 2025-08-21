-- RB7 UnlocksDebug – robust gegen Pfadabweichungen
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local function waitPath(root, names, timeout)
  local node = root; local t0 = os.clock(); timeout = timeout or 10
  for _,name in ipairs(names) do
    local child = node:FindFirstChild(name)
    while not child do
      if os.clock() - t0 > timeout then
        warn(("[UnlocksDebug] timeout on path: %s"):format(table.concat(names, "/")))
        return nil
      end
      child = node:FindFirstChild(name) or node:WaitForChild(name, 0.25)
    end
    node = child
  end
  return node
end

-- Offizieller Pfad laut Server: ReplicatedStorage/Shared/Events/v1
local events = waitPath(ReplicatedStorage, {"Shared","Events","v1"}, 8)
if not events then
  warn("[UnlocksDebug] Events/v1 nicht gefunden – Debug deaktiviert.")
  return
end

local RoundTimerTick = events:FindFirstChild("RoundTimerTick")
if not RoundTimerTick or not RoundTimerTick:IsA("RemoteEvent") then
  warn("[UnlocksDebug] RoundTimerTick RemoteEvent fehlt."); return
end

print("[UnlocksDebug] ✅ verbunden mit Events/v1.RoundTimerTick")
-- Beispiel: Lauschen ohne Spam
RoundTimerTick.OnClientEvent:Connect(function(data)
  -- data kann nil/irgendwas sein – nur minimal loggen
  -- print("[UnlocksDebug] Tick", data)
end)
