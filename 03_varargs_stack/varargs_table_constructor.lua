-- Test: Varargs in table constructors
local results = {}

-- Test 1: Varargs as only element - all captured
local function allInTable(...)
    return {...}
end
local t1 = allInTable(1, 2, 3)
results[#results + 1] = "all=" .. #t1

-- Test 2: Varargs at end - all captured
local function endOfTable(first, ...)
    return {first, ...}
end
local t2 = endOfTable(100, 200, 300)
results[#results + 1] = "end=" .. table.concat(t2, ";")

-- Test 3: Varargs not at end - only first captured
local function middleOfTable(...)
    return {..., "last"}
end
local t3 = middleOfTable(1, 2, 3)
results[#results + 1] = "middle=" .. table.concat(t3, ";")

-- Test 4: Function call (returning multiple) at end
local function returnThree()
    return 1, 2, 3
end
local t4 = {returnThree()}
results[#results + 1] = "call_end=" .. #t4

-- Test 5: Function call not at end - only first
local t5 = {returnThree(), "after"}
results[#results + 1] = "call_middle=" .. table.concat(t5, ";")

-- Test 6: Multiple function calls
local function returnTwo()
    return "a", "b"
end
local t6 = {returnTwo(), returnThree()}
results[#results + 1] = "multi_call=" .. table.concat(t6, ";")

print(table.concat(results, ","))
-- Expected: all=3,end=100;200;300,middle=1;last,call_end=3,call_middle=1;after,multi_call=a;1;2;3
