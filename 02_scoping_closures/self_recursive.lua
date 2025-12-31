-- Test: Self-recursive closures
local results = {}

-- Test 1: Local function recursion
local function factorial(n)
    if n <= 1 then return 1 end
    return n * factorial(n - 1)
end
results[#results + 1] = "local_rec=" .. factorial(5)

-- Test 2: Self-reference via upvalue
local fib
fib = function(n)
    if n <= 1 then return n end
    return fib(n - 1) + fib(n - 2)
end
results[#results + 1] = "upval_rec=" .. fib(10)

-- Test 3: Anonymous recursive (Y-combinator style)
local function Y(f)
    return function(x)
        return f(f, x)
    end
end
local factorial2 = Y(function(rec, n)
    if n <= 1 then return 1 end
    return n * rec(rec, n - 1)
end)
results[#results + 1] = "y_comb=" .. factorial2(5)

-- Test 4: Mutual recursion
local isEven, isOdd
isEven = function(n)
    if n == 0 then return true end
    return isOdd(n - 1)
end
isOdd = function(n)
    if n == 0 then return false end
    return isEven(n - 1)
end
results[#results + 1] = "mutual=" .. tostring(isEven(10)) .. ";" .. tostring(isOdd(7))

-- Test 5: Recursive closure inside factory
local function makeRecursive()
    local function rec(n)
        if n <= 0 then return 0 end
        return n + rec(n - 1)
    end
    return rec
end
local sum = makeRecursive()
results[#results + 1] = "factory_rec=" .. sum(5)

-- Test 6: Self-modifying recursive (with state)
local function makeCountingRec()
    local calls = 0
    local function rec(n)
        calls = calls + 1
        if n <= 1 then return 1 end
        return n * rec(n - 1)
    end
    return rec, function() return calls end
end
local fact, getCalls = makeCountingRec()
fact(4)
results[#results + 1] = "counted=" .. getCalls()

print(table.concat(results, ","))
-- Expected: local_rec=120,upval_rec=55,y_comb=120,mutual=true;true,factory_rec=15,counted=4
