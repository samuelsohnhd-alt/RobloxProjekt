local Store, Http = {}, game:GetService("HttpService")
local _s, _e = {}, Instance.new("BindableEvent")
function Store.get(k,d) return _s[k]==nil and d or _s[k] end
function Store.set(k,v) local o=_s[k]; _s[k]=v; _e:Fire(k,o,v) end
function Store.toggle(k,a,b) local c=Store.get(k,a); Store.set(k, c==a and b or a) end
function Store.changed(cb) return _e.Event:Connect(cb) end
function Store.snapshot() return Http:JSONDecode(Http:JSONEncode(_s)) end
if _s._init~=true then _s._init=true; _s.showFPS=true; _s.showPing=true end
return Store
