-- Test: Varargs with pcall/xpcall
local results = {}

-- Test 1: pcall with varargs function
local function varfunc(...)
    local sum = 0
    for i = 1, select("#", ...) do
        sum = sum + select(i, ...)
    end
    return sum
end
local ok, result = pcall(varfunc, 1, 2, 3, 4, 5)
results[#results + 1] = "pcall_sum=" .. tostring(ok) .. ":" .. result

-- Test 2: pcall returning multiple values
local function multiReturn(...)
    return ...
end
local ok2, a, b, c = pcall(multiReturn, 10, 20, 30)
results[#results + 1] = "pcall_multi=" .. tostring(ok2) .. ":" .. a .. ";" .. b .. ";" .. c

-- Test 3: pcall with error
local function mayError(shouldError, ...)
    if shouldError then error("fail") end
    return ...
end
local ok3, err = pcall(mayError, true, 1, 2, 3)
results[#results + 1] = "pcall_err=" .. tostring(ok3)

local ok4, v1, v2 = pcall(mayError, false, 100, 200)
results[#results + 1] = "pcall_ok=" .. tostring(ok4) .. ":" .. v1 .. ";" .. v2

-- Test 4: xpcall with varargs
local errMsg = nil
local function errorHandler(err)
    errMsg = "caught:" .. tostring(err):match(".*:(.*)")
    return errMsg
end
local function riskyVarargs(...)
    local n = select("#", ...)
    if n < 3 then error("too few") end
    return n
end
local ok5, result5 = xpcall(function() return riskyVarargs(1, 2) end, errorHandler)
results[#results + 1] = "xpcall=" .. tostring(ok5)

-- Test 5: Pass function with varargs to pcall
local function createAdder(base)
    return function(...)
        local sum = base
        for i = 1, select("#", ...) do
            sum = sum + select(i, ...)
        end
        return sum
    end
end
local adder = createAdder(100)
local ok6, sum6 = pcall(adder, 1, 2, 3)
results[#results + 1] = "pcall_closure=" .. tostring(ok6) .. ":" .. sum6

print(table.concat(results, ","))
-- Expected: pcall_sum=true:15,pcall_multi=true:10;20;30,pcall_err=false,pcall_ok=true:100;200,xpcall=false,pcall_closure=true:106
