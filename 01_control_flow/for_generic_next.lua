-- Test: Generic for with next() directly
local results = {}

-- Test 1: Direct next usage
local t = {a = 1, b = 2, c = 3}
local keys = {}
for k, v in next, t do
    keys[#keys + 1] = k
end
table.sort(keys)
results[#results + 1] = "next=" .. table.concat(keys, ";")

-- Test 2: next with explicit nil start
local t2 = {x = 10, y = 20}
local count = 0
for k, v in next, t2, nil do
    count = count + 1
end
results[#results + 1] = "explicit_nil=" .. count

-- Test 3: Manual next iteration (equivalent)
local t3 = {p = 1, q = 2}
local manual = {}
local k = nil
k = next(t3, k)
while k do
    manual[#manual + 1] = k
    k = next(t3, k)
end
table.sort(manual)
results[#results + 1] = "manual=" .. table.concat(manual, ";")

-- Test 4: next on array-like table
local arr = {100, 200, 300}
local arr_sum = 0
for k, v in next, arr do
    arr_sum = arr_sum + v
end
results[#results + 1] = "arr_next=" .. arr_sum

-- Test 5: Check if table has any entries
local function hasEntries(t)
    return next(t) ~= nil
end
results[#results + 1] = "has1=" .. tostring(hasEntries({a = 1}))
results[#results + 1] = "has2=" .. tostring(hasEntries({}))

print(table.concat(results, ","))
-- Expected: next=a;b;c,explicit_nil=2,manual=p;q,arr_next=600,has1=true,has2=false
