-- Test: Basic coroutine operations
local results = {}

-- Test 1: Create and resume
local co1 = coroutine.create(function()
    return "done"
end)
local ok1, res1 = coroutine.resume(co1)
results[#results + 1] = "basic=" .. tostring(ok1) .. ":" .. res1

-- Test 2: Yield and resume
local co2 = coroutine.create(function()
    coroutine.yield("first")
    return "second"
end)
local ok2a, val2a = coroutine.resume(co2)
local ok2b, val2b = coroutine.resume(co2)
results[#results + 1] = "yield=" .. val2a .. ":" .. val2b

-- Test 3: Status
local co3 = coroutine.create(function()
    coroutine.yield()
end)
results[#results + 1] = "status1=" .. coroutine.status(co3)
coroutine.resume(co3)
results[#results + 1] = "status2=" .. coroutine.status(co3)
coroutine.resume(co3)
results[#results + 1] = "status3=" .. coroutine.status(co3)

-- Test 4: Running coroutine
local running_result = nil
local co4 = coroutine.create(function()
    running_result = coroutine.running()
end)
coroutine.resume(co4)
results[#results + 1] = "running=" .. tostring(running_result == co4)

-- Test 5: Wrap function
local wrapped = coroutine.wrap(function()
    coroutine.yield(10)
    coroutine.yield(20)
    return 30
end)
results[#results + 1] = "wrap=" .. wrapped() .. ";" .. wrapped() .. ";" .. wrapped()

-- Test 6: Multiple yields
local co6 = coroutine.create(function()
    for i = 1, 3 do
        coroutine.yield(i)
    end
    return "end"
end)
local vals = {}
for i = 1, 4 do
    local ok, val = coroutine.resume(co6)
    vals[#vals + 1] = tostring(val)
end
results[#results + 1] = "multi_yield=" .. table.concat(vals, ";")

print(table.concat(results, ","))
-- Expected: basic=true:done,yield=first:second,status1=suspended,status2=suspended,status3=dead,running=true,wrap=10;20;30,multi_yield=1;2;3;end
