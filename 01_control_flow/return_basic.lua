-- Test: Basic return statements
local results = {}

-- Test 1: Simple return value
local function getValue()
    return 42
end
results[#results + 1] = "simple=" .. getValue()

-- Test 2: Return nil (implicit and explicit)
local function returnNil()
    return nil
end
local function returnNothing()
    return
end
local function noReturn()
    local x = 1
end
results[#results + 1] = "nil1=" .. tostring(returnNil())
local rn = returnNothing()
results[#results + 1] = "nil2=" .. tostring(rn)
local nr = noReturn()
results[#results + 1] = "nil3=" .. tostring(nr)

-- Test 3: Multiple return values
local function multiReturn()
    return 1, 2, 3
end
local a, b, c = multiReturn()
results[#results + 1] = "multi=" .. a .. ";" .. b .. ";" .. c

-- Test 4: Return expression
local function returnExpr(x)
    return x * 2 + 1
end
results[#results + 1] = "expr=" .. returnExpr(5)

-- Test 5: Return function call result
local function inner()
    return 100
end
local function outer()
    return inner()
end
results[#results + 1] = "nested=" .. outer()

-- Test 6: Return table
local function returnTable()
    return {a = 1, b = 2}
end
local t = returnTable()
results[#results + 1] = "table=" .. t.a .. ";" .. t.b

print(table.concat(results, ","))
-- Expected: simple=42,nil1=nil,nil2=nil,nil3=nil,multi=1;2;3,expr=11,nested=100,table=1;2
