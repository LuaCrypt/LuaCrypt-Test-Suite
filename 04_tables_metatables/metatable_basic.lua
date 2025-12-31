-- Test: Basic metatable operations
local results = {}

-- Test 1: Set and get metatable
local t1 = {}
local mt1 = {}
setmetatable(t1, mt1)
results[#results + 1] = "setget=" .. tostring(getmetatable(t1) == mt1)

-- Test 2: Table without metatable
local t2 = {}
results[#results + 1] = "nomt=" .. tostring(getmetatable(t2))

-- Test 3: Protected metatable
local t3 = {}
local mt3 = {__metatable = "protected"}
setmetatable(t3, mt3)
results[#results + 1] = "protected=" .. getmetatable(t3)

-- Test 4: Metatable chaining (via __index)
local base = {x = 10}
local derived = {}
setmetatable(derived, {__index = base})
results[#results + 1] = "chain=" .. derived.x

-- Test 5: Overwrite metatable
local t5 = {}
setmetatable(t5, {tag = "first"})
setmetatable(t5, {tag = "second"})
results[#results + 1] = "overwrite=" .. getmetatable(t5).tag

-- Test 6: Same metatable for multiple tables
local shared_mt = {__index = {shared = 100}}
local t6a = setmetatable({}, shared_mt)
local t6b = setmetatable({}, shared_mt)
results[#results + 1] = "shared=" .. t6a.shared .. ";" .. t6b.shared

print(table.concat(results, ","))
-- Expected: setget=true,nomt=nil,protected=protected,chain=10,overwrite=second,shared=100;100
