-- Test: Complex stack scenarios
local results = {}

-- Test 1: Mixed sources in assignment
local function f1() return 1, 2 end
local function f2() return 3, 4 end
local function f3() return 5, 6 end
local a, b, c, d, e = f1(), f2(), f3()
results[#results + 1] = "mixed=" .. a .. ";" .. b .. ";" .. c .. ";" .. tostring(d) .. ";" .. tostring(e)

-- Test 2: Recursive call with multiple returns
local function recurse(n)
    if n <= 0 then return 0, 0 end
    local a, b = recurse(n - 1)
    return a + 1, b + n
end
local r1, r2 = recurse(5)
results[#results + 1] = "recurse=" .. r1 .. ";" .. r2

-- Test 3: Multiple returns through pcall
local function mayFail()
    return 10, 20, 30
end
local ok, v1, v2, v3 = pcall(mayFail)
results[#results + 1] = "pcall=" .. tostring(ok) .. ";" .. v1 .. ";" .. v2 .. ";" .. v3

-- Test 4: Coroutine yield/resume with multiple values
local co = coroutine.create(function()
    coroutine.yield(1, 2, 3)
end)
local status, y1, y2, y3 = coroutine.resume(co)
results[#results + 1] = "coro=" .. tostring(status) .. ";" .. y1 .. ";" .. y2 .. ";" .. y3

-- Test 5: String operations with multiple returns
local function splitPair()
    return "hello", "world"
end
local concat = splitPair() .. "_suffix"  -- Only uses first
results[#results + 1] = "string=" .. concat

-- Test 6: Boolean logic with multiple returns
local function getBool()
    return true, false
end
local b1 = getBool() and "yes" or "no"  -- Uses only first (true)
results[#results + 1] = "bool=" .. b1

print(table.concat(results, ","))
-- Expected: mixed=1;3;5;6;nil,recurse=5;15,pcall=true;10;20;30,coro=true;1;2;3,string=hello_suffix,bool=yes
