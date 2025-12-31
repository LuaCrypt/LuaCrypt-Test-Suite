-- Test: Coroutine differences across Lua versions
local results = {}

-- Test 1: coroutine.isyieldable (5.3+)
if coroutine.isyieldable then
    local co = coroutine.create(function()
        return coroutine.isyieldable()
    end)
    local _, yieldable = coroutine.resume(co)
    results[#results + 1] = "isyieldable=" .. tostring(yieldable)
else
    results[#results + 1] = "isyieldable=nil"
end

-- Test 2: coroutine.close (5.4+)
if coroutine.close then
    local co = coroutine.create(function()
        coroutine.yield()
    end)
    coroutine.resume(co)
    local ok = coroutine.close(co)
    results[#results + 1] = "close=" .. tostring(ok)
else
    results[#results + 1] = "close=nil"
end

-- Test 3: Yield across C call boundary
local co3 = coroutine.create(function()
    pcall(function()
        coroutine.yield("in_pcall")
    end)
    return "done"
end)
local ok3, v3 = coroutine.resume(co3)
results[#results + 1] = "yield_pcall=" .. (ok3 and v3 or "error")

-- Test 4: Yield in metamethod (5.2+)
local mt4 = {
    __index = function(t, k)
        coroutine.yield("in_index")
        return k
    end
}
local co4 = coroutine.create(function()
    local t = setmetatable({}, mt4)
    return t.test
end)
local ok4a, v4a = coroutine.resume(co4)
if v4a == "in_index" then
    local ok4b, v4b = coroutine.resume(co4)
    results[#results + 1] = "yield_mt=" .. v4b
else
    results[#results + 1] = "yield_mt=error"
end

-- Test 5: Error in coroutine traceback
local co5 = coroutine.create(function()
    error("test error")
end)
local ok5, err5 = coroutine.resume(co5)
results[#results + 1] = "error=" .. (err5:find("test error") and "found" or "notfound")

-- Test 6: Status after error
results[#results + 1] = "dead_after_err=" .. coroutine.status(co5)

-- Test 7: Running coroutine
local running_test
local co7 = coroutine.create(function()
    running_test = coroutine.running()
end)
coroutine.resume(co7)
results[#results + 1] = "running=" .. (running_test == co7 and "match" or "nomatch")

-- Test 8: coroutine.running returns main thread (5.2+)
local main_thread = coroutine.running()
results[#results + 1] = "main=" .. (main_thread and "thread" or "nil")

-- Test 9: Wrap error handling
local wrapped = coroutine.wrap(function()
    error("wrap error")
end)
local ok9, err9 = pcall(wrapped)
results[#results + 1] = "wrap_err=" .. (ok9 and "ok" or "caught")

-- Test 10: Multiple values through yield/resume
local co10 = coroutine.create(function()
    local a, b, c = coroutine.yield(1, 2, 3)
    return a, b, c
end)
local ok10a, v10a, v10b, v10c = coroutine.resume(co10)
local ok10b, r10a, r10b, r10c = coroutine.resume(co10, 4, 5, 6)
results[#results + 1] = "multi=" .. (v10a + v10b + v10c) .. ":" .. (r10a + r10b + r10c)

-- Test 11: Coroutine as table key
local co_key = coroutine.create(function() end)
local co_table = {[co_key] = "value"}
results[#results + 1] = "co_key=" .. co_table[co_key]

-- Test 12: Nested coroutine creation
local outer_co = coroutine.create(function()
    local inner = coroutine.create(function()
        coroutine.yield("inner")
    end)
    local _, val = coroutine.resume(inner)
    return val .. "_outer"
end)
local _, result12 = coroutine.resume(outer_co)
results[#results + 1] = "nested=" .. result12

print(table.concat(results, ","))
-- Expected varies by Lua version
