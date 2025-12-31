-- Test: assert() function
local results = {}

-- Test 1: Assert with true
local ok1, res1 = pcall(function()
    return assert(true, "should not see this")
end)
results[#results + 1] = "true=" .. tostring(ok1)

-- Test 2: Assert with false
local ok2, err2 = pcall(function()
    assert(false, "assertion failed")
end)
results[#results + 1] = "false=" .. tostring(ok2) .. ":" .. (string.find(err2, "assertion failed") and "msg" or "no_msg")

-- Test 3: Assert returns values
local ok3, a, b, c = pcall(function()
    return assert(1, 2, 3)
end)
results[#results + 1] = "return=" .. a .. ";" .. tostring(b) .. ";" .. tostring(c)

-- Test 4: Assert with nil
local ok4, err4 = pcall(function()
    assert(nil)
end)
results[#results + 1] = "nil=" .. tostring(ok4)

-- Test 5: Assert with expression
local function getValue()
    return 42
end
local ok5, val = pcall(function()
    return assert(getValue() > 0 and getValue())
end)
results[#results + 1] = "expr=" .. tostring(val)

-- Test 6: Assert in chain
local ok6, res6 = pcall(function()
    local x = assert(10)
    local y = assert(20)
    return x + y
end)
results[#results + 1] = "chain=" .. res6

-- Test 7: Assert with function call
local function maybeNil(returnNil)
    if returnNil then return nil, "was nil" end
    return "value"
end
local ok7, res7 = pcall(function()
    return assert(maybeNil(false))
end)
results[#results + 1] = "func=" .. res7

print(table.concat(results, ","))
-- Expected: true=true,false=false:msg,return=1;2;3,nil=false,expr=42,chain=30,func=value
