-- Test: Function-level scoping
local results = {}

-- Test 1: Parameters are local to function
local function testParams(a, b)
    a = a + 1
    b = b + 1
    return a + b
end
local x, y = 10, 20
results[#results + 1] = "params=" .. testParams(x, y) .. "_orig=" .. x .. ";" .. y

-- Test 2: Nested function parameters
local function outer(a)
    local function inner(b)
        return a + b
    end
    return inner(a * 2)
end
results[#results + 1] = "nested_params=" .. outer(5)

-- Test 3: Function expression scope
local f = function(x)
    return function(y)
        return x + y
    end
end
results[#results + 1] = "func_expr=" .. f(10)(20)

-- Test 4: Local function vs global function
local function localFunc()
    return "local"
end
function globalFuncTest()
    return "global"
end
results[#results + 1] = "local_func=" .. localFunc()
results[#results + 1] = "global_func=" .. globalFuncTest()
globalFuncTest = nil  -- Cleanup

-- Test 5: Function defined inside another function
local function outer2()
    local function inner2()
        return "inner"
    end
    return inner2()
end
results[#results + 1] = "inner_func=" .. outer2()

-- Test 6: Forward declaration
local fwd
local function useFwd()
    return fwd()
end
fwd = function()
    return "forward"
end
results[#results + 1] = "forward=" .. useFwd()

print(table.concat(results, ","))
-- Expected: params=32_orig=10;20,nested_params=15,func_expr=30,local_func=local,global_func=global,inner_func=inner,forward=forward
