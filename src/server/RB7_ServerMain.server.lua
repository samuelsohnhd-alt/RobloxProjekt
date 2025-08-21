--!strict
-- RB7_ServerMain: sorgt dafür, dass Remotes existieren und reagiert auf Ping
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players           = game:GetService("Players")

local Events = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Constants"):WaitForChild("Events"))

local function ensureFolder(parent: Instance, name: string): Folder
	local f = parent:FindFirstChild(name)
	if not f then
		f = Instance.new("Folder")
		f.Name = name
		f.Parent = parent
	end
	return f :: Folder
end

local function ensureRemoteEvent(parent: Instance, name: string): RemoteEvent
	local r = parent:FindFirstChild(name)
	if not r then
		r = Instance.new("RemoteEvent")
		r.Name = name
		r.Parent = parent
	end
	return r :: RemoteEvent
end

-- Pfad: ReplicatedStorage/Shared/Events/v1
local Shared = ensureFolder(ReplicatedStorage, "Shared")
local EventsRoot = ensureFolder(Shared, Events.ROOT)
local V = ensureFolder(EventsRoot, Events.VERSION)

local Ping = ensureRemoteEvent(V, Events.PING)

-- Einfache Echo-Logik als Lebenszeichen
Ping.OnServerEvent:Connect(function(player: Player, payload)
	print(string.format("[RB7][Ping] from %s payload=%s", player.Name, typeof(payload) == "table" and "table" or tostring(payload)))
	-- optional: Server könnte hier antworten (RemoteEvent Server->Client wäre ein separates Event)
end)

print("[RB7_ServerMain] ✅ Remotes bereit unter ReplicatedStorage/Shared/Events/"..Events.VERSION)
