-- Test: Hash table iteration order (not guaranteed but should be consistent within same run)
local results = {}

-- Note: pairs() order is not guaranteed to be deterministic across Lua versions
-- or even across runs. These tests verify consistency within a single run.

-- Test 1: Same table, same iteration twice
local t1 = {a = 1, b = 2, c = 3, d = 4, e = 5}
local order1 = {}
local order2 = {}
for k, v in pairs(t1) do
    order1[#order1 + 1] = k
end
for k, v in pairs(t1) do
    order2[#order2 + 1] = k
end
local same_order = table.concat(order1) == table.concat(order2)
results[#results + 1] = "same_iter=" .. tostring(same_order)

-- Test 2: Order after modification (may change)
t1.f = 6
local order3 = {}
for k, v in pairs(t1) do
    order3[#order3 + 1] = k
end
results[#results + 1] = "after_mod=" .. #order3

-- Test 3: next() consistency
local k1 = next(t1)
local k2 = next(t1)
results[#results + 1] = "next_same=" .. tostring(k1 == k2)

-- Test 4: Identical tables may have different order
local t2a = {x = 1, y = 2, z = 3}
local t2b = {x = 1, y = 2, z = 3}
local sum_a, sum_b = 0, 0
local i = 1
for k, v in pairs(t2a) do
    sum_a = sum_a + v * i
    i = i + 1
end
i = 1
for k, v in pairs(t2b) do
    sum_b = sum_b + v * i
    i = i + 1
end
results[#results + 1] = "identical=" .. (sum_a == sum_b and "same" or "diff")

-- Test 5: ipairs is always ordered
local t3 = {10, 20, 30, 40, 50}
local ipairs_order = {}
for i, v in ipairs(t3) do
    ipairs_order[#ipairs_order + 1] = v
end
results[#results + 1] = "ipairs=" .. table.concat(ipairs_order, ":")

-- Test 6: Numeric keys in pairs
local t4 = {[3] = "c", [1] = "a", [2] = "b"}
local num_order = {}
for k, v in pairs(t4) do
    num_order[#num_order + 1] = k
end
table.sort(num_order)
results[#results + 1] = "num_keys=" .. table.concat(num_order)

-- Test 7: Mixed keys
local t5 = {a = 1, [1] = "x", b = 2, [2] = "y"}
local mixed_count = 0
for k, v in pairs(t5) do
    mixed_count = mixed_count + 1
end
results[#results + 1] = "mixed=" .. mixed_count

-- Test 8: Large table consistency
local t6 = {}
for i = 1, 100 do
    t6["key" .. i] = i
end
local large_sum = 0
for k, v in pairs(t6) do
    large_sum = large_sum + v
end
results[#results + 1] = "large=" .. large_sum

-- Test 9: Deletion and iteration
local t7 = {a = 1, b = 2, c = 3, d = 4}
local del_order = {}
for k, v in pairs(t7) do
    del_order[#del_order + 1] = k
end
t7.b = nil  -- delete during (after) first iteration
local del_order2 = {}
for k, v in pairs(t7) do
    del_order2[#del_order2 + 1] = k
end
results[#results + 1] = "delete=" .. #del_order .. ":" .. #del_order2

-- Test 10: Empty to non-empty
local t8 = {}
local empty_next = next(t8)
t8.first = 1
local filled_next = next(t8)
results[#results + 1] = "empty_fill=" .. tostring(empty_next) .. ":" .. tostring(filled_next ~= nil)

print(table.concat(results, ","))
-- Output shows hash table behavior characteristics
