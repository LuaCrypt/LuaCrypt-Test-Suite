-- Test: debug.getinfo function
local results = {}

-- Test 1: Get info about current function
local function test_func()
    local info = debug.getinfo(1)
    return info.what, info.nups, info.name
end
local what, nups, name = test_func()
results[#results + 1] = "what=" .. what

-- Test 2: Get info about calling function
local function outer()
    local function inner()
        return debug.getinfo(2, "n")
    end
    return inner()
end
local info2 = outer()
results[#results + 1] = "caller=" .. (info2.name or "nil")

-- Test 3: Source info
local function src_test()
    return debug.getinfo(1, "S")
end
local info3 = src_test()
results[#results + 1] = "src=" .. (info3.source and "has_src" or "no_src")
results[#results + 1] = "short=" .. (info3.short_src and "has" or "no")

-- Test 4: Line info
local function line_test()
    return debug.getinfo(1, "l")
end
local info4 = line_test()
results[#results + 1] = "line=" .. (type(info4.currentline) == "number" and "num" or "other")

-- Test 5: Function info
local function func_info()
    return debug.getinfo(1, "f")
end
local info5 = func_info()
results[#results + 1] = "func=" .. (type(info5.func) == "function" and "fn" or "other")

-- Test 6: Upvalue count
local x = 1
local function upval_test()
    local _ = x
    return debug.getinfo(1, "u")
end
local info6 = upval_test()
results[#results + 1] = "nups=" .. info6.nups

-- Test 7: vararg info
local function vararg_test(...)
    return debug.getinfo(1, "u")
end
local info7 = vararg_test(1, 2, 3)
results[#results + 1] = "isvararg=" .. (info7.isvararg and "yes" or "no")

-- Test 8: Tail call info
local function tail_test()
    return debug.getinfo(1, "t")
end
local info8 = tail_test()
results[#results + 1] = "istail=" .. tostring(info8.istailcall or false)

-- Test 9: Get info for built-in
local info9 = debug.getinfo(print)
results[#results + 1] = "builtin=" .. info9.what

-- Test 10: Level 0 (debug.getinfo itself)
local info10 = debug.getinfo(0)
results[#results + 1] = "level0=" .. info10.what

-- Test 11: Parameters count
local function params_test(a, b, c)
    return debug.getinfo(1, "u")
end
local info11 = params_test(1, 2, 3)
results[#results + 1] = "nparams=" .. (info11.nparams or 0)

print(table.concat(results, ","))
-- Expected varies by Lua version but format should be consistent
