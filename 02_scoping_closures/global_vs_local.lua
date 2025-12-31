-- Test: Global vs local variable behavior
local results = {}

-- Test 1: Global assignment
globalVar = 100
results[#results + 1] = "global=" .. globalVar

-- Test 2: Local shadows global
globalVar2 = 50
local globalVar2 = 75  -- Local shadows global
results[#results + 1] = "shadow_global=" .. globalVar2
results[#results + 1] = "actual_global=" .. _G.globalVar2

-- Test 3: Function sees global
globalFunc = 42
local function readGlobal()
    return globalFunc
end
results[#results + 1] = "func_global=" .. readGlobal()

-- Test 4: Modify global from function
globalMod = 1
local function modifyGlobal()
    globalMod = globalMod + 10
end
modifyGlobal()
results[#results + 1] = "mod_global=" .. globalMod

-- Test 5: Local preferred over global
localPref = "global"
local function testPref()
    local localPref = "local"
    return localPref
end
results[#results + 1] = "local_pref=" .. testPref()

-- Test 6: Access global via _G
_G.explicitGlobal = 999
results[#results + 1] = "explicit=" .. explicitGlobal

-- Cleanup
globalVar = nil
globalVar2 = nil
globalFunc = nil
globalMod = nil
localPref = nil
explicitGlobal = nil

print(table.concat(results, ","))
-- Expected: global=100,shadow_global=75,actual_global=50,func_global=42,mod_global=11,local_pref=local,explicit=999
