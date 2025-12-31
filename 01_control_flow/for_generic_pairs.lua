-- Test: Generic for with pairs()
local results = {}

-- Test 1: Simple table iteration
local t = {a = 1, b = 2, c = 3}
local keys = {}
local sum = 0
for k, v in pairs(t) do
    keys[#keys + 1] = k
    sum = sum + v
end
table.sort(keys)
results[#results + 1] = "pairs_keys=" .. table.concat(keys, ";") .. "_sum=" .. sum

-- Test 2: Mixed table (array + hash)
local mixed = {10, 20, 30, x = 100, y = 200}
local count = 0
for k, v in pairs(mixed) do
    count = count + 1
end
results[#results + 1] = "mixed_count=" .. count

-- Test 3: Empty table
local empty_count = 0
for k, v in pairs({}) do
    empty_count = empty_count + 1
end
results[#results + 1] = "empty=" .. empty_count

-- Test 4: Nested tables
local nested = {
    inner1 = {x = 1},
    inner2 = {y = 2}
}
local nested_keys = {}
for k, v in pairs(nested) do
    nested_keys[#nested_keys + 1] = k
    for k2, v2 in pairs(v) do
        nested_keys[#nested_keys + 1] = k .. "." .. k2
    end
end
table.sort(nested_keys)
results[#results + 1] = "nested=" .. table.concat(nested_keys, ";")

-- Test 5: Modifying during iteration (add - might not be visited)
local mod_t = {a = 1}
local visited = {}
for k, v in pairs(mod_t) do
    visited[#visited + 1] = k
    if k == "a" then
        mod_t.b = 2  -- May or may not be iterated
    end
end
results[#results + 1] = "add_visited=" .. #visited  -- At least 1

print(table.concat(results, ","))
-- Expected pattern: pairs_keys=a;b;c_sum=6,mixed_count=5,empty=0,nested=inner1;inner1.x;inner2;inner2.y,add_visited=...
