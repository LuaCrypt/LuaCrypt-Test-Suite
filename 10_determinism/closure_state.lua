-- Test: Closure state determinism
local results = {}

-- Test 1: Closure factory produces identical behavior
local function make_counter(start)
    local count = start
    return function()
        count = count + 1
        return count
    end
end

local c1 = make_counter(0)
local c2 = make_counter(0)
local seq1 = {}
local seq2 = {}
for i = 1, 5 do
    seq1[i] = c1()
    seq2[i] = c2()
end
local same = true
for i = 1, 5 do
    if seq1[i] ~= seq2[i] then same = false end
end
results[#results + 1] = "counter=" .. tostring(same)

-- Test 2: Nested closure state
local function outer(x)
    return function(y)
        return function(z)
            return x + y + z
        end
    end
end
local f1 = outer(1)(2)(3)
local f2 = outer(1)(2)(3)
results[#results + 1] = "nested=" .. f1 .. ":" .. f2

-- Test 3: Memoization closure
local function memoize(fn)
    local cache = {}
    return function(x)
        if cache[x] == nil then
            cache[x] = fn(x)
        end
        return cache[x]
    end
end
local fib_raw = nil
fib_raw = function(n)
    if n <= 1 then return n end
    return fib_raw(n - 1) + fib_raw(n - 2)
end
local fib = memoize(fib_raw)
local memo_results = {}
for i = 1, 10 do
    memo_results[i] = fib(i)
end
results[#results + 1] = "memo=" .. table.concat(memo_results, ":")

-- Test 4: Closure mutation order
local shared = 0
local function inc() shared = shared + 1; return shared end
local function dec() shared = shared - 1; return shared end
local mut_seq = {}
mut_seq[1] = inc()
mut_seq[2] = inc()
mut_seq[3] = dec()
mut_seq[4] = inc()
results[#results + 1] = "mutation=" .. table.concat(mut_seq, ":")

-- Test 5: Multiple closures over same variable
local x = 0
local get = function() return x end
local set = function(v) x = v end
local add = function(v) x = x + v end

set(10)
add(5)
local after = get()
results[#results + 1] = "shared=" .. after

-- Test 6: Closure in loop consistency
local loop_funcs = {}
for i = 1, 5 do
    loop_funcs[i] = function() return i end
end
local loop_vals = {}
for i = 1, 5 do
    loop_vals[i] = loop_funcs[i]()
end
results[#results + 1] = "loop=" .. table.concat(loop_vals, ":")

-- Test 7: Recursive closure state
local function make_tree_counter()
    local count = 0
    local function traverse(depth)
        count = count + 1
        if depth > 0 then
            traverse(depth - 1)
            traverse(depth - 1)
        end
        return count
    end
    return traverse
end
local tree = make_tree_counter()
local tree_result = tree(3)
results[#results + 1] = "tree=" .. tree_result

-- Test 8: Closure identity
local make_fn = function()
    return function() return 42 end
end
local fn1 = make_fn()
local fn2 = make_fn()
results[#results + 1] = "identity=" .. tostring(fn1 ~= fn2) .. ":" .. tostring(fn1() == fn2())

-- Test 9: Upvalue chain determinism
local function chain()
    local a = 1
    return function()
        local b = a + 1
        return function()
            local c = b + 1
            return a + b + c
        end
    end
end
results[#results + 1] = "chain=" .. chain()()()

-- Test 10: State reset pattern
local function stateful()
    local state = 0
    return {
        get = function() return state end,
        set = function(v) state = v end,
        inc = function() state = state + 1 return state end
    }
end
local s = stateful()
s.set(100)
local vals = {s.inc(), s.inc(), s.inc()}
results[#results + 1] = "state=" .. table.concat(vals, ":")

print(table.concat(results, ","))
-- Expected: deterministic values across runs
