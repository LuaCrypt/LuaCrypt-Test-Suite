-- Test: Nested repeat-until loops
local results = {}

-- Test 1: Simple nested
local outer = 0
local total = 0
repeat
    outer = outer + 1
    local inner = 0
    repeat
        inner = inner + 1
        total = total + 1
    until inner >= 3
until outer >= 2
results[#results + 1] = "nested=" .. total  -- 2*3=6

-- Test 2: Mixed while and repeat
local a = 0
local b_total = 0
repeat
    a = a + 1
    local b = 0
    while b < a do
        b = b + 1
        b_total = b_total + 1
    end
until a >= 3
results[#results + 1] = "mixed=" .. b_total  -- 1+2+3=6

-- Test 3: Three deep
local d1, d2, d3 = 0, 0, 0
local count3 = 0
repeat
    d1 = d1 + 1
    repeat
        d2 = d2 + 1
        repeat
            d3 = d3 + 1
            count3 = count3 + 1
        until d3 % 2 == 0
        d3 = 0
    until d2 % 2 == 0
    d2 = 0
until d1 >= 2
results[#results + 1] = "three_deep=" .. count3

print(table.concat(results, ","))
-- Expected: nested=6,mixed=6,three_deep=8
