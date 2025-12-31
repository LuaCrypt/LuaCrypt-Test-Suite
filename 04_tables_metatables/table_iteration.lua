-- Test: Table iteration patterns
local results = {}

-- Test 1: pairs iteration (all keys)
local t1 = {a = 1, b = 2, [1] = 10, [2] = 20}
local keys = {}
for k, v in pairs(t1) do
    keys[#keys + 1] = tostring(k)
end
table.sort(keys)
results[#results + 1] = "pairs=" .. table.concat(keys, ";")

-- Test 2: ipairs iteration (sequential integer keys)
local t2 = {10, 20, 30, x = 100}
local vals = {}
for i, v in ipairs(t2) do
    vals[#vals + 1] = v
end
results[#results + 1] = "ipairs=" .. table.concat(vals, ";")

-- Test 3: next() manually
local t3 = {a = 1, b = 2}
local k1, v1 = next(t3)
local k2, v2 = next(t3, k1)
local k3, v3 = next(t3, k2)
results[#results + 1] = "next=" .. tostring(k3)  -- Should be nil

-- Test 4: ipairs stops at first nil
local t4 = {1, 2, nil, 4, 5}
local count = 0
for i, v in ipairs(t4) do
    count = count + 1
end
results[#results + 1] = "nil_stop=" .. count

-- Test 5: Numeric for loop
local t5 = {10, 20, 30, 40, 50}
local sum = 0
for i = 1, #t5 do
    sum = sum + t5[i]
end
results[#results + 1] = "numeric=" .. sum

-- Test 6: Reverse iteration
local t6 = {1, 2, 3, 4, 5}
local rev = {}
for i = #t6, 1, -1 do
    rev[#rev + 1] = t6[i]
end
results[#results + 1] = "reverse=" .. table.concat(rev, ";")

print(table.concat(results, ","))
-- Expected: pairs=1;2;a;b,ipairs=10;20;30,next=nil,nil_stop=2,numeric=150,reverse=5;4;3;2;1
