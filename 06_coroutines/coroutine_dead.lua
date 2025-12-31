-- Test: Dead coroutine handling
local results = {}

-- Test 1: Coroutine dies after return
local co1 = coroutine.create(function()
    return "finished"
end)
coroutine.resume(co1)
results[#results + 1] = "after_return=" .. coroutine.status(co1)

-- Test 2: Cannot resume dead coroutine
local co2 = coroutine.create(function()
    return 1
end)
local ok2a, _ = coroutine.resume(co2)
local ok2b, err2 = coroutine.resume(co2)
results[#results + 1] = "resume_dead=" .. tostring(ok2a) .. ":" .. tostring(ok2b)

-- Test 3: Coroutine dies after error
local co3 = coroutine.create(function()
    error("fail")
end)
local ok3, _ = coroutine.resume(co3)
results[#results + 1] = "after_error=" .. coroutine.status(co3)

-- Test 4: Cannot resume after error
local ok4, err4 = coroutine.resume(co3)
results[#results + 1] = "resume_errored=" .. tostring(ok4)

-- Test 5: Detecting dead status
local co5 = coroutine.create(function()
    for i = 1, 3 do
        coroutine.yield(i)
    end
end)
local statuses = {}
for i = 1, 5 do
    local status = coroutine.status(co5)
    statuses[#statuses + 1] = status
    if status ~= "dead" then
        coroutine.resume(co5)
    end
end
results[#results + 1] = "status_track=" .. statuses[1] .. ":" .. statuses[5]

-- Test 6: wrap() throws on dead
local wrapped = coroutine.wrap(function()
    return "only_once"
end)
local v1 = wrapped()
local ok6, err6 = pcall(wrapped)
results[#results + 1] = "wrap_dead=" .. tostring(ok6)

print(table.concat(results, ","))
-- Expected: after_return=dead,resume_dead=true:false,after_error=dead,resume_errored=false,status_track=suspended:dead,wrap_dead=false
