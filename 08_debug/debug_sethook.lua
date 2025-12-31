-- Test: debug.sethook function
local results = {}

-- Test 1: Call hook
local call_count = 0
local function count_calls()
    call_count = call_count + 1
end
debug.sethook(count_calls, "c")
local function a() end
local function b() a() end
b()
debug.sethook()
results[#results + 1] = "calls=" .. (call_count > 0 and "counted" or "none")

-- Test 2: Return hook
local return_count = 0
debug.sethook(function() return_count = return_count + 1 end, "r")
local function ret1() return 1 end
local function ret2() return ret1() end
ret2()
debug.sethook()
results[#results + 1] = "returns=" .. (return_count > 0 and "counted" or "none")

-- Test 3: Line hook
local line_count = 0
debug.sethook(function() line_count = line_count + 1 end, "l")
local x = 1
x = x + 1
x = x + 1
debug.sethook()
results[#results + 1] = "lines=" .. (line_count > 0 and "counted" or "none")

-- Test 4: Combined hooks
local combined = {c = 0, r = 0, l = 0}
debug.sethook(function(event)
    if combined[event] then
        combined[event] = combined[event] + 1
    end
end, "crl")
local function combo() return 42 end
combo()
debug.sethook()
results[#results + 1] = "combined=" .. (combined.c > 0 and combined.r > 0 and "yes" or "no")

-- Test 5: Count hook
local count_triggers = 0
debug.sethook(function() count_triggers = count_triggers + 1 end, "", 5)
for i = 1, 100 do
    local _ = i * i
end
debug.sethook()
results[#results + 1] = "count=" .. (count_triggers > 0 and "triggered" or "none")

-- Test 6: gethook
debug.sethook(function() end, "c")
local fn, mask, count = debug.gethook()
debug.sethook()
results[#results + 1] = "gethook=" .. (fn and mask == "c" and "match" or "nomatch")

-- Test 7: Hook in coroutine
local coro_hook_count = 0
local co = coroutine.create(function()
    debug.sethook(function() coro_hook_count = coro_hook_count + 1 end, "c")
    local function inner() end
    inner()
    debug.sethook()
end)
coroutine.resume(co)
results[#results + 1] = "coro_hook=" .. (coro_hook_count > 0 and "yes" or "no")

-- Test 8: Clear hook
debug.sethook(function() end, "c")
debug.sethook()  -- clear
local fn8, mask8 = debug.gethook()
results[#results + 1] = "clear=" .. (fn8 == nil and "cleared" or "still_set")

-- Test 9: Hook with level tracking
local levels = {}
debug.sethook(function(event)
    if event == "call" then
        local info = debug.getinfo(2, "n")
        if info.name then
            levels[#levels + 1] = info.name
        end
    end
end, "c")
local function tracked1() end
local function tracked2() tracked1() end
tracked2()
debug.sethook()
results[#results + 1] = "tracked=" .. #levels

print(table.concat(results, ","))
-- Expected: calls=counted,returns=counted,lines=counted,combined=yes,count=triggered,gethook=match,coro_hook=yes,clear=cleared,tracked=2
