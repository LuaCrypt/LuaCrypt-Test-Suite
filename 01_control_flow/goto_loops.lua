-- Test: Goto for loop control (continue pattern)
local results = {}

-- Test 1: Continue pattern in while
local sum1 = 0
local i = 0
while i < 10 do
    i = i + 1
    if i % 2 == 0 then
        goto continue1
    end
    sum1 = sum1 + i
    ::continue1::
end
results[#results + 1] = "while_continue=" .. sum1  -- odd numbers: 1+3+5+7+9=25

-- Test 2: Continue pattern in for
local sum2 = 0
for j = 1, 10 do
    if j % 3 == 0 then
        goto continue2
    end
    sum2 = sum2 + j
    ::continue2::
end
results[#results + 1] = "for_continue=" .. sum2  -- skip 3,6,9: 1+2+4+5+7+8+10=37

-- Test 3: Break-like pattern with goto
local sum3 = 0
for k = 1, 100 do
    sum3 = sum3 + k
    if sum3 > 50 then
        goto break_loop
    end
end
::break_loop::
results[#results + 1] = "goto_break=" .. sum3

-- Test 4: Retry pattern
local attempts = 0
local success = false
::retry::
attempts = attempts + 1
if attempts < 3 then
    goto retry
end
success = true
results[#results + 1] = "retry=" .. attempts .. "_" .. tostring(success)

-- Test 5: Multi-level break simulation
local outer_done = false
local iterations = 0
for a = 1, 5 do
    for b = 1, 5 do
        iterations = iterations + 1
        if a * b > 6 then
            goto outer_break
        end
    end
end
::outer_break::
results[#results + 1] = "multi_break=" .. iterations

print(table.concat(results, ","))
-- Expected: while_continue=25,for_continue=37,goto_break=55,retry=3_true,multi_break=8
