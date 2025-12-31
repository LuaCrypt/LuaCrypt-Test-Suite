-- Test: __gc metamethod (finalizer)
local results = {}
local gc_log = {}

-- Test 1: Basic __gc
local function createTracker(name)
    return setmetatable({name = name}, {
        __gc = function(self)
            gc_log[#gc_log + 1] = self.name
        end
    })
end

do
    local t1 = createTracker("first")
    local t2 = createTracker("second")
end
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "gc_count=" .. #gc_log

-- Test 2: __gc with closure
local close_count = 0
local function createCloseable()
    return setmetatable({}, {
        __gc = function()
            close_count = close_count + 1
        end
    })
end

do
    for i = 1, 3 do
        local _ = createCloseable()
    end
end
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "close_count=" .. close_count

-- Test 3: __gc not called if table still referenced
local kept = createTracker("kept")
collectgarbage("collect")
local before_clear = #gc_log
kept = nil
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "kept_then_freed=" .. (before_clear < #gc_log and "yes" or "no")

-- Test 4: Resurrection in __gc
local resurrected = nil
local res_called = false
do
    local t = setmetatable({data = "important"}, {
        __gc = function(self)
            res_called = true
            resurrected = self  -- Resurrect!
        end
    })
end
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "resurrected=" .. tostring(res_called)

-- Note: __gc for tables was added in Lua 5.2

print(table.concat(results, ","))
-- Expected varies by Lua version
