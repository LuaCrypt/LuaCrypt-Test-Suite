-- Test: Error handling semantics
local results = {}

-- Test 1: error with level
local function level2()
    error("test", 2)
end
local function level1()
    level2()
end
local ok1, err1 = pcall(level1)
results[#results + 1] = "level=" .. (err1:find("level1") and "correct" or "wrong")

-- Test 2: error with level 0
local function zero_level()
    error("zero", 0)
end
local ok2, err2 = pcall(zero_level)
results[#results + 1] = "zero=" .. (type(err2) == "string" and "string" or "other")

-- Test 3: error with non-string
local function err_table()
    error({code = 42})
end
local ok3, err3 = pcall(err_table)
results[#results + 1] = "tbl_err=" .. (type(err3) == "table" and err3.code or "converted")

-- Test 4: pcall with multiple returns
local function multi_ok()
    return 1, 2, 3
end
local ok4, a4, b4, c4 = pcall(multi_ok)
results[#results + 1] = "pcall_multi=" .. (a4 + b4 + c4)

-- Test 5: xpcall handler
local function handler(err)
    return "handled: " .. tostring(err)
end
local ok5, err5 = xpcall(function() error("test") end, handler)
results[#results + 1] = "xpcall=" .. (err5:find("handled") and "handled" or "raw")

-- Test 6: assert with custom message
local ok6, err6 = pcall(function()
    assert(false, "custom message")
end)
results[#results + 1] = "assert=" .. (err6:find("custom") and "custom" or "default")

-- Test 7: assert with multiple values
local function assert_multi()
    return assert(1, 2, 3)
end
local a7, b7, c7 = assert_multi()
results[#results + 1] = "assert_ret=" .. (a7 + b7 + c7)

-- Test 8: Nested pcall
local ok8 = pcall(function()
    local ok_inner = pcall(function()
        error("inner")
    end)
    if not ok_inner then
        error("outer")
    end
end)
results[#results + 1] = "nested=" .. (ok8 and "ok" or "caught")

-- Test 9: Error in metamethod
local mt = {
    __add = function()
        error("metamethod error")
    end
}
local obj = setmetatable({}, mt)
local ok9, err9 = pcall(function() return obj + 1 end)
results[#results + 1] = "mt_err=" .. (err9:find("metamethod") and "caught" or "other")

-- Test 10: Error in __tostring
local mt10 = {
    __tostring = function()
        error("tostring error")
    end
}
local obj10 = setmetatable({}, mt10)
local ok10 = pcall(function()
    return tostring(obj10)
end)
results[#results + 1] = "tostr_err=" .. (ok10 and "ok" or "caught")

-- Test 11: pcall preserves tail call
local function tail_error()
    return error("tail")
end
local ok11, err11 = pcall(tail_error)
results[#results + 1] = "tail_err=" .. (err11:find("tail") and "caught" or "other")

-- Test 12: Error recovery and continuation
local recovered = false
local ok12 = pcall(function()
    pcall(function() error("recover") end)
    recovered = true
end)
results[#results + 1] = "recover=" .. (recovered and "yes" or "no")

print(table.concat(results, ","))
-- Expected: level=correct,zero=string,tbl_err=42,pcall_multi=6,xpcall=handled,assert=custom,assert_ret=6,nested=caught,mt_err=caught,tostr_err=caught,tail_err=caught,recover=yes
