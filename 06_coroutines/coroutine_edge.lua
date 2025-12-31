-- Test: Coroutine edge cases
local results = {}

-- Test 1: Empty coroutine
local co1 = coroutine.create(function() end)
local ok1, v1 = coroutine.resume(co1)
results[#results + 1] = "empty=" .. tostring(ok1) .. ":" .. tostring(v1)

-- Test 2: Immediate return
local co2 = coroutine.create(function()
    return 42
end)
local ok2, v2 = coroutine.resume(co2)
results[#results + 1] = "immed=" .. v2
results[#results + 1] = "immed_status=" .. coroutine.status(co2)

-- Test 3: Yield with no args
local co3 = coroutine.create(function()
    coroutine.yield()
    return "done"
end)
local ok3a, v3a = coroutine.resume(co3)
local ok3b, v3b = coroutine.resume(co3)
results[#results + 1] = "noarg_yield=" .. tostring(v3a)
results[#results + 1] = "noarg_done=" .. v3b

-- Test 4: Resume with extra args (ignored)
local co4 = coroutine.create(function(a, b)
    return a + b
end)
local _, v4 = coroutine.resume(co4, 1, 2, 3, 4, 5) -- extras ignored
results[#results + 1] = "extra=" .. v4

-- Test 5: Yield returns all resume args
local co5 = coroutine.create(function()
    local a, b, c = coroutine.yield()
    return a, b, c
end)
coroutine.resume(co5)
local ok5, v5a, v5b, v5c = coroutine.resume(co5, 10, 20, 30)
results[#results + 1] = "yield_args=" .. v5a .. ":" .. v5b .. ":" .. v5c

-- Test 6: Create but never resume
local co6 = coroutine.create(function()
    return "never"
end)
results[#results + 1] = "unrun=" .. coroutine.status(co6)

-- Test 7: Resume running (error case handled)
local co7 = coroutine.create(function()
    -- Cannot resume self from within
    return "ok"
end)
local _, v7 = coroutine.resume(co7)
results[#results + 1] = "self=" .. v7

-- Test 8: Very long return list
local co8 = coroutine.create(function()
    return 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
end)
local ok8, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10 = coroutine.resume(co8)
results[#results + 1] = "long_ret=" .. (r1 + r2 + r3 + r4 + r5 + r6 + r7 + r8 + r9 + r10)

-- Test 9: Status transitions
local co9 = coroutine.create(function()
    coroutine.yield()
end)
local s1 = coroutine.status(co9)
coroutine.resume(co9)
local s2 = coroutine.status(co9)
coroutine.resume(co9)
local s3 = coroutine.status(co9)
results[#results + 1] = "trans=" .. s1 .. ":" .. s2 .. ":" .. s3

-- Test 10: Boolean false as valid value
local co10 = coroutine.create(function()
    coroutine.yield(false)
    return false
end)
local ok10a, v10a = coroutine.resume(co10)
local ok10b, v10b = coroutine.resume(co10)
results[#results + 1] = "false_val=" .. tostring(v10a) .. ":" .. tostring(v10b)

print(table.concat(results, ","))
-- Expected: empty=true:nil,immed=42,immed_status=dead,noarg_yield=nil,noarg_done=done,extra=3,yield_args=10:20:30,unrun=suspended,self=ok,long_ret=55,trans=suspended:suspended:dead,false_val=false:false
