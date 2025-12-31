-- Test: Table operation determinism
local results = {}

-- Test 1: Array operations
local arr = {5, 3, 8, 1, 9, 2, 7, 4, 6}
table.sort(arr)
results[#results + 1] = "sort=" .. table.concat(arr, ":")

-- Test 2: Insert operations
local t2 = {1, 2, 3}
table.insert(t2, 4)
table.insert(t2, 2, 1.5)
results[#results + 1] = "insert=" .. table.concat(t2, ":")

-- Test 3: Remove operations
local t3 = {1, 2, 3, 4, 5}
local removed = table.remove(t3, 3)
results[#results + 1] = "remove=" .. removed .. ":" .. table.concat(t3, ":")

-- Test 4: Length consistency
local t4 = {}
for i = 1, 100 do
    t4[i] = i
end
results[#results + 1] = "len=" .. #t4

-- Test 5: Nested table
local nested = {
    a = {1, 2, 3},
    b = {x = 10, y = 20},
    c = {{1}, {2}, {3}}
}
local nested_sum = nested.a[1] + nested.b.x + nested.c[2][1]
results[#results + 1] = "nested=" .. nested_sum

-- Test 6: Table as key
local key1 = {id = 1}
local key2 = {id = 2}
local tbl_keys = {}
tbl_keys[key1] = "first"
tbl_keys[key2] = "second"
results[#results + 1] = "tblkey=" .. tbl_keys[key1] .. ":" .. tbl_keys[key2]

-- Test 7: Metatable arithmetic
local mt = {
    __add = function(a, b) return {val = a.val + b.val} end
}
local obj1 = setmetatable({val = 10}, mt)
local obj2 = setmetatable({val = 20}, mt)
local sum_obj = obj1 + obj2
results[#results + 1] = "meta_add=" .. sum_obj.val

-- Test 8: Deep copy pattern
local function deep_copy(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            copy[k] = deep_copy(v)
        else
            copy[k] = v
        end
    end
    return copy
end
local orig = {a = 1, b = {c = 2}}
local copied = deep_copy(orig)
copied.b.c = 99
results[#results + 1] = "copy=" .. orig.b.c .. ":" .. copied.b.c

-- Test 9: Table iteration sum
local t9 = {a = 1, b = 2, c = 3, d = 4, e = 5}
local pair_sum = 0
for k, v in pairs(t9) do
    pair_sum = pair_sum + v
end
results[#results + 1] = "pair_sum=" .. pair_sum

-- Test 10: ipairs sum
local t10 = {10, 20, 30, 40, 50}
local ipair_sum = 0
for i, v in ipairs(t10) do
    ipair_sum = ipair_sum + v
end
results[#results + 1] = "ipair_sum=" .. ipair_sum

-- Test 11: Custom sort
local t11 = {{k = "b", v = 2}, {k = "a", v = 1}, {k = "c", v = 3}}
table.sort(t11, function(x, y) return x.k < y.k end)
local sort_keys = {}
for i, obj in ipairs(t11) do
    sort_keys[i] = obj.k
end
results[#results + 1] = "custom_sort=" .. table.concat(sort_keys)

-- Test 12: Concat with separator
local t12 = {"one", "two", "three"}
results[#results + 1] = "sep_concat=" .. table.concat(t12, "|")

print(table.concat(results, ","))
-- Expected: deterministic across runs
