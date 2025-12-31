-- Test: rawequal function
local results = {}

-- Test 1: Same table
local t1 = {}
results[#results + 1] = "same=" .. tostring(rawequal(t1, t1))

-- Test 2: Different tables
local t2 = {}
local t3 = {}
results[#results + 1] = "diff=" .. tostring(rawequal(t2, t3))

-- Test 3: rawequal bypasses __eq
local mt = {
    __eq = function() return true end  -- Always equal
}
local t4 = setmetatable({}, mt)
local t5 = setmetatable({}, mt)
results[#results + 1] = "meta=" .. tostring(t4 == t5) .. ":" .. tostring(rawequal(t4, t5))

-- Test 4: With primitives
results[#results + 1] = "num=" .. tostring(rawequal(5, 5))
results[#results + 1] = "str=" .. tostring(rawequal("a", "a"))
results[#results + 1] = "bool=" .. tostring(rawequal(true, true))

-- Test 5: nil comparison
results[#results + 1] = "nil=" .. tostring(rawequal(nil, nil))

-- Test 6: Different types
results[#results + 1] = "types=" .. tostring(rawequal(1, "1"))

-- Test 7: Function identity
local f1 = function() end
local f2 = function() end
results[#results + 1] = "func_same=" .. tostring(rawequal(f1, f1))
results[#results + 1] = "func_diff=" .. tostring(rawequal(f1, f2))

print(table.concat(results, ","))
-- Expected: same=true,diff=false,meta=true:false,num=true,str=true,bool=true,nil=true,types=false,func_same=true,func_diff=false
