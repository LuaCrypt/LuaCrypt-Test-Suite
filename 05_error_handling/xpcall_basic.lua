-- Test: xpcall with error handlers
local results = {}

-- Test 1: Basic xpcall success
local ok1, res1 = xpcall(function()
    return 42
end, function(err)
    return "handled: " .. err
end)
results[#results + 1] = "success=" .. tostring(ok1) .. ":" .. res1

-- Test 2: xpcall with error
local handler_called = false
local ok2, res2 = xpcall(function()
    error("test error")
end, function(err)
    handler_called = true
    return "caught"
end)
results[#results + 1] = "error=" .. tostring(ok2) .. ":" .. res2 .. ":" .. tostring(handler_called)

-- Test 3: Handler receives error message
local received_err = nil
local ok3, res3 = xpcall(function()
    error("specific message")
end, function(err)
    received_err = err
    return "handled"
end)
results[#results + 1] = "msg=" .. (string.find(tostring(received_err), "specific") and "found" or "missing")

-- Test 4: Handler with traceback
local ok4, res4 = xpcall(function()
    error("trace test")
end, function(err)
    return debug and debug.traceback(err, 2) or err
end)
results[#results + 1] = "trace=" .. (string.find(res4, "stack") and "has_stack" or "no_stack")

-- Test 5: Handler that errors (Lua 5.2+)
local ok5, res5 = xpcall(function()
    error("first")
end, function(err)
    error("handler error")  -- Error in handler
end)
results[#results + 1] = "handler_err=" .. tostring(ok5)

-- Test 6: xpcall with arguments (Lua 5.2+)
if pcall(function() xpcall(function(x) end, function() end, 1) end) then
    local ok6, res6 = xpcall(function(a, b)
        return a + b
    end, function(err) return err end, 10, 20)
    results[#results + 1] = "args=" .. res6
else
    results[#results + 1] = "args=not_supported"
end

print(table.concat(results, ","))
-- Expected varies by Lua version
