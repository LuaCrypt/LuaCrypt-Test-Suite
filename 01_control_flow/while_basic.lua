-- Test: Basic while loop behavior
local results = {}

-- Test 1: Simple counting
local i = 0
while i < 5 do
    i = i + 1
end
results[#results + 1] = "count=" .. i

-- Test 2: Zero iterations (condition false initially)
local j = 10
local count = 0
while j < 5 do
    count = count + 1
    j = j + 1
end
results[#results + 1] = "zero_iter=" .. count

-- Test 3: Single iteration
local k = 0
local single = 0
while k < 1 do
    single = single + 1
    k = k + 1
end
results[#results + 1] = "single=" .. single

-- Test 4: Accumulator pattern
local sum = 0
local n = 1
while n <= 10 do
    sum = sum + n
    n = n + 1
end
results[#results + 1] = "sum=" .. sum

-- Test 5: Condition with side effect
local counter = 0
local function checkAndInc()
    counter = counter + 1
    return counter <= 3
end
while checkAndInc() do
    -- empty body
end
results[#results + 1] = "side_effect=" .. counter

print(table.concat(results, ","))
-- Expected: count=5,zero_iter=0,single=1,sum=55,side_effect=4
