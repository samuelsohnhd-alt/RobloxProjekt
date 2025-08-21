--!strict
-- Einfacher Token-Bucket pro (userId,key)
local RateLimiter = {}
local buckets:{[number]:{[string]:{t:number,tokens:number}}} = {}

local function refill(b:{t:number,tokens:number}, now:number, rate:number, cap:number)
	local elapsed = math.max(0, now - b.t)
	b.tokens = math.min(cap, b.tokens + elapsed * rate)
	b.t = now
end

function RateLimiter.check(userId:number, key:string, cap:number, rate:number): boolean
	local u = buckets[userId]; if not u then u = {}; buckets[userId] = u end
	local b = u[key]; local now = os.clock()
	if not b then b = { t = now, tokens = cap }; u[key] = b end
	refill(b, now, rate, cap)
	if b.tokens >= 1 then b.tokens -= 1; return true end
	return false
end

return RateLimiter
