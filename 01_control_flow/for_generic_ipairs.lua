-- Test: Generic for with ipairs()
local results = {}

-- Test 1: Simple array iteration
local arr = {10, 20, 30, 40, 50}
local sum = 0
local indices = {}
for i, v in ipairs(arr) do
    indices[#indices + 1] = i
    sum = sum + v
end
results[#results + 1] = "ipairs=" .. table.concat(indices, ";") .. "_sum=" .. sum

-- Test 2: Stops at first nil
local sparse = {1, 2, nil, 4, 5}
local count = 0
for i, v in ipairs(sparse) do
    count = count + 1
end
results[#results + 1] = "nil_stop=" .. count  -- Stops at index 3

-- Test 3: Empty array
local empty_count = 0
for i, v in ipairs({}) do
    empty_count = empty_count + 1
end
results[#results + 1] = "empty=" .. empty_count

-- Test 4: Single element
local single = {42}
local single_sum = 0
for i, v in ipairs(single) do
    single_sum = single_sum + v
end
results[#results + 1] = "single=" .. single_sum

-- Test 5: Ignores hash part
local mixed = {10, 20, 30, x = 100, y = 200}
local ipairs_sum = 0
for i, v in ipairs(mixed) do
    ipairs_sum = ipairs_sum + v
end
results[#results + 1] = "hash_ignored=" .. ipairs_sum  -- 10+20+30=60

print(table.concat(results, ","))
-- Expected: ipairs=1;2;3;4;5_sum=150,nil_stop=2,empty=0,single=42,hash_ignored=60
