-- Test: Garbage collection differences across Lua versions
local results = {}

-- Test 1: Basic collectgarbage
collectgarbage("collect")
results[#results + 1] = "collect=ok"

-- Test 2: collectgarbage count
local count = collectgarbage("count")
results[#results + 1] = "count=" .. (count > 0 and "positive" or "zero")

-- Test 3: Step collection
local step_result = collectgarbage("step", 0)
results[#results + 1] = "step=" .. (step_result and "bool" or "other")

-- Test 4: Generational mode (5.4+)
local gen_ok = pcall(function()
    collectgarbage("generational")
end)
if gen_ok then
    results[#results + 1] = "generational=supported"
    collectgarbage("incremental")  -- Reset
else
    results[#results + 1] = "generational=unsupported"
end

-- Test 5: isrunning (5.2+)
local running = collectgarbage("isrunning")
if running ~= nil then
    results[#results + 1] = "isrunning=" .. tostring(running)
else
    results[#results + 1] = "isrunning=nil"
end

-- Test 6: setpause/setstepmul
local old_pause = collectgarbage("setpause", 100)
collectgarbage("setpause", old_pause or 200)
results[#results + 1] = "setpause=" .. (old_pause and "value" or "nil")

-- Test 7: Weak table collection
local weak = setmetatable({}, {__mode = "v"})
local obj = {data = "test"}
weak.key = obj
obj = nil
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "weak=" .. (weak.key and "kept" or "collected")

-- Test 8: __gc metamethod
local gc_called = false
local mt = {
    __gc = function()
        gc_called = true
    end
}
local gc_obj = setmetatable({}, mt)
gc_obj = nil
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "gc_mt=" .. (gc_called and "called" or "not")

-- Test 9: Ephemeron tables (weak keys, strong values)
local ephemeron = setmetatable({}, {__mode = "k"})
local key = {}
ephemeron[key] = {strong_ref = "value"}
key = nil
collectgarbage("collect")
collectgarbage("collect")
local eph_count = 0
for _ in pairs(ephemeron) do eph_count = eph_count + 1 end
results[#results + 1] = "ephemeron=" .. eph_count

-- Test 10: Resurrection via __gc
local resurrected = nil
local res_mt = {
    __gc = function(self)
        resurrected = self
    end
}
local res_obj = setmetatable({value = 42}, res_mt)
res_obj = nil
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "resurrect=" .. (resurrected and resurrected.value or "nil")

-- Test 11: stop/restart
collectgarbage("stop")
local stopped = collectgarbage("isrunning")
collectgarbage("restart")
results[#results + 1] = "stop=" .. (stopped == false and "stopped" or "running")

-- Test 12: Memory pressure test
local big_tables = {}
for i = 1, 100 do
    big_tables[i] = {}
    for j = 1, 100 do
        big_tables[i][j] = j
    end
end
local before = collectgarbage("count")
big_tables = nil
collectgarbage("collect")
local after = collectgarbage("count")
results[#results + 1] = "pressure=" .. (before > after and "freed" or "kept")

print(table.concat(results, ","))
-- Expected varies by Lua version
