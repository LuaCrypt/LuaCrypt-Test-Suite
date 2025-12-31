-- Test: Sparse tables
local results = {}

-- Test 1: Gaps in array
local t1 = {[1] = "a", [3] = "c", [5] = "e"}
results[#results + 1] = "sparse_len=" .. #t1  -- Length is undefined for sparse

-- Test 2: Access nil holes
local t2 = {1, nil, 3}
results[#results + 1] = "nil_hole=" .. tostring(t2[2])

-- Test 3: Large indices
local t3 = {}
t3[1000000] = "far"
results[#results + 1] = "large_idx=" .. t3[1000000]

-- Test 4: Mixed sparse
local t4 = {}
t4[1] = "one"
t4[10] = "ten"
t4[100] = "hundred"
t4.key = "value"
local count = 0
for k, v in pairs(t4) do
    count = count + 1
end
results[#results + 1] = "mixed_sparse=" .. count

-- Test 5: Counting non-nil
local t5 = {nil, nil, "x", nil, "y"}
local nonNil = 0
for i = 1, 5 do
    if t5[i] ~= nil then
        nonNil = nonNil + 1
    end
end
results[#results + 1] = "non_nil=" .. nonNil

-- Test 6: Iterating sparse with pairs
local t6 = {[2] = "b", [5] = "e", [10] = "j"}
local keys = {}
for k, v in pairs(t6) do
    keys[#keys + 1] = k
end
table.sort(keys)
results[#results + 1] = "sparse_keys=" .. table.concat(keys, ";")

print(table.concat(results, ","))
-- Expected varies for sparse tables
