-- Edge cases for tail calls in various contexts
-- Tests: proper tail call optimization, deep recursion without stack overflow

local results = {}

-- Test 1: Basic tail call
local function tail_basic(n)
    if n <= 0 then return 0 end
    return tail_basic(n - 1)
end
results[#results + 1] = tail_basic(100)  -- 0

-- Test 2: Tail call with accumulator
local function tail_sum(n, acc)
    acc = acc or 0
    if n <= 0 then return acc end
    return tail_sum(n - 1, acc + n)
end
results[#results + 1] = tail_sum(10)  -- 55

-- Test 3: Mutual tail recursion
local function even(n)
    if n == 0 then return true end
    return odd(n - 1)
end

function odd(n)
    if n == 0 then return false end
    return even(n - 1)
end

results[#results + 1] = tostring(even(100))  -- true
results[#results + 1] = tostring(odd(100))   -- false

-- Test 4: Tail call through local function
local function outer(n)
    local function inner(m)
        if m <= 0 then return "done" end
        return inner(m - 1)
    end
    return inner(n)
end
results[#results + 1] = outer(50)  -- done

-- Test 5: NOT a tail call (addition after)
local function not_tail(n)
    if n <= 0 then return 0 end
    return not_tail(n - 1) + 0  -- Not tail call due to + 0
end
results[#results + 1] = not_tail(10)  -- 0

-- Test 6: Tail call in conditional
local function cond_tail(n, flag)
    if n <= 0 then return flag end
    if flag then
        return cond_tail(n - 1, false)
    else
        return cond_tail(n - 1, true)
    end
end
results[#results + 1] = tostring(cond_tail(10, true))  -- false (alternates, ends on false)

-- Test 7: Tail call with multiple returns
local function multi_tail(n)
    if n <= 0 then return 1, 2, 3 end
    return multi_tail(n - 1)
end

local a, b, c = multi_tail(5)
results[#results + 1] = a  -- 1
results[#results + 1] = b  -- 2
results[#results + 1] = c  -- 3

-- Test 8: Tail call through table method
local obj = {}
function obj:recurse(n)
    if n <= 0 then return "method_done" end
    return self:recurse(n - 1)
end
results[#results + 1] = obj:recurse(20)  -- method_done

-- Test 9: Tail call with varargs
local function vararg_tail(n, ...)
    if n <= 0 then return select("#", ...) end
    return vararg_tail(n - 1, ...)
end
results[#results + 1] = vararg_tail(10, "a", "b", "c")  -- 3

-- Test 10: Deep tail recursion (would overflow without TCO)
local function deep_tail(n)
    if n <= 0 then return "deep" end
    return deep_tail(n - 1)
end
results[#results + 1] = deep_tail(1000)  -- deep

-- Test 11: Tail call in pcall (pcall itself prevents TCO internally)
local function pcall_inner(n)
    if n <= 0 then return "pcall_done" end
    return pcall_inner(n - 1)
end

local ok, res = pcall(pcall_inner, 50)
results[#results + 1] = tostring(ok)  -- true
results[#results + 1] = res           -- pcall_done

-- Test 12: Tail call with closure
local function make_counter()
    local count = 0
    local function counter(n)
        if n <= 0 then return count end
        count = count + 1
        return counter(n - 1)
    end
    return counter
end

local counter = make_counter()
results[#results + 1] = counter(10)  -- 10

-- Test 13: Tail call vs return in parentheses (NOT a tail call)
local function paren_return(n)
    if n <= 0 then return 42 end
    return (paren_return(n - 1))  -- Parentheses force single value, might affect TCO
end
results[#results + 1] = paren_return(5)  -- 42

-- Test 14: Tail call in loop
local function loop_tail(n, acc)
    acc = acc or 0
    while true do
        if n <= 0 then return acc end
        return loop_tail(n - 1, acc + 1)  -- Tail call exits loop
    end
end
results[#results + 1] = loop_tail(10)  -- 10

-- Test 15: Fibonacci with tail recursion
local function fib_tail(n, a, b)
    a = a or 0
    b = b or 1
    if n == 0 then return a end
    if n == 1 then return b end
    return fib_tail(n - 1, b, a + b)
end
results[#results + 1] = fib_tail(10)  -- 55

print(table.concat(results, ","))
-- Expected: 0,55,true,false,done,0,false,1,2,3,method_done,3,deep,true,pcall_done,10,42,10,55
