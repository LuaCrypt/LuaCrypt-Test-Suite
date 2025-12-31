-- Test: next() function
local results = {}

-- Test 1: Basic next
local t1 = {a = 1, b = 2, c = 3}
local k1, v1 = next(t1)
results[#results + 1] = "basic=" .. type(k1)  -- Some key

-- Test 2: next with key
local t2 = {x = 10, y = 20}
local k2, v2 = next(t2)  -- First pair
local k3, v3 = next(t2, k2)  -- Second pair
local k4, v4 = next(t2, k3)  -- Should be nil
results[#results + 1] = "sequence=" .. tostring(k4)

-- Test 3: Empty table
local t3 = {}
local k5, v5 = next(t3)
results[#results + 1] = "empty=" .. tostring(k5)

-- Test 4: Array iteration
local t4 = {10, 20, 30}
local sum = 0
local k = nil
repeat
    k, v = next(t4, k)
    if v then sum = sum + v end
until not k
results[#results + 1] = "array=" .. sum

-- Test 5: next(t, nil) same as next(t)
local t5 = {p = 100}
local k6a = next(t5)
local k6b = next(t5, nil)
results[#results + 1] = "nil_key=" .. tostring(k6a == k6b)

-- Test 6: Check if table is empty
local function isEmpty(t)
    return next(t) == nil
end
results[#results + 1] = "is_empty=" .. tostring(isEmpty({})) .. ":" .. tostring(isEmpty({1}))

-- Test 7: Count all entries
local t7 = {1, 2, 3, a = "x", b = "y"}
local count = 0
for k, v in next, t7 do
    count = count + 1
end
results[#results + 1] = "count=" .. count

print(table.concat(results, ","))
-- Expected: basic=string,sequence=nil,empty=nil,array=60,nil_key=true,is_empty=true:false,count=5
