-- Test: Edge cases for return
local results = {}

-- Test 1: Return from anonymous function
local anon = function(x)
    if x > 0 then return "pos" end
    return "neg"
end
results[#results + 1] = "anon=" .. anon(5) .. ";" .. anon(-5)

-- Test 2: Return from method
local obj = {
    value = 100,
    getValue = function(self)
        return self.value
    end
}
results[#results + 1] = "method=" .. obj:getValue()

-- Test 3: Return from nested function
local function outer2()
    local function inner2()
        return "inner"
    end
    return inner2() .. "_outer"
end
results[#results + 1] = "nested=" .. outer2()

-- Test 4: Return affects only current function
local inner_result = nil
local function outerFunc()
    local function innerFunc()
        return "from_inner"  -- Returns from innerFunc, not outerFunc
    end
    inner_result = innerFunc()
    return "from_outer"
end
results[#results + 1] = "scope=" .. outerFunc() .. ";" .. inner_result

-- Test 5: Return with vararg
local function varargReturn(...)
    return ...
end
local v1, v2, v3 = varargReturn(10, 20, 30)
results[#results + 1] = "vararg=" .. v1 .. ";" .. v2 .. ";" .. v3

-- Test 6: Return in pcall
local function mayFail(shouldFail)
    if shouldFail then
        error("oops")
    end
    return "success"
end
local ok1, result1 = pcall(mayFail, false)
local ok2, result2 = pcall(mayFail, true)
results[#results + 1] = "pcall=" .. tostring(ok1) .. ";" .. result1

print(table.concat(results, ","))
-- Expected: anon=pos;neg,method=100,nested=inner_outer,scope=from_outer;from_inner,vararg=10;20;30,pcall=true;success
