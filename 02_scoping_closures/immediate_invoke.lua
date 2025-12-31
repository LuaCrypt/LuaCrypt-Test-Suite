-- Test: Immediately invoked function expressions (IIFE)
local results = {}

-- Test 1: Simple IIFE
local result1 = (function()
    return 42
end)()
results[#results + 1] = "simple=" .. result1

-- Test 2: IIFE with parameter
local result2 = (function(x)
    return x * 2
end)(21)
results[#results + 1] = "param=" .. result2

-- Test 3: IIFE creating closure
local counter = (function()
    local count = 0
    return function()
        count = count + 1
        return count
    end
end)()
results[#results + 1] = "closure=" .. counter() .. ";" .. counter()

-- Test 4: IIFE for scope isolation
local outer = 100
local inner_result = (function()
    local outer = 200  -- Shadows
    return outer
end)()
results[#results + 1] = "isolate=" .. inner_result .. "_outer=" .. outer

-- Test 5: Nested IIFE
local nested = (function()
    return (function()
        return (function()
            return "deep"
        end)()
    end)()
end)()
results[#results + 1] = "nested=" .. nested

-- Test 6: IIFE with multiple returns
local a, b, c = (function()
    return 1, 2, 3
end)()
results[#results + 1] = "multi=" .. a .. ";" .. b .. ";" .. c

-- Test 7: IIFE with upvalue from outer scope
local factor = 10
local scaled = (function()
    return factor * 5
end)()
results[#results + 1] = "upval=" .. scaled

print(table.concat(results, ","))
-- Expected: simple=42,param=42,closure=1;2,isolate=200_outer=100,nested=deep,multi=1;2;3,upval=50
