-- Test: __index metamethod
local results = {}

-- Test 1: __index as table
local mt1 = {__index = {x = 10, y = 20}}
local t1 = setmetatable({z = 30}, mt1)
results[#results + 1] = "tbl_index=" .. t1.x .. ";" .. t1.z

-- Test 2: __index as function
local mt2 = {
    __index = function(t, k)
        return "default_" .. k
    end
}
local t2 = setmetatable({a = 1}, mt2)
results[#results + 1] = "func_index=" .. t2.a .. ";" .. t2.missing

-- Test 3: Chained __index
local base = {baseVal = 100}
local middle = setmetatable({middleVal = 200}, {__index = base})
local top = setmetatable({topVal = 300}, {__index = middle})
results[#results + 1] = "chain=" .. top.topVal .. ";" .. top.middleVal .. ";" .. top.baseVal

-- Test 4: __index function receives table
local received_table = nil
local mt4 = {
    __index = function(t, k)
        received_table = t
        return t.stored[k]
    end
}
local t4 = setmetatable({stored = {x = 42}}, mt4)
local _ = t4.x
results[#results + 1] = "receives_tbl=" .. tostring(received_table == t4)

-- Test 5: __index not called for existing keys
local mt5_called = false
local mt5 = {
    __index = function()
        mt5_called = true
        return "fallback"
    end
}
local t5 = setmetatable({existing = "value"}, mt5)
local _ = t5.existing
results[#results + 1] = "existing_skip=" .. tostring(mt5_called)

-- Test 6: Recursive __index lookup
local level1 = {l1 = 1}
local level2 = setmetatable({l2 = 2}, {__index = level1})
local level3 = setmetatable({l3 = 3}, {__index = level2})
results[#results + 1] = "recursive=" .. level3.l1 .. ";" .. level3.l2 .. ";" .. level3.l3

print(table.concat(results, ","))
-- Expected: tbl_index=10;30,func_index=1;default_missing,chain=300;200;100,receives_tbl=true,existing_skip=false,recursive=1;2;3
