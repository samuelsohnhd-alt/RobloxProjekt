-- filepath: src/server/services/TimerPublisher.lua
-- ...existing code...
local TimerPublisher = {}
local _started = false

-- tickEvent: optional, RemoteEvent oder Tabelle mit FireAllClients
function TimerPublisher.Start(roundTime, tickEvent)
    if _started then return end
    _started = true

    local t = roundTime or 300
    spawn(function()
        while _started and t >= 0 do
            if tickEvent and tickEvent.FireAllClients then
                pcall(function() tickEvent:FireAllClients(t) end)
            end
            wait(1)
            t = t - 1
        end
    end)
end

function TimerPublisher.Stop()
    _started = false
end

return TimerPublisher
-- ...existing code...
