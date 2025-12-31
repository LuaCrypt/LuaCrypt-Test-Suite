-- Test: Basic pcall usage
local results = {}

-- Test 1: Successful call
local ok1, result1 = pcall(function()
    return 42
end)
results[#results + 1] = "success=" .. tostring(ok1) .. ":" .. result1

-- Test 2: Failed call
local ok2, err2 = pcall(function()
    error("fail")
end)
results[#results + 1] = "fail=" .. tostring(ok2)

-- Test 3: Multiple return values
local ok3, a, b, c = pcall(function()
    return 1, 2, 3
end)
results[#results + 1] = "multi=" .. a .. ";" .. b .. ";" .. c

-- Test 4: pcall with arguments
local ok4, sum = pcall(function(x, y)
    return x + y
end, 10, 20)
results[#results + 1] = "args=" .. sum

-- Test 5: pcall with method
local obj = {
    value = 100,
    getValue = function(self) return self.value end
}
local ok5, val = pcall(obj.getValue, obj)
results[#results + 1] = "method=" .. val

-- Test 6: Nil function (should error)
local ok6, err6 = pcall(nil)
results[#results + 1] = "nil_fn=" .. tostring(ok6)

print(table.concat(results, ","))
-- Expected: success=true:42,fail=false,multi=1;2;3,args=30,method=100,nil_fn=false
