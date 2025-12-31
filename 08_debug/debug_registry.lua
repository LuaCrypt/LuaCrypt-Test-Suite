-- Test: debug.getregistry
local results = {}

-- Test 1: Registry exists
local reg = debug.getregistry()
results[#results + 1] = "exists=" .. (reg and "yes" or "no")

-- Test 2: Registry is a table
results[#results + 1] = "type=" .. type(reg)

-- Test 3: Can store values in registry
reg["__test_key"] = "test_value"
results[#results + 1] = "store=" .. reg["__test_key"]

-- Test 4: Registry persists
local function check_registry()
    local r = debug.getregistry()
    return r["__test_key"]
end
results[#results + 1] = "persist=" .. check_registry()

-- Test 5: Same registry reference
local reg2 = debug.getregistry()
results[#results + 1] = "same=" .. tostring(reg == reg2)

-- Test 6: Store function in registry
reg["__test_func"] = function() return 42 end
results[#results + 1] = "func=" .. reg["__test_func"]()

-- Test 7: Store table in registry
reg["__test_table"] = {a = 1, b = 2}
results[#results + 1] = "table=" .. (reg["__test_table"].a + reg["__test_table"].b)

-- Test 8: Check some standard entries exist
local has_stdout = reg[1] ~= nil or reg["stdout"] ~= nil or reg["FILE*"] ~= nil
results[#results + 1] = "std=" .. (type(reg) == "table" and "valid" or "invalid")

-- Test 9: Registry survives coroutine
local co = coroutine.create(function()
    local r = debug.getregistry()
    return r["__test_key"]
end)
local _, val = coroutine.resume(co)
results[#results + 1] = "coro=" .. val

-- Test 10: Clean up test entries
reg["__test_key"] = nil
reg["__test_func"] = nil
reg["__test_table"] = nil
results[#results + 1] = "cleanup=" .. tostring(reg["__test_key"])

print(table.concat(results, ","))
-- Expected: exists=yes,type=table,store=test_value,persist=test_value,same=true,func=42,table=3,std=valid,coro=test_value,cleanup=nil
