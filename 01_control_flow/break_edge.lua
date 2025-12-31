-- Test: Edge cases for break
local results = {}

-- Test 1: Break as first statement in loop body
local count1 = 0
for i = 1, 100 do
    if true then break end
    count1 = count1 + 1
end
results[#results + 1] = "first=" .. count1

-- Test 2: Break after continue-like pattern
local sum = 0
for i = 1, 10 do
    if i % 2 == 0 then
        -- skip even (continue-like)
    else
        sum = sum + i
        if sum > 10 then break end
    end
end
results[#results + 1] = "continue_like=" .. sum

-- Test 3: Break in single-iteration loop
local single = 0
for i = 1, 1 do
    single = single + 1
    break
end
results[#results + 1] = "single=" .. single

-- Test 4: Multiple breaks (only first reached)
local multi = 0
for i = 1, 10 do
    multi = i
    if i == 3 then break end
    if i == 5 then break end
    if i == 7 then break end
end
results[#results + 1] = "multi=" .. multi

print(table.concat(results, ","))
-- Expected: first=0,continue_like=16,single=1,multi=3
