-- Test: Function semantics differences
local results = {}

-- Test 1: Multiple return values
local function multi_ret()
    return 1, 2, 3
end
local a, b, c = multi_ret()
results[#results + 1] = "multi=" .. a .. b .. c

-- Test 2: Adjustment in assignment
local x, y = multi_ret()
results[#results + 1] = "adjust=" .. x .. y

-- Test 3: Return in parentheses
local function paren_ret()
    return (multi_ret())
end
local p1, p2 = paren_ret()
results[#results + 1] = "paren=" .. p1 .. (p2 or "nil")

-- Test 4: Tail call
local function tail_target(n)
    return n
end
local function tail_caller(n)
    return tail_target(n)
end
results[#results + 1] = "tail=" .. tail_caller(42)

-- Test 5: Vararg handling
local function vararg_count(...)
    return select('#', ...)
end
results[#results + 1] = "vararg=" .. vararg_count(1, nil, 3, nil, nil)

-- Test 6: Named arguments pattern
local function named(opts)
    return (opts.a or 0) + (opts.b or 0)
end
results[#results + 1] = "named=" .. named{a = 1, b = 2}

-- Test 7: Method call syntax
local obj = {
    value = 10,
    get = function(self)
        return self.value
    end
}
results[#results + 1] = "method=" .. obj:get()

-- Test 8: Closure over loop variable
local funcs = {}
for i = 1, 3 do
    funcs[i] = function() return i end
end
results[#results + 1] = "loop_closure=" .. funcs[1]() .. funcs[2]() .. funcs[3]()

-- Test 9: Default arguments pattern
local function with_default(a, b)
    b = b or 10
    return a + b
end
results[#results + 1] = "default=" .. with_default(5)

-- Test 10: Multiple assignment from function
local function two_vals()
    return 1, 2
end
local t = {two_vals()}
results[#results + 1] = "tbl_multi=" .. #t

-- Test 11: Function as expression
local result = (function() return 42 end)()
results[#results + 1] = "iife=" .. result

-- Test 12: Recursive local function
local function fib(n)
    if n <= 1 then return n end
    return fib(n - 1) + fib(n - 2)
end
results[#results + 1] = "recurse=" .. fib(10)

-- Test 13: Forward declaration pattern
local forward
local function uses_forward()
    return forward()
end
forward = function()
    return "forward"
end
results[#results + 1] = "forward=" .. uses_forward()

-- Test 14: Vararg in table constructor
local function make_table(...)
    return {...}
end
local vt = make_table(1, 2, 3)
results[#results + 1] = "vararg_tbl=" .. #vt

print(table.concat(results, ","))
-- Expected: multi=123,adjust=12,paren=1nil,tail=42,vararg=5,named=3,method=10,loop_closure=123,default=15,tbl_multi=2,iife=42,recurse=55,forward=forward,vararg_tbl=3
