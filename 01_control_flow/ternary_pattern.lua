-- Test: Ternary-like patterns (and/or idiom)
local results = {}

-- Test 1: Basic ternary pattern
local x = 10
local msg = x > 5 and "big" or "small"
results[#results + 1] = "basic=" .. msg

-- Test 2: Ternary with false value (gotcha!)
local flag = true
local val = flag and false or "default"  -- Returns "default" because false is falsy
results[#results + 1] = "false_gotcha=" .. tostring(val)

-- Test 3: Safe ternary for boolean
local function ternary(cond, t, f)
    if cond then return t else return f end
end
local safe_val = ternary(true, false, "default")
results[#results + 1] = "safe=" .. tostring(safe_val)

-- Test 4: Nested ternary
local n = 15
local category = n < 10 and "small" or (n < 20 and "medium" or "large")
results[#results + 1] = "nested=" .. category

-- Test 5: Ternary with function calls
local function getA() return "A" end
local function getB() return "B" end
local cond = true
local result = cond and getA() or getB()
results[#results + 1] = "func=" .. result

-- Test 6: Ternary with nil (another gotcha)
local function maybeNil(returnNil)
    if returnNil then return nil else return "value" end
end
local maybe = true and maybeNil(true) or "fallback"  -- Returns "fallback" because nil is falsy
results[#results + 1] = "nil_gotcha=" .. maybe

print(table.concat(results, ","))
-- Expected: basic=big,false_gotcha=default,safe=false,nested=medium,func=A,nil_gotcha=fallback
