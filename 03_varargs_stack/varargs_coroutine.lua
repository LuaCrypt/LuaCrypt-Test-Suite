-- Test: Varargs with coroutines
local results = {}

-- Test 1: Yield multiple values
local co1 = coroutine.create(function()
    coroutine.yield(1, 2, 3)
    coroutine.yield(4, 5)
    return 6, 7, 8
end)
local ok, a, b, c = coroutine.resume(co1)
results[#results + 1] = "yield1=" .. a .. ";" .. b .. ";" .. c

local ok2, d, e = coroutine.resume(co1)
results[#results + 1] = "yield2=" .. d .. ";" .. e

local ok3, f, g, h = coroutine.resume(co1)
results[#results + 1] = "return=" .. f .. ";" .. g .. ";" .. h

-- Test 2: Pass varargs to coroutine
local co2 = coroutine.create(function(...)
    local sum = 0
    for i = 1, select("#", ...) do
        sum = sum + select(i, ...)
    end
    return sum
end)
local ok4, sum = coroutine.resume(co2, 10, 20, 30)
results[#results + 1] = "vararg_coro=" .. sum

-- Test 3: Resume with multiple values
local co3 = coroutine.create(function()
    local a, b, c = coroutine.yield()  -- Wait for values
    return a + b + c
end)
coroutine.resume(co3)  -- Start
local ok5, result = coroutine.resume(co3, 100, 200, 300)  -- Send values
results[#results + 1] = "resume_multi=" .. result

-- Test 4: Forward varargs in coroutine
local co4 = coroutine.create(function(...)
    coroutine.yield(...)  -- Forward all
end)
local ok6, x, y, z = coroutine.resume(co4, "a", "b", "c")
results[#results + 1] = "forward=" .. x .. ";" .. y .. ";" .. z

-- Test 5: Varargs function inside coroutine
local co5 = coroutine.create(function()
    local function inner(...)
        return select("#", ...), ...
    end
    local n, a, b = inner(1, 2)
    coroutine.yield(n, a, b)
end)
local ok7, n7, a7, b7 = coroutine.resume(co5)
results[#results + 1] = "inner=" .. n7 .. ":" .. a7 .. ";" .. b7

print(table.concat(results, ","))
-- Expected: yield1=1;2;3,yield2=4;5,return=6;7;8,vararg_coro=60,resume_multi=600,forward=a;b;c,inner=2:1;2
