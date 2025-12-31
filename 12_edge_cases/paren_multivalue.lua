-- Edge cases for parenthesized expressions forcing single-value adjustment
-- Tests the fix for: (f()) should return only first value

local results = {}

-- Helper to return multiple values
local function multi(...)
    return ...
end

local function three()
    return 1, 2, 3
end

local function none()
    return
end

-- Test 1: Basic parenthesized multi-return
local a = (three())
results[#results + 1] = a  -- Should be 1, not 1,2,3

-- Test 2: Parenthesized in arithmetic
local b = (three()) + 10
results[#results + 1] = b  -- Should be 11

-- Test 3: Parenthesized in concatenation
local c = (multi("a", "b", "c")) .. "x"
results[#results + 1] = c  -- Should be "ax"

-- Test 4: Nested parentheses
local d = ((three()))
results[#results + 1] = d  -- Should be 1

-- Test 5: Parenthesized nil return
local e = (none()) or "default"
results[#results + 1] = e  -- Should be "default"

-- Test 6: Parenthesized in function call (single arg)
local function sum(x)
    return x or 0
end
local f = sum((three()))
results[#results + 1] = f  -- Should be 1

-- Test 7: Parenthesized in table constructor
local t = { (three()) }
results[#results + 1] = #t  -- Should be 1

-- Test 8: Parenthesized vs non-parenthesized comparison
local t2 = { three() }
results[#results + 1] = #t2  -- Should be 3

-- Test 9: Parenthesized in binary operation
local g = (three()) * (three())
results[#results + 1] = g  -- Should be 1

-- Test 10: Parenthesized with method call
local obj = {
    get = function(self)
        return 10, 20, 30
    end
}
local h = (obj:get())
results[#results + 1] = h  -- Should be 10

-- Test 11: Parenthesized in conditional
local i = (three()) == 1
results[#results + 1] = tostring(i)  -- Should be "true"

-- Test 12: Double parentheses with expression
local j = ((1 + 2))
results[#results + 1] = j  -- Should be 3

-- Test 13: Parenthesized select
local k = (select(2, 10, 20, 30))
results[#results + 1] = k  -- Should be 20

-- Test 14: Parenthesized unpack
local arr = {100, 200, 300}
local unpack = unpack or table.unpack
local l = (unpack(arr))
results[#results + 1] = l  -- Should be 100

-- Test 15: Complex nested expression
local function chain()
    return (function() return 5, 6, 7 end)()
end
local m = (chain())
results[#results + 1] = m  -- Should be 5

print(table.concat(results, ","))
-- Expected: 1,11,ax,1,default,1,1,3,1,10,true,3,20,100,5
