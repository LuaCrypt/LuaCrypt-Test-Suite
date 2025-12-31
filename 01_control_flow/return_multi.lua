-- Test: Multiple return values
local results = {}

-- Test 1: Return two values
local function pair()
    return 1, 2
end
local a, b = pair()
results[#results + 1] = "pair=" .. a .. ";" .. b

-- Test 2: Return three values
local function triple()
    return "x", "y", "z"
end
local p, q, r = triple()
results[#results + 1] = "triple=" .. p .. ";" .. q .. ";" .. r

-- Test 3: Capture fewer than returned
local function many()
    return 1, 2, 3, 4, 5
end
local x, y = many()  -- Only captures first two
results[#results + 1] = "fewer=" .. x .. ";" .. y

-- Test 4: Capture more than returned (extras are nil)
local function few()
    return 10, 20
end
local m, n, o, p = few()
results[#results + 1] = "more=" .. m .. ";" .. n .. ";" .. tostring(o) .. ";" .. tostring(p)

-- Test 5: Return in table constructor (only first value)
local function twoVals()
    return 100, 200
end
local t1 = {twoVals()}  -- Captures all
local t2 = {twoVals(), 999}  -- First call only gives first value
results[#results + 1] = "table1=" .. #t1
results[#results + 1] = "table2=" .. #t2 .. "_" .. t2[1] .. "_" .. t2[2]

-- Test 6: Return as last expression captures all
local function wrap()
    return many()  -- Forwards all return values
end
local w1, w2, w3, w4, w5 = wrap()
results[#results + 1] = "forward=" .. w1 .. ";" .. w2 .. ";" .. w3 .. ";" .. w4 .. ";" .. w5

print(table.concat(results, ","))
-- Expected: pair=1;2,triple=x;y;z,fewer=1;2,more=10;20;nil;nil,table1=2,table2=2_100_999,forward=1;2;3;4;5
