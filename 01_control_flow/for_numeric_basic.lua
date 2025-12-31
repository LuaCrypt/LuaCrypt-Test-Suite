-- Test: Basic numeric for loops
local results = {}

-- Test 1: Simple ascending
local sum = 0
for i = 1, 5 do
    sum = sum + i
end
results[#results + 1] = "asc=" .. sum  -- 1+2+3+4+5=15

-- Test 2: With step
local sum2 = 0
for i = 0, 10, 2 do
    sum2 = sum2 + i
end
results[#results + 1] = "step=" .. sum2  -- 0+2+4+6+8+10=30

-- Test 3: Descending
local sum3 = 0
for i = 5, 1, -1 do
    sum3 = sum3 + i
end
results[#results + 1] = "desc=" .. sum3  -- 5+4+3+2+1=15

-- Test 4: Single iteration
local count = 0
for i = 1, 1 do
    count = count + 1
end
results[#results + 1] = "single=" .. count

-- Test 5: Zero iterations (start > end, positive step)
local zero = 0
for i = 10, 1 do
    zero = zero + 1
end
results[#results + 1] = "zero_pos=" .. zero

-- Test 6: Zero iterations (start < end, negative step)
local zero2 = 0
for i = 1, 10, -1 do
    zero2 = zero2 + 1
end
results[#results + 1] = "zero_neg=" .. zero2

print(table.concat(results, ","))
-- Expected: asc=15,step=30,desc=15,single=1,zero_pos=0,zero_neg=0
