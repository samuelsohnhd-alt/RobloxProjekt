-- filepath: (auto) multiple possible UI stub paths
-- Minimal stub, verhindert Fehler wenn Components/init.lua fehlt.
local Components = {}

function Components.Register(name, module)
    Components[name] = module
end

function Components.Get(name)
    return Components[name]
end

return Components
