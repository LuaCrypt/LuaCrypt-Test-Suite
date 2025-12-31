-- Test: Recursion pattern integrity
local results = {}

-- Test 1: Direct recursion
local function factorial(n)
    if n <= 1 then return 1 end
    return n * factorial(n - 1)
end
results[#results + 1] = "direct=" .. factorial(10)

-- Test 2: Tail recursion
local function tail_factorial(n, acc)
    acc = acc or 1
    if n <= 1 then return acc end
    return tail_factorial(n - 1, n * acc)
end
results[#results + 1] = "tail=" .. tail_factorial(10)

-- Test 3: Mutual recursion
local is_even, is_odd
is_even = function(n)
    if n == 0 then return true end
    return is_odd(n - 1)
end
is_odd = function(n)
    if n == 0 then return false end
    return is_even(n - 1)
end
results[#results + 1] = "mutual=" .. tostring(is_even(100)) .. ":" .. tostring(is_odd(100))

-- Test 4: Tree recursion (fibonacci)
local function fib(n)
    if n <= 1 then return n end
    return fib(n - 1) + fib(n - 2)
end
results[#results + 1] = "tree=" .. fib(15)

-- Test 5: Memoized recursion
local function memoize(fn)
    local cache = {}
    return function(n)
        if cache[n] == nil then
            cache[n] = fn(n)
        end
        return cache[n]
    end
end
local memo_fib
memo_fib = memoize(function(n)
    if n <= 1 then return n end
    return memo_fib(n - 1) + memo_fib(n - 2)
end)
results[#results + 1] = "memo=" .. memo_fib(30)

-- Test 6: Recursive data structure traversal
local tree = {
    value = 1,
    children = {
        {value = 2, children = {{value = 4, children = {}}, {value = 5, children = {}}}},
        {value = 3, children = {{value = 6, children = {}}}}
    }
}
local function sum_tree(node)
    local total = node.value
    for _, child in ipairs(node.children) do
        total = total + sum_tree(child)
    end
    return total
end
results[#results + 1] = "tree_sum=" .. sum_tree(tree)

-- Test 7: Deep recursion with closures
local function create_counter_chain(n)
    if n <= 0 then
        return function() return 0 end
    end
    local next = create_counter_chain(n - 1)
    return function()
        return n + next()
    end
end
local chain = create_counter_chain(10)
results[#results + 1] = "closure_chain=" .. chain()

-- Test 8: Recursive accumulator
local function sum_list(list, index, acc)
    index = index or 1
    acc = acc or 0
    if index > #list then return acc end
    return sum_list(list, index + 1, acc + list[index])
end
results[#results + 1] = "accum=" .. sum_list({1, 2, 3, 4, 5, 6, 7, 8, 9, 10})

-- Test 9: Recursive pattern matching
local function count_occurrences(str, pattern, pos, count)
    pos = pos or 1
    count = count or 0
    local s, e = string.find(str, pattern, pos, true)
    if not s then return count end
    return count_occurrences(str, pattern, e + 1, count + 1)
end
results[#results + 1] = "pattern=" .. count_occurrences("abababab", "ab")

-- Test 10: CPS (Continuation Passing Style)
local function cps_factorial(n, cont)
    if n <= 1 then
        return cont(1)
    end
    return cps_factorial(n - 1, function(result)
        return cont(n * result)
    end)
end
local cps_result
cps_factorial(10, function(r) cps_result = r end)
results[#results + 1] = "cps=" .. cps_result

-- Test 11: Y combinator style
local function Y(f)
    return (function(x)
        return f(function(...)
            return x(x)(...)
        end)
    end)(function(x)
        return f(function(...)
            return x(x)(...)
        end)
    end)
end
local fact_y = Y(function(rec)
    return function(n)
        if n <= 1 then return 1 end
        return n * rec(n - 1)
    end
end)
results[#results + 1] = "ycomb=" .. fact_y(10)

print(table.concat(results, ","))
-- Expected: direct=3628800,tail=3628800,mutual=true:false,tree=610,memo=832040,tree_sum=21,closure_chain=55,accum=55,pattern=4,cps=3628800,ycomb=3628800
