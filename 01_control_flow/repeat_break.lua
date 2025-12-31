-- Test: Break in repeat-until loops
local results = {}

-- Test 1: Break before condition
local i = 0
repeat
    i = i + 1
    if i == 3 then
        break
    end
until i >= 10
results[#results + 1] = "break=" .. i

-- Test 2: Break with false condition
local j = 0
repeat
    j = j + 1
    if j == 5 then
        break
    end
until false  -- Would loop forever without break
results[#results + 1] = "infinite=" .. j

-- Test 3: Nested repeat with break
local outer = 0
local inner_total = 0
repeat
    outer = outer + 1
    local inner = 0
    repeat
        inner = inner + 1
        inner_total = inner_total + 1
        if inner >= 2 then
            break
        end
    until inner >= 10
until outer >= 3
results[#results + 1] = "nested=" .. inner_total

-- Test 4: Break in complex condition block
local k = 0
repeat
    k = k + 1
    if k > 2 then
        if k > 4 then
            break
        end
    end
until k >= 100
results[#results + 1] = "complex=" .. k

print(table.concat(results, ","))
-- Expected: break=3,infinite=5,nested=6,complex=5
