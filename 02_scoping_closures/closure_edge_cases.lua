-- Test: Edge cases for closures
local results = {}

-- Test 1: Closure with no upvalues (just uses globals/locals from call)
local function noUpvalues()
    local x = 10
    return x
end
results[#results + 1] = "no_upval=" .. noUpvalues()

-- Test 2: Closure only using parameters
local function onlyParams(a, b)
    return function()
        return a + b
    end
end
local f = onlyParams(3, 4)
results[#results + 1] = "only_params=" .. f()

-- Test 3: Many upvalues
local v1, v2, v3, v4, v5 = 1, 2, 3, 4, 5
local function manyUpvals()
    return v1 + v2 + v3 + v4 + v5
end
results[#results + 1] = "many=" .. manyUpvals()

-- Test 4: Upvalue is a table
local tbl = {x = 10, y = 20}
local function getTblSum()
    return tbl.x + tbl.y
end
results[#results + 1] = "tbl_upval1=" .. getTblSum()
tbl.x = 100
results[#results + 1] = "tbl_upval2=" .. getTblSum()

-- Test 5: Upvalue is a function
local function helper(x)
    return x * 2
end
local function useHelper(n)
    return helper(n)
end
results[#results + 1] = "func_upval=" .. useHelper(5)

-- Test 6: Closure captures itself indirectly
local selfRef
local function setupSelf()
    selfRef = function(n)
        if n <= 0 then return 0 end
        return n + selfRef(n - 1)
    end
end
setupSelf()
results[#results + 1] = "self_indirect=" .. selfRef(4)

print(table.concat(results, ","))
-- Expected: no_upval=10,only_params=7,many=15,tbl_upval1=30,tbl_upval2=120,func_upval=10,self_indirect=10
