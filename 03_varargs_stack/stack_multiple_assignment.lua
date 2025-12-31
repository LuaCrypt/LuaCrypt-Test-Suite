-- Test: Multiple assignment with stack effects
local results = {}

-- Test 1: Parallel assignment
local a, b, c = 1, 2, 3
results[#results + 1] = "parallel=" .. a .. ";" .. b .. ";" .. c

-- Test 2: Swap using parallel assignment
local x, y = 10, 20
x, y = y, x
results[#results + 1] = "swap=" .. x .. ";" .. y

-- Test 3: Triple rotation
local p, q, r = 1, 2, 3
p, q, r = q, r, p
results[#results + 1] = "rotate=" .. p .. ";" .. q .. ";" .. r

-- Test 4: Function return in parallel assignment
local function getPair()
    return 100, 200
end
local m, n = getPair()
results[#results + 1] = "func_pair=" .. m .. ";" .. n

-- Test 5: Multiple function calls
local function getOne()
    return 1
end
local function getTwo()
    return 2, 3
end
local v1, v2, v3 = getOne(), getTwo()
results[#results + 1] = "multi_func=" .. v1 .. ";" .. v2 .. ";" .. tostring(v3)

-- Test 6: Extra variables get nil
local e1, e2, e3, e4 = 1, 2
results[#results + 1] = "extra_nil=" .. e1 .. ";" .. e2 .. ";" .. tostring(e3) .. ";" .. tostring(e4)

-- Test 7: Self-referencing assignment
local s = 10
local t = 20
s, t = s + 1, s + t  -- Uses old values on right side
results[#results + 1] = "self_ref=" .. s .. ";" .. t

print(table.concat(results, ","))
-- Expected: parallel=1;2;3,swap=20;10,rotate=2;3;1,func_pair=100;200,multi_func=1;2;3,extra_nil=1;2;nil;nil,self_ref=11;30
