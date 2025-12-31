-- Test: Basic repeat-until loops
local results = {}

-- Test 1: Simple repeat (at least one iteration)
local i = 0
repeat
    i = i + 1
until i >= 5
results[#results + 1] = "simple=" .. i

-- Test 2: Condition true immediately (still runs once)
local j = 100
local runs = 0
repeat
    runs = runs + 1
until j > 50  -- True from start, but body runs once
results[#results + 1] = "once=" .. runs

-- Test 3: Variable declared in body visible in condition
local k = 0
repeat
    k = k + 1
    local stop = k >= 3
until stop
results[#results + 1] = "scoped=" .. k

-- Test 4: Multiple conditions
local a, b = 0, 0
repeat
    a = a + 1
    b = b + 2
until a >= 3 or b >= 10
results[#results + 1] = "multi_a=" .. a .. "_b=" .. b

print(table.concat(results, ","))
-- Expected: simple=5,once=1,scoped=3,multi_a=3_b=6
