-- Test: Break in generic for loops
local results = {}

-- Test 1: Break in pairs
local t = {a = 1, b = 2, c = 3, d = 4, e = 5}
local count = 0
for k, v in pairs(t) do
    count = count + 1
    if count >= 3 then break end
end
results[#results + 1] = "pairs_break=" .. count

-- Test 2: Break in ipairs
local arr = {10, 20, 30, 40, 50}
local sum = 0
for i, v in ipairs(arr) do
    sum = sum + v
    if sum >= 50 then break end
end
results[#results + 1] = "ipairs_break=" .. sum

-- Test 3: Break in custom iterator
local function range(n)
    local i = 0
    return function()
        i = i + 1
        if i <= n then return i end
    end
end

local last = 0
for v in range(100) do
    last = v
    if v == 7 then break end
end
results[#results + 1] = "custom_break=" .. last

-- Test 4: Break in nested generic for
local outer_count = 0
local inner_count = 0
local t1 = {a = 1, b = 2, c = 3}
local t2 = {x = 10, y = 20, z = 30}
for k1, v1 in pairs(t1) do
    outer_count = outer_count + 1
    for k2, v2 in pairs(t2) do
        inner_count = inner_count + 1
        if inner_count >= 2 then break end
    end
    if outer_count >= 2 then break end
end
results[#results + 1] = "nested=" .. outer_count .. ":" .. inner_count

-- Test 5: Conditional break
local arr2 = {5, 10, 15, 20, 25}
local found = nil
for i, v in ipairs(arr2) do
    if v > 12 then
        found = v
        break
    end
end
results[#results + 1] = "found=" .. tostring(found)

print(table.concat(results, ","))
-- Expected: pairs_break=3,ipairs_break=60,custom_break=7,nested=2:4,found=15
