-- Test: Stack traces in errors
local results = {}

-- Test 1: Basic traceback
local function level3()
    error("deep error")
end
local function level2()
    level3()
end
local function level1()
    level2()
end
local ok1, err1 = xpcall(level1, function(err)
    return debug and debug.traceback(err) or err
end)
results[#results + 1] = "trace=" .. (string.find(err1, "level") and "has_levels" or "no_levels")

-- Test 2: Traceback with coroutine
if debug and debug.traceback then
    local co = coroutine.create(function()
        error("coro error")
    end)
    local ok, err = coroutine.resume(co)
    local tb = debug.traceback(co)
    results[#results + 1] = "coro_trace=" .. (string.find(tb, "stack") and "has" or "none")
else
    results[#results + 1] = "coro_trace=no_debug"
end

-- Test 3: Custom error handler with traceback
local function errorHandler(err)
    if debug and debug.traceback then
        return "ERROR: " .. err .. "\n" .. debug.traceback()
    end
    return err
end
local ok3, err3 = xpcall(function()
    error("handled")
end, errorHandler)
results[#results + 1] = "handler=" .. (string.find(err3, "ERROR") and "formatted" or "plain")

-- Test 4: Traceback depth
if debug and debug.traceback then
    local function deep(n)
        if n <= 0 then
            return debug.traceback()
        end
        return deep(n - 1)
    end
    local tb = deep(5)
    local count = 0
    for _ in string.gmatch(tb, "deep") do
        count = count + 1
    end
    results[#results + 1] = "depth=" .. (count > 3 and "deep" or "shallow")
else
    results[#results + 1] = "depth=no_debug"
end

print(table.concat(results, ","))
-- Expected varies by debug library availability
