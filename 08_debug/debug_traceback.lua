-- Test: debug.traceback function
local results = {}

-- Test 1: Basic traceback
local tb1 = debug.traceback()
results[#results + 1] = "basic=" .. (tb1 and "has" or "nil")

-- Test 2: Traceback with message
local tb2 = debug.traceback("error message")
results[#results + 1] = "msg=" .. (tb2:find("error message") and "found" or "notfound")

-- Test 3: Traceback in nested function
local function level3()
    return debug.traceback()
end
local function level2()
    return level3()
end
local function level1()
    return level2()
end
local tb3 = level1()
results[#results + 1] = "nested=" .. (tb3:find("level") and "has_funcs" or "no_funcs")

-- Test 4: Traceback with level
local function test4()
    return debug.traceback("msg", 2)
end
local tb4 = test4()
results[#results + 1] = "level=" .. (tb4 and "has" or "nil")

-- Test 5: Traceback in pcall
local function error_fn()
    error("test error")
end
local ok, err = xpcall(error_fn, debug.traceback)
results[#results + 1] = "xpcall=" .. (err and err:find("test error") and "found" or "notfound")

-- Test 6: Traceback of coroutine
local co = coroutine.create(function()
    coroutine.yield()
end)
coroutine.resume(co)
local tb6 = debug.traceback(co)
results[#results + 1] = "coro=" .. (tb6 and "has" or "nil")

-- Test 7: Custom handler
local function custom_handler(err)
    return "CAUGHT: " .. tostring(err) .. "\n" .. debug.traceback()
end
local ok7, err7 = xpcall(function() error("boom") end, custom_handler)
results[#results + 1] = "custom=" .. (err7:find("CAUGHT") and "yes" or "no")

-- Test 8: Traceback with message only
local tb8 = debug.traceback("message", 1)
results[#results + 1] = "withmsg=" .. (tb8 and tb8:find("message") and "has" or "nil")

-- Test 9: Deep recursion traceback
local function recurse(n)
    if n <= 0 then
        return debug.traceback()
    end
    return recurse(n - 1)
end
local tb9 = recurse(10)
-- Should have multiple stack frames
local count9 = 0
for _ in tb9:gmatch("recurse") do
    count9 = count9 + 1
end
results[#results + 1] = "deep=" .. (count9 >= 5 and "many" or "few")

-- Test 10: Traceback format
local function format_test()
    return debug.traceback()
end
local tb10 = format_test()
-- Should have stack traceback header
results[#results + 1] = "format=" .. (tb10:lower():find("stack") and "has_header" or "no_header")

print(table.concat(results, ","))
-- Expected: basic=has,msg=found,nested=has_funcs,level=has,xpcall=found,coro=has,custom=yes,withmsg=has,deep=many,format=has_header
