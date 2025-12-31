-- Test: debug.getlocal function
local results = {}

-- Test 1: Get local variable
local function test1()
    local a = 10
    local b = 20
    local name, val = debug.getlocal(1, 1)
    return name, val
end
local n1, v1 = test1()
results[#results + 1] = "local=" .. (n1 and v1 and "found" or "nil")

-- Test 2: Multiple locals
local function test2()
    local x = "hello"
    local y = "world"
    local z = "!"
    local vals = {}
    local i = 1
    while true do
        local name, val = debug.getlocal(1, i)
        if not name then break end
        if type(val) == "string" then
            vals[#vals + 1] = val
        end
        i = i + 1
    end
    return #vals
end
results[#results + 1] = "multi=" .. test2()

-- Test 3: Get local from different stack level
local function inner()
    return debug.getlocal(2, 1)
end
local function outer()
    local outer_var = 42
    return inner()
end
local n3, v3 = outer()
results[#results + 1] = "level2=" .. (v3 == 42 and "match" or "nomatch")

-- Test 4: Function parameters as locals
local function params(a, b, c)
    local r = {}
    for i = 1, 3 do
        local name, val = debug.getlocal(1, i)
        if name and val then
            r[#r + 1] = val
        end
    end
    return r[1] + r[2] + r[3]
end
results[#results + 1] = "params=" .. params(10, 20, 30)

-- Test 5: Invalid index returns nil
local function test5()
    local a = 1
    return debug.getlocal(1, 100)
end
local n5, v5 = test5()
results[#results + 1] = "invalid=" .. tostring(n5)

-- Test 6: Local shadowing
local function test6()
    local x = 1
    do
        local x = 2
        local name, val = debug.getlocal(1, 2)
        return val
    end
end
results[#results + 1] = "shadow=" .. test6()

-- Test 7: Get vararg locals (negative index)
local function test7(...)
    local n, v = debug.getlocal(1, -1)
    return v
end
local v7 = test7("first", "second")
results[#results + 1] = "vararg=" .. (v7 == "first" and "first" or "other")

-- Test 8: Local in loop
local function test8()
    for i = 1, 3 do
        if i == 2 then
            local name, val = debug.getlocal(1, 1)
            return val
        end
    end
end
results[#results + 1] = "loop=" .. test8()

-- Test 9: Coroutine locals
local co = coroutine.create(function()
    local coro_var = 99
    coroutine.yield()
end)
coroutine.resume(co)
local n9, v9 = debug.getlocal(co, 1, 1)
results[#results + 1] = "coro=" .. (v9 == 99 and "match" or "nomatch")

print(table.concat(results, ","))
-- Expected: local=found,multi=3,level2=match,params=60,invalid=nil,shadow=2,vararg=first,loop=2,coro=match
