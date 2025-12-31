-- Test: Errors in coroutines
local results = {}

-- Test 1: Error in coroutine
local co1 = coroutine.create(function()
    error("coroutine error")
end)
local ok1, err1 = coroutine.resume(co1)
results[#results + 1] = "basic=" .. tostring(ok1)

-- Test 2: Error doesn't propagate to main
local co2 = coroutine.create(function()
    error("contained")
end)
local ok2, err2 = coroutine.resume(co2)
results[#results + 1] = "contained=" .. (string.find(err2, "contained") and "yes" or "no")

-- Test 3: Coroutine status after error
local co3 = coroutine.create(function()
    error("dead")
end)
coroutine.resume(co3)
results[#results + 1] = "status=" .. coroutine.status(co3)

-- Test 4: Error after yield
local co4 = coroutine.create(function()
    coroutine.yield("first")
    error("after yield")
end)
local ok4a, val4a = coroutine.resume(co4)
local ok4b, err4b = coroutine.resume(co4)
results[#results + 1] = "after_yield=" .. tostring(ok4a) .. ":" .. tostring(ok4b)

-- Test 5: pcall inside coroutine
local co5 = coroutine.create(function()
    local ok, err = pcall(function()
        error("inner")
    end)
    return ok and "caught" or "failed"
end)
local ok5, res5 = coroutine.resume(co5)
results[#results + 1] = "pcall_in_coro=" .. res5

-- Test 6: Multiple resumes after error (should fail)
local co6 = coroutine.create(function()
    error("once")
end)
coroutine.resume(co6)
local ok6, err6 = coroutine.resume(co6)
results[#results + 1] = "resume_dead=" .. tostring(ok6)

print(table.concat(results, ","))
-- Expected: basic=false,contained=yes,status=dead,after_yield=true:false,pcall_in_coro=failed,resume_dead=false
