-- Test: Stack effects with table operations
local results = {}

local function triple()
    return 1, 2, 3
end

-- Test 1: Multiple returns in array literal
local t1 = {triple()}
results[#results + 1] = "array=" .. #t1

-- Test 2: Multiple positions with single
local t2 = {triple(), triple(), triple()}
results[#results + 1] = "multi=" .. #t2  -- 1 + 1 + 3 = 5

-- Test 3: Table insert with multiple returns
local t3 = {}
table.insert(t3, (triple()))  -- Parentheses force single value
results[#results + 1] = "insert=" .. #t3 .. ":" .. t3[1]

-- Test 4: rawset with function return
local t4 = {}
rawset(t4, triple())  -- rawset(t4, 1, 2) - key=1, val=2
results[#results + 1] = "rawset=" .. tostring(t4[1])

-- Test 5: Table as function call result
local function getTable()
    return {a = 1}, {b = 2}
end
local tbl1, tbl2 = getTable()
results[#results + 1] = "tbl_return=" .. tbl1.a .. ";" .. tbl2.b

-- Test 6: Nested table construction
local t5 = {{triple()}, {triple()}}
results[#results + 1] = "nested=" .. #t5[1] .. ";" .. #t5[2]

print(table.concat(results, ","))
-- Expected: array=3,multi=5,insert=1:1,rawset=2,tbl_return=1;2,nested=3;3
