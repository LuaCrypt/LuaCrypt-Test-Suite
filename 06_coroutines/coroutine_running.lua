-- Test: coroutine.running
local results = {}

-- Test 1: Running from main
local main_running = coroutine.running()
results[#results + 1] = "main=" .. (main_running == nil and "nil" or "not_nil")

-- Test 2: Running from coroutine
local captured = nil
local co2 = coroutine.create(function()
    captured = coroutine.running()
end)
coroutine.resume(co2)
results[#results + 1] = "in_coro=" .. tostring(captured == co2)

-- Test 3: Running changes with context
local outer_running, inner_running
local co3_inner = coroutine.create(function()
    inner_running = coroutine.running()
end)
local co3_outer = coroutine.create(function()
    outer_running = coroutine.running()
    coroutine.resume(co3_inner)
end)
coroutine.resume(co3_outer)
results[#results + 1] = "context=" .. tostring(outer_running ~= inner_running)

-- Test 4: Running preserved across yield
local running1, running2
local co4 = coroutine.create(function()
    running1 = coroutine.running()
    coroutine.yield()
    running2 = coroutine.running()
end)
coroutine.resume(co4)
coroutine.resume(co4)
results[#results + 1] = "across_yield=" .. tostring(running1 == running2)

-- Test 5: Running in wrapped coroutine
local wrapped_running
local f5 = coroutine.wrap(function()
    wrapped_running = coroutine.running()
    return "done"
end)
f5()
results[#results + 1] = "wrapped=" .. (wrapped_running ~= nil and "has_value" or "nil")

-- Test 6: isyieldable (Lua 5.3+)
if coroutine.isyieldable then
    local main_yieldable = coroutine.isyieldable()
    local coro_yieldable = nil
    local co6 = coroutine.create(function()
        coro_yieldable = coroutine.isyieldable()
    end)
    coroutine.resume(co6)
    results[#results + 1] = "yieldable=" .. tostring(main_yieldable) .. ":" .. tostring(coro_yieldable)
else
    results[#results + 1] = "yieldable=not_available"
end

print(table.concat(results, ","))
-- Expected varies by Lua version
