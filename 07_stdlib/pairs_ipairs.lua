-- Test: pairs and ipairs iteration
local results = {}

-- Test 1: Basic ipairs
local t1 = {"a", "b", "c"}
local ipairs_result = {}
for i, v in ipairs(t1) do
    ipairs_result[#ipairs_result + 1] = i .. ":" .. v
end
results[#results + 1] = "ipairs=" .. table.concat(ipairs_result, ",")

-- Test 2: ipairs stops at nil
local t2 = {1, 2, nil, 4}
local count2 = 0
for i, v in ipairs(t2) do
    count2 = count2 + 1
end
results[#results + 1] = "ipairs_nil=" .. count2

-- Test 3: Basic pairs
local t3 = {a = 1, b = 2, c = 3}
local pairs_count = 0
for k, v in pairs(t3) do
    pairs_count = pairs_count + v
end
results[#results + 1] = "pairs=" .. pairs_count

-- Test 4: Mixed table with pairs
local t4 = {10, 20, a = "x", b = "y"}
local mixed_count = 0
for k, v in pairs(t4) do
    mixed_count = mixed_count + 1
end
results[#results + 1] = "mixed=" .. mixed_count

-- Test 5: Empty table
local empty_pairs = 0
for k, v in pairs({}) do
    empty_pairs = empty_pairs + 1
end
results[#results + 1] = "empty=" .. empty_pairs

-- Test 6: next function
local t6 = {a = 1, b = 2}
local first_key = next(t6)
results[#results + 1] = "next=" .. (first_key ~= nil and "found" or "nil")

-- Test 7: next with key
local t7 = {a = 1, b = 2, c = 3}
local k7 = next(t7)
local k7b = next(t7, k7)
results[#results + 1] = "next_chain=" .. (k7b ~= nil and "found" or "nil")

-- Test 8: Modification during ipairs (behavior test)
local t8 = {1, 2, 3, 4, 5}
local sum8 = 0
for i, v in ipairs(t8) do
    sum8 = sum8 + v
end
results[#results + 1] = "mod_sum=" .. sum8

-- Test 9: Large array
local t9 = {}
for i = 1, 100 do
    t9[i] = i
end
local sum9 = 0
for i, v in ipairs(t9) do
    sum9 = sum9 + v
end
results[#results + 1] = "large=" .. sum9

-- Test 10: Sparse array
local t10 = {}
t10[1] = "a"
t10[3] = "c"
t10[5] = "e"
local sparse_count = 0
for i, v in ipairs(t10) do
    sparse_count = sparse_count + 1
end
results[#results + 1] = "sparse=" .. sparse_count

-- Test 11: pairs with integer keys
local t11 = {[1] = "a", [2] = "b", [10] = "j"}
local keys11 = 0
for k, v in pairs(t11) do
    keys11 = keys11 + 1
end
results[#results + 1] = "int_keys=" .. keys11

print(table.concat(results, ","))
-- Expected: ipairs=1:a,2:b,3:c,ipairs_nil=2,pairs=6,mixed=4,empty=0,next=found,next_chain=found,mod_sum=15,large=5050,sparse=1,int_keys=3
