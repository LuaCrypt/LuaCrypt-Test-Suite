-- Test: Break in numeric for loops
local results = {}

-- Test 1: Simple break
local last = 0
for i = 1, 100 do
    last = i
    if i == 5 then break end
end
results[#results + 1] = "simple=" .. last

-- Test 2: Break with descending loop
local desc_last = 0
for i = 10, 1, -1 do
    desc_last = i
    if i == 7 then break end
end
results[#results + 1] = "desc=" .. desc_last

-- Test 3: Break in else
local else_last = 0
for i = 1, 100 do
    else_last = i
    if i < 3 then
        -- continue
    else
        break
    end
end
results[#results + 1] = "else=" .. else_last

-- Test 4: Conditional break with accumulator
local sum = 0
for i = 1, 100 do
    sum = sum + i
    if sum > 50 then break end
end
results[#results + 1] = "accum=" .. sum

-- Test 5: Break after complex condition
local complex_last = 0
for i = 1, 100 do
    complex_last = i
    if i > 3 and i % 2 == 0 and i < 10 then break end
end
results[#results + 1] = "complex=" .. complex_last

-- Test 6: Multiple potential break points (first wins)
local first_break = 0
for i = 1, 100 do
    first_break = i
    if i == 5 then break end
    if i == 10 then break end
end
results[#results + 1] = "first=" .. first_break

print(table.concat(results, ","))
-- Expected: simple=5,desc=7,else=3,accum=55,complex=4,first=5
