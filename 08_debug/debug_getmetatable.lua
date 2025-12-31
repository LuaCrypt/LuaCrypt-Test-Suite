-- Test: debug.getmetatable and debug.setmetatable
local results = {}

-- Test 1: Basic getmetatable
local t1 = {}
local mt1 = {__index = {x = 10}}
setmetatable(t1, mt1)
local got1 = debug.getmetatable(t1)
results[#results + 1] = "basic=" .. tostring(got1 == mt1)

-- Test 2: debug.getmetatable bypasses __metatable
local t2 = {}
local mt2 = {__metatable = "protected"}
setmetatable(t2, mt2)
local normal = getmetatable(t2)
local debug_mt = debug.getmetatable(t2)
results[#results + 1] = "protected=" .. (normal == "protected" and debug_mt == mt2 and "bypass" or "fail")

-- Test 3: Get string metatable
local str_mt = debug.getmetatable("")
results[#results + 1] = "str=" .. (str_mt and "has" or "nil")

-- Test 4: Get number metatable
local num_mt = debug.getmetatable(42)
results[#results + 1] = "num=" .. tostring(num_mt)

-- Test 5: debug.setmetatable on string
if debug.setmetatable then
    local old_str_mt = debug.getmetatable("")
    local new_mt = {}
    debug.setmetatable("", new_mt)
    local check = debug.getmetatable("")
    debug.setmetatable("", old_str_mt)  -- restore
    results[#results + 1] = "setstr=" .. tostring(check == new_mt)
end

-- Test 6: Set number metatable
if debug.setmetatable then
    local old_num_mt = debug.getmetatable(0)
    local num_mt = {
        __add = function(a, b) return "custom_add" end
    }
    debug.setmetatable(0, num_mt)
    -- Note: this affects all numbers
    local check = debug.getmetatable(42)
    debug.setmetatable(0, old_num_mt)  -- restore
    results[#results + 1] = "setnum=" .. (check == num_mt and "set" or "fail")
end

-- Test 7: nil metatable
local t7 = setmetatable({}, {})
debug.setmetatable(t7, nil)
results[#results + 1] = "nilmt=" .. tostring(debug.getmetatable(t7))

-- Test 8: Boolean metatable
local bool_mt = debug.getmetatable(true)
results[#results + 1] = "bool=" .. tostring(bool_mt)

-- Test 9: Function metatable
local fn_mt = debug.getmetatable(function() end)
results[#results + 1] = "func=" .. tostring(fn_mt)

-- Test 10: Coroutine metatable
local co = coroutine.create(function() end)
local co_mt = debug.getmetatable(co)
results[#results + 1] = "coro=" .. (co_mt and "has" or "nil")

-- Test 11: Set and verify metatable functionality
local t11 = {}
debug.setmetatable(t11, {
    __index = function(t, k) return "default_" .. k end
})
results[#results + 1] = "func_mt=" .. t11.test

print(table.concat(results, ","))
-- Expected: basic=true,protected=bypass,str=has,num=nil,setstr=true,setnum=set,nilmt=nil,bool=nil,func=nil,coro=has,func_mt=default_test
