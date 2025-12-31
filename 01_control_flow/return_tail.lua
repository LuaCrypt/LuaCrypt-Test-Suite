-- Test: Tail call returns
local results = {}

-- Test 1: Simple tail call
local function inner(x)
    return x * 2
end
local function outer(x)
    return inner(x)  -- Tail call
end
results[#results + 1] = "tail=" .. outer(5)

-- Test 2: Tail call chain
local function a(x)
    return x + 1
end
local function b(x)
    return a(x + 1)  -- Tail call
end
local function c(x)
    return b(x + 1)  -- Tail call
end
results[#results + 1] = "chain=" .. c(1)  -- 1+1+1+1=4

-- Test 3: Recursive tail call
local function factorial(n, acc)
    acc = acc or 1
    if n <= 1 then
        return acc
    end
    return factorial(n - 1, n * acc)  -- Tail recursive
end
results[#results + 1] = "fact=" .. factorial(5)

-- Test 4: Mutual tail recursion
local function even(n)
    if n == 0 then return true end
    return odd(n - 1)
end
function odd(n)
    if n == 0 then return false end
    return even(n - 1)
end
results[#results + 1] = "even10=" .. tostring(even(10))
results[#results + 1] = "odd7=" .. tostring(odd(7))

-- Test 5: NOT a tail call (has operation after)
local function notTail(x)
    return inner(x) + 1  -- NOT a tail call because of +1
end
results[#results + 1] = "not_tail=" .. notTail(5)

-- Test 6: Conditional tail calls
local function dispatch(op, x)
    if op == "double" then
        return inner(x)
    elseif op == "triple" then
        return x * 3
    end
    return x
end
results[#results + 1] = "dispatch=" .. dispatch("double", 4) .. ";" .. dispatch("triple", 3)

print(table.concat(results, ","))
-- Expected: tail=10,chain=4,fact=120,even10=true,odd7=true,not_tail=11,dispatch=8;9
