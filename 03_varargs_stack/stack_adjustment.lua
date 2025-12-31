-- Test: Stack adjustment in various contexts
local results = {}

local function three()
    return 1, 2, 3
end

local function two()
    return "a", "b"
end

-- Test 1: Last expression in table gets all values
local t1 = {three()}
results[#results + 1] = "tbl_last=" .. #t1

-- Test 2: Not last in table - only first
local t2 = {three(), 99}
results[#results + 1] = "tbl_middle=" .. #t2 .. ":" .. t2[1] .. ";" .. t2[2]

-- Test 3: Function call in middle of args
local function sum(a, b, c)
    return (a or 0) + (b or 0) + (c or 0)
end
results[#results + 1] = "call_middle=" .. sum(three(), 10)

-- Test 4: Function call as last arg
results[#results + 1] = "call_last=" .. sum(10, three())

-- Test 5: Return adjusts to single in expression
local function returnInExpr()
    return three() + 10  -- three() adjusted to 1 value
end
results[#results + 1] = "return_expr=" .. returnInExpr()

-- Test 6: Concatenation
local s = two() .. "_" .. three()
results[#results + 1] = "concat=" .. s

-- Test 7: In conditional (single value)
local cond = (three()) and "yes" or "no"
results[#results + 1] = "cond=" .. cond

-- Test 8: Comparison (single values)
local cmp = (three()) == (three())
results[#results + 1] = "compare=" .. tostring(cmp)

print(table.concat(results, ","))
-- Expected: tbl_last=3,tbl_middle=2:1;99,call_middle=11,call_last=16,return_expr=11,concat=a_1,cond=yes,compare=true
