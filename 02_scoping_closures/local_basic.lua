-- Test: Basic local variable scoping
local results = {}

-- Test 1: Simple local
local x = 10
results[#results + 1] = "simple=" .. x

-- Test 2: Local in block
do
    local y = 20
    results[#results + 1] = "block=" .. y
end

-- Test 3: Multiple locals in one declaration
local a, b, c = 1, 2, 3
results[#results + 1] = "multi=" .. a .. ";" .. b .. ";" .. c

-- Test 4: Partial assignment (extras are nil)
local p, q, r = 10, 20
results[#results + 1] = "partial=" .. p .. ";" .. q .. ";" .. tostring(r)

-- Test 5: Local without assignment
local unassigned
results[#results + 1] = "unassigned=" .. tostring(unassigned)

-- Test 6: Reassignment
local v = 1
v = v + 10
v = v * 2
results[#results + 1] = "reassign=" .. v

print(table.concat(results, ","))
-- Expected: simple=10,block=20,multi=1;2;3,partial=10;20;nil,unassigned=nil,reassign=22
