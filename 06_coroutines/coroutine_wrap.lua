-- Test: coroutine.wrap
local results = {}

-- Test 1: Basic wrap
local f1 = coroutine.wrap(function()
    return "result"
end)
results[#results + 1] = "basic=" .. f1()

-- Test 2: Wrap with yields
local f2 = coroutine.wrap(function()
    coroutine.yield(1)
    coroutine.yield(2)
    return 3
end)
results[#results + 1] = "yields=" .. f2() .. ";" .. f2() .. ";" .. f2()

-- Test 3: Wrap with arguments
local f3 = coroutine.wrap(function(a, b)
    return a + b
end)
results[#results + 1] = "args=" .. f3(10, 20)

-- Test 4: Wrap returns multiple values
local f4 = coroutine.wrap(function()
    coroutine.yield(1, 2, 3)
end)
local a, b, c = f4()
results[#results + 1] = "multi=" .. a .. ";" .. b .. ";" .. c

-- Test 5: Wrap error propagation
local f5 = coroutine.wrap(function()
    error("wrapped error")
end)
local ok5, err5 = pcall(f5)
results[#results + 1] = "error=" .. tostring(ok5)

-- Test 6: Multiple wraps
local f6a = coroutine.wrap(function()
    coroutine.yield("a")
end)
local f6b = coroutine.wrap(function()
    coroutine.yield("b")
end)
results[#results + 1] = "multi_wrap=" .. f6a() .. ";" .. f6b()

-- Test 7: Wrap with stateful closure
local function makeCounter()
    return coroutine.wrap(function()
        local n = 0
        while true do
            n = n + 1
            coroutine.yield(n)
        end
    end)
end
local c1 = makeCounter()
local c2 = makeCounter()
results[#results + 1] = "stateful=" .. c1() .. ";" .. c1() .. ";" .. c2()

print(table.concat(results, ","))
-- Expected: basic=result,yields=1;2;3,args=30,multi=1;2;3,error=false,multi_wrap=a;b,stateful=1;2;1
