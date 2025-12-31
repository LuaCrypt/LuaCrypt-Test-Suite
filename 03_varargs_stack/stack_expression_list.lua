-- Test: Expression lists and stack adjustments
local results = {}

local function three()
    return 1, 2, 3
end

local function two()
    return "a", "b"
end

-- Test 1: Expression list in return
local function returnList()
    return 10, three()  -- 10, 1, 2, 3
end
local r1, r2, r3, r4 = returnList()
results[#results + 1] = "return_list=" .. r1 .. ";" .. r2 .. ";" .. r3 .. ";" .. r4

-- Test 2: Expression list middle adjustment
local function middleList()
    return three(), 100  -- 1, 100 (three() adjusted to 1)
end
local m1, m2 = middleList()
results[#results + 1] = "middle_list=" .. m1 .. ";" .. m2

-- Test 3: Function call with expression list
local function sum4(a, b, c, d)
    return (a or 0) + (b or 0) + (c or 0) + (d or 0)
end
results[#results + 1] = "call_list=" .. sum4(10, three())

-- Test 4: Table with expression list
local t1 = {0, three()}  -- {0, 1, 2, 3}
results[#results + 1] = "table_list=" .. #t1

-- Test 5: Assignment with expression list
local a, b, c, d = 0, three()
results[#results + 1] = "assign_list=" .. a .. ";" .. b .. ";" .. c .. ";" .. d

-- Test 6: Nested expression lists
local function nested()
    return two(), three()  -- "a", 1, 2, 3
end
local n1, n2, n3, n4 = nested()
results[#results + 1] = "nested_list=" .. n1 .. ";" .. n2 .. ";" .. n3 .. ";" .. n4

-- Test 7: Parentheses adjust list to single
local function parens()
    return (three()), two()  -- 1, "a", "b"
end
local p1, p2, p3 = parens()
results[#results + 1] = "parens=" .. p1 .. ";" .. p2 .. ";" .. p3

print(table.concat(results, ","))
-- Expected: return_list=10;1;2;3,middle_list=1;100,call_list=16,table_list=4,assign_list=0;1;2;3,nested_list=a;1;2;3,parens=1;a;b
