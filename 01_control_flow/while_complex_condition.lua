-- Test: Complex conditions in while loops
local results = {}

-- Test 1: AND in condition
local a, b = 0, 0
while a < 5 and b < 3 do
    a = a + 1
    b = b + 1
end
results[#results + 1] = "and_a=" .. a .. "_b=" .. b

-- Test 2: OR in condition
local c, d = 0, 0
while c < 2 or d < 4 do
    c = c + 1
    d = d + 1
end
results[#results + 1] = "or_c=" .. c .. "_d=" .. d

-- Test 3: Function call in condition
local counter = 0
local function shouldContinue()
    return counter < 5
end
while shouldContinue() do
    counter = counter + 1
end
results[#results + 1] = "func=" .. counter

-- Test 4: Table field in condition
local state = {active = true, count = 0}
while state.active do
    state.count = state.count + 1
    if state.count >= 4 then
        state.active = false
    end
end
results[#results + 1] = "table=" .. state.count

-- Test 5: Comparison with nil
local list = {1, 2, 3, nil, 5}
local idx = 0
local collected = {}
while list[idx + 1] ~= nil do
    idx = idx + 1
    collected[#collected + 1] = list[idx]
end
results[#results + 1] = "nil_check=" .. table.concat(collected, ";")

print(table.concat(results, ","))
-- Expected: and_a=3_b=3,or_c=4_d=4,func=5,table=4,nil_check=1;2;3
