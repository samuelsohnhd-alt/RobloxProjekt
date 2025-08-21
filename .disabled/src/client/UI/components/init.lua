-- filepath: (auto) UI stub
local Components = {}
function Components.Register(name, module) Components[name] = module end
function Components.Get(name) return Components[name] end
return Components
