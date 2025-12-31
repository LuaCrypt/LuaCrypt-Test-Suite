-- Test: Closures in coroutines
local results = {}

-- Test 1: Coroutine captures upvalue
local x = 10
local co1 = coroutine.create(function()
    return x * 2
end)
local ok1, res1 = coroutine.resume(co1)
results[#results + 1] = "capture=" .. res1

-- Test 2: Upvalue modified before resume
local y = 5
local co2 = coroutine.create(function()
    return y
end)
y = 100
local ok2, res2 = coroutine.resume(co2)
results[#results + 1] = "modified=" .. res2

-- Test 3: Coroutine modifies upvalue
local z = 0
local co3 = coroutine.create(function()
    z = z + 10
    coroutine.yield()
    z = z + 100
end)
coroutine.resume(co3)
local after_yield = z
coroutine.resume(co3)
local after_return = z
results[#results + 1] = "modify=" .. after_yield .. ":" .. after_return

-- Test 4: Multiple coroutines share upvalue
local shared = 0
local co4a = coroutine.create(function()
    shared = shared + 1
    coroutine.yield()
    shared = shared + 10
end)
local co4b = coroutine.create(function()
    shared = shared + 100
    coroutine.yield()
    shared = shared + 1000
end)
coroutine.resume(co4a)
coroutine.resume(co4b)
local mid = shared
coroutine.resume(co4a)
coroutine.resume(co4b)
results[#results + 1] = "shared=" .. mid .. ":" .. shared

-- Test 5: Closure created inside coroutine
local co5 = coroutine.create(function()
    local local_val = 42
    local get = function()
        return local_val
    end
    coroutine.yield(get)
    local_val = 100
    return get
end)
local _, getter1 = coroutine.resume(co5)
local _, getter2 = coroutine.resume(co5)
results[#results + 1] = "inner_closure=" .. getter1() .. ":" .. getter2()

print(table.concat(results, ","))
-- Expected: capture=20,modified=100,modify=10:110,shared=101:1111,inner_closure=42:100
