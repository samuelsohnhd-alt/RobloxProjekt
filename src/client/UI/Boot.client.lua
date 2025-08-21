-- filepath: (auto) safe client Boot wrapper
do
  if _G.RB7_InitGuard == nil then _G.RB7_InitGuard = {} end
  local id = "RB7_GUARD_BOOT_" .. tostring(script and (pcall(function() return script:GetFullName() end) and script:GetFullName()) or tostring(math.random()))
  if _G.RB7_InitGuard[id] then return end
  _G.RB7_InitGuard[id] = true

  local function safeRequire(inst)
    if typeof(inst) ~= "Instance" or inst.ClassName ~= "ModuleScript" then return nil end
    local ok,res = pcall(function() return require(inst) end)
    if ok then return res end
    return nil
  end

  local parent = script.Parent or workspace
  local candidates = { parent:FindFirstChild("App"), parent:FindFirstChild("App.client"), parent:FindFirstChild("AppModule"), parent:FindFirstChild("App.lua") }
  for _,c in ipairs(candidates) do
    local mod = c and safeRequire(c)
    if mod and type(mod) == "table" and mod.Init then
      pcall(function() mod.Init() end)
      print("[RB7_UI] App Init via safe wrapper")
      return
    end
  end
  print("[RB7_UI] no valid App module found (safe wrapper)")
end
