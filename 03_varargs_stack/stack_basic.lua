-- Test: Basic stack operations
local results = {}

-- Test 1: Multiple return values
local function multiReturn()
    return 1, 2, 3
end
local a, b, c = multiReturn()
results[#results + 1] = "multi=" .. a .. ";" .. b .. ";" .. c

-- Test 2: Discard extra returns
local x = multiReturn()  -- Only first
results[#results + 1] = "discard=" .. x

-- Test 3: Not enough returns (nil for missing)
local function twoReturns()
    return 10, 20
end
local p, q, r = twoReturns()
results[#results + 1] = "missing=" .. p .. ";" .. q .. ";" .. tostring(r)

-- Test 4: Return in expression context (only first)
local function threeReturns()
    return 100, 200, 300
end
local sum = threeReturns() + 1  -- Uses only first (100)
results[#results + 1] = "expr=" .. sum

-- Test 5: Parentheses adjust to one value
local single = (threeReturns())
results[#results + 1] = "paren=" .. single

-- Test 6: Multiple assignment sources
local function pairReturn()
    return "a", "b"
end
local v1, v2, v3, v4 = pairReturn(), pairReturn()
results[#results + 1] = "multi_source=" .. v1 .. ";" .. v2 .. ";" .. tostring(v3) .. ";" .. tostring(v4)

print(table.concat(results, ","))
-- Expected: multi=1;2;3,discard=1,missing=10;20;nil,expr=101,paren=100,multi_source=a;a;b;nil
