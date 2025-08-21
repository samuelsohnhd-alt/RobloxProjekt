--!strict
-- RB7_ServerMain: Stellt Remotes bereit und validiert eingehende Payloads
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players           = game:GetService("Players")

local Build  = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Meta"):WaitForChild("Build"))
local Events = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Constants"):WaitForChild("Events"))
local Schema = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RB7"):WaitForChild("Types"):WaitForChild("RemoteSchema"):WaitForChild("Events_v1"))

local function ensureFolder(parent: Instance, name: string): Folder
	local f = parent:FindFirstChild(name)
	if not f then f = Instance.new("Folder"); f.Name = name; f.Parent = parent end
	return f :: Folder
end
local function ensureRemoteEvent(parent: Instance, name: string): RemoteEvent
	local r = parent:FindFirstChild(name)
	if not r then r = Instance.new("RemoteEvent"); r.Name = name; r.Parent = parent end
	return r :: RemoteEvent
end

-- Pfad: ReplicatedStorage/Shared/Events/v1
local Shared = ensureFolder(ReplicatedStorage, "Shared")
local EventsRoot = ensureFolder(Shared, Events.ROOT)
local V = ensureFolder(EventsRoot, Events.VERSION)

local Ping = ensureRemoteEvent(V, Events.PING)

Ping.OnServerEvent:Connect(function(player: Player, payload)
	if not Schema.IsPing(payload) then
		warn(string.format("[RB7][Ping][SchemaError] Spieler=%s payload invalid", player.Name))
		return
	end
	print(string.format("[RB7][Ping] from %s ok", player.Name))
end)

print(("[RB7_ServerMain] ✅ Remotes bereit unter ReplicatedStorage/Shared/Events/%s • Build %s (Schema=%s)")
	:format(Events.VERSION, Build.Version, Build.SchemaName))
