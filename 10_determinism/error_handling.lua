-- Test: Error handling determinism
local results = {}

-- Test 1: pcall success
local ok1, val1 = pcall(function() return 42 end)
results[#results + 1] = "pcall_ok=" .. tostring(ok1) .. ":" .. val1

-- Test 2: pcall failure
local ok2, err2 = pcall(function() error("test") end)
results[#results + 1] = "pcall_err=" .. tostring(ok2) .. ":" .. (err2:find("test") and "found" or "notfound")

-- Test 3: Nested pcall
local nested_order = {}
local ok3 = pcall(function()
    nested_order[#nested_order + 1] = "outer"
    pcall(function()
        nested_order[#nested_order + 1] = "inner"
        error("inner error")
    end)
    nested_order[#nested_order + 1] = "after"
end)
results[#results + 1] = "nested=" .. table.concat(nested_order, ">")

-- Test 4: xpcall with handler
local handler_called = false
local ok4, result4 = xpcall(function()
    error("xpcall test")
end, function(err)
    handler_called = true
    return "handled"
end)
results[#results + 1] = "xpcall=" .. tostring(handler_called) .. ":" .. result4

-- Test 5: assert
local ok5, err5 = pcall(function()
    assert(false, "assert message")
end)
results[#results + 1] = "assert=" .. (err5:find("assert message") and "found" or "notfound")

-- Test 6: Error with level
local function level_test()
    local function inner()
        error("level error", 2)
    end
    inner()
end
local ok6, err6 = pcall(level_test)
results[#results + 1] = "level=" .. (err6:find("level_test") and "correct" or "wrong")

-- Test 7: Error object type
local ok7, err7 = pcall(function()
    error({code = 42, msg = "object"})
end)
results[#results + 1] = "obj_err=" .. (type(err7) == "table" and err7.code or "not_table")

-- Test 8: Recovery and continuation
local recover_trace = {}
for i = 1, 3 do
    local ok = pcall(function()
        recover_trace[#recover_trace + 1] = "try" .. i
        if i == 2 then error("fail") end
        recover_trace[#recover_trace + 1] = "ok" .. i
    end)
    recover_trace[#recover_trace + 1] = ok and "pass" or "catch"
end
results[#results + 1] = "recover=" .. table.concat(recover_trace, ":")

-- Test 9: Multiple return on error
local function multi_error()
    error("multi")
    return 1, 2, 3
end
local ok9, a9, b9, c9 = pcall(multi_error)
results[#results + 1] = "multi_ret=" .. tostring(ok9) .. ":" .. tostring(b9)

-- Test 10: Error in metamethod
local mt = {
    __add = function() error("meta error") end
}
local obj = setmetatable({}, mt)
local ok10, err10 = pcall(function() return obj + 1 end)
results[#results + 1] = "meta_err=" .. (err10:find("meta error") and "found" or "notfound")

-- Test 11: pcall with arguments
local ok11, res11 = pcall(function(a, b) return a + b end, 10, 20)
results[#results + 1] = "pcall_args=" .. tostring(ok11) .. ":" .. res11

-- Test 12: Error message consistency
local errors = {}
for i = 1, 3 do
    local _, err = pcall(function() error("consistent") end)
    errors[i] = err:find("consistent") and 1 or 0
end
results[#results + 1] = "consistent=" .. (errors[1] + errors[2] + errors[3])

print(table.concat(results, ","))
-- Expected: deterministic across runs
