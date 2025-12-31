-- Test: getmetatable and setmetatable
local results = {}

-- Test 1: Basic setmetatable/getmetatable
local t1 = {}
local mt1 = {__index = {x = 10}}
setmetatable(t1, mt1)
results[#results + 1] = "set_get=" .. tostring(getmetatable(t1) == mt1)

-- Test 2: getmetatable on table without metatable
local t2 = {}
results[#results + 1] = "no_mt=" .. tostring(getmetatable(t2))

-- Test 3: Remove metatable
local t3 = setmetatable({}, {})
setmetatable(t3, nil)
results[#results + 1] = "remove=" .. tostring(getmetatable(t3))

-- Test 4: __metatable protection
local t4 = setmetatable({}, {__metatable = "protected"})
results[#results + 1] = "protected=" .. getmetatable(t4)

-- Test 5: setmetatable returns the table
local t5 = {}
local returned = setmetatable(t5, {})
results[#results + 1] = "returns=" .. tostring(returned == t5)

-- Test 6: Chain metatables
local base = {base_val = "base"}
local derived = setmetatable({derived_val = "derived"}, {__index = base})
local obj = setmetatable({}, {__index = derived})
results[#results + 1] = "chain=" .. obj.base_val .. ":" .. obj.derived_val

-- Test 7: String metatable
local str_mt = getmetatable("")
results[#results + 1] = "str_mt=" .. (str_mt and "exists" or "nil")

-- Test 8: Number has no metatable
results[#results + 1] = "num_mt=" .. tostring(getmetatable(42))

-- Test 9: Function has no metatable
results[#results + 1] = "func_mt=" .. tostring(getmetatable(function() end))

-- Test 10: Change metatable
local t10 = setmetatable({}, {name = "first"})
setmetatable(t10, {name = "second"})
results[#results + 1] = "change=" .. getmetatable(t10).name

-- Test 11: Shared metatable
local mt11 = {__index = {shared = true}}
local t11a = setmetatable({}, mt11)
local t11b = setmetatable({}, mt11)
results[#results + 1] = "shared=" .. tostring(getmetatable(t11a) == getmetatable(t11b))

-- Test 12: Metatable with multiple metamethods
local t12 = setmetatable({val = 5}, {
    __index = {default = 10},
    __tostring = function(t) return "val:" .. t.val end,
    __add = function(a, b) return a.val + b.val end
})
local t12b = setmetatable({val = 3}, getmetatable(t12))
results[#results + 1] = "multi=" .. tostring(t12) .. ":" .. (t12 + t12b)

print(table.concat(results, ","))
-- Expected: set_get=true,no_mt=nil,remove=nil,protected=protected,returns=true,chain=base:derived,str_mt=exists,num_mt=nil,func_mt=nil,change=second,shared=true,multi=val:5:8
