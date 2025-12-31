-- Test: Coroutine error handling
local results = {}

-- Test 1: Error in coroutine
local co1 = coroutine.create(function()
    error("coroutine error")
end)
local ok1, err1 = coroutine.resume(co1)
results[#results + 1] = "err_ok=" .. tostring(ok1)
results[#results + 1] = "err_msg=" .. (err1:match("coroutine error") and "yes" or "no")
results[#results + 1] = "err_status=" .. coroutine.status(co1)

-- Test 2: Error after yield
local co2 = coroutine.create(function()
    coroutine.yield("before")
    error("after yield error")
end)
local ok2a, v2a = coroutine.resume(co2)
local ok2b, v2b = coroutine.resume(co2)
results[#results + 1] = "yield_ok=" .. tostring(ok2a)
results[#results + 1] = "after_ok=" .. tostring(ok2b)
results[#results + 1] = "after_status=" .. coroutine.status(co2)

-- Test 3: pcall inside coroutine
local co3 = coroutine.create(function()
    local ok = pcall(function()
        error("inner error")
    end)
    coroutine.yield(ok)
    return "completed"
end)
local _, v3a = coroutine.resume(co3)
local _, v3b = coroutine.resume(co3)
results[#results + 1] = "pcall_in_co=" .. tostring(v3a)
results[#results + 1] = "pcall_complete=" .. v3b

-- Test 4: Error propagation
local co4 = coroutine.create(function()
    local function inner()
        error("deep error", 0)
    end
    inner()
end)
local ok4, err4 = coroutine.resume(co4)
results[#results + 1] = "deep_ok=" .. tostring(ok4)
results[#results + 1] = "deep_has_msg=" .. (err4 and "yes" or "no")

-- Test 5: Resume dead coroutine after error
local ok5, err5 = coroutine.resume(co1)
results[#results + 1] = "dead_resume=" .. tostring(ok5)

-- Test 6: Multiple errors in sequence
local errors_caught = 0
for i = 1, 3 do
    local co = coroutine.create(function()
        error("error " .. i)
    end)
    local ok, _ = coroutine.resume(co)
    if not ok then errors_caught = errors_caught + 1 end
end
results[#results + 1] = "multi_err=" .. errors_caught

print(table.concat(results, ","))
-- Expected: err_ok=false,err_msg=yes,err_status=dead,yield_ok=true,after_ok=false,after_status=dead,pcall_in_co=false,pcall_complete=completed,deep_ok=false,deep_has_msg=yes,dead_resume=false,multi_err=3
