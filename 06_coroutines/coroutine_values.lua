-- Test: Passing values to/from coroutines
local results = {}

-- Test 1: Arguments to coroutine
local co1 = coroutine.create(function(a, b, c)
    return a + b + c
end)
local ok1, sum1 = coroutine.resume(co1, 10, 20, 30)
results[#results + 1] = "args=" .. sum1

-- Test 2: Yield returns resume arguments
local co2 = coroutine.create(function()
    local x = coroutine.yield("waiting")
    return "got: " .. x
end)
coroutine.resume(co2)  -- First resume, yields "waiting"
local ok2, res2 = coroutine.resume(co2, "hello")  -- Send "hello"
results[#results + 1] = "resume_arg=" .. res2

-- Test 3: Multiple values in yield
local co3 = coroutine.create(function()
    coroutine.yield(1, 2, 3)
end)
local ok3, a, b, c = coroutine.resume(co3)
results[#results + 1] = "multi_yield=" .. a .. ";" .. b .. ";" .. c

-- Test 4: Multiple values from return
local co4 = coroutine.create(function()
    return 10, 20, 30
end)
local ok4, x, y, z = coroutine.resume(co4)
results[#results + 1] = "multi_return=" .. x .. ";" .. y .. ";" .. z

-- Test 5: Nil values in yield
local co5 = coroutine.create(function()
    coroutine.yield(nil, "after_nil")
end)
local ok5, n, m = coroutine.resume(co5)
results[#results + 1] = "nil_yield=" .. tostring(n) .. ":" .. m

-- Test 6: Exchange values bidirectionally
local co6 = coroutine.create(function(initial)
    local received = initial
    while true do
        received = coroutine.yield(received * 2)
    end
end)
local _, r1 = coroutine.resume(co6, 1)
local _, r2 = coroutine.resume(co6, 5)
local _, r3 = coroutine.resume(co6, 10)
results[#results + 1] = "exchange=" .. r1 .. ";" .. r2 .. ";" .. r3

print(table.concat(results, ","))
-- Expected: args=60,resume_arg=got: hello,multi_yield=1;2;3,multi_return=10;20;30,nil_yield=nil:after_nil,exchange=2;10;20
