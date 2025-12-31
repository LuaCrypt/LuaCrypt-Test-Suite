-- Test: Function behavior determinism
local results = {}

-- Test 1: Recursive function
local function factorial(n)
    if n <= 1 then return 1 end
    return n * factorial(n - 1)
end
results[#results + 1] = "fact=" .. factorial(10)

-- Test 2: Mutual recursion
local is_even, is_odd
is_even = function(n)
    if n == 0 then return true end
    return is_odd(n - 1)
end
is_odd = function(n)
    if n == 0 then return false end
    return is_even(n - 1)
end
results[#results + 1] = "mutual=" .. tostring(is_even(10)) .. ":" .. tostring(is_odd(10))

-- Test 3: Higher-order function
local function compose(f, g)
    return function(x)
        return f(g(x))
    end
end
local double = function(x) return x * 2 end
local add_one = function(x) return x + 1 end
local composed = compose(double, add_one)
results[#results + 1] = "compose=" .. composed(5)

-- Test 4: Currying
local function curry(f)
    return function(a)
        return function(b)
            return f(a, b)
        end
    end
end
local add = function(a, b) return a + b end
local curried = curry(add)
results[#results + 1] = "curry=" .. curried(3)(4)

-- Test 5: Fold/reduce
local function reduce(t, fn, init)
    local acc = init
    for i, v in ipairs(t) do
        acc = fn(acc, v)
    end
    return acc
end
local sum = reduce({1, 2, 3, 4, 5}, function(a, b) return a + b end, 0)
results[#results + 1] = "reduce=" .. sum

-- Test 6: Map
local function map(t, fn)
    local result = {}
    for i, v in ipairs(t) do
        result[i] = fn(v)
    end
    return result
end
local mapped = map({1, 2, 3}, function(x) return x * x end)
results[#results + 1] = "map=" .. table.concat(mapped, ":")

-- Test 7: Filter
local function filter(t, pred)
    local result = {}
    for i, v in ipairs(t) do
        if pred(v) then
            result[#result + 1] = v
        end
    end
    return result
end
local filtered = filter({1, 2, 3, 4, 5, 6}, function(x) return x % 2 == 0 end)
results[#results + 1] = "filter=" .. table.concat(filtered, ":")

-- Test 8: Tail recursion
local function tail_sum(n, acc)
    if n <= 0 then return acc end
    return tail_sum(n - 1, acc + n)
end
results[#results + 1] = "tail=" .. tail_sum(100, 0)

-- Test 9: Vararg handling
local function vararg_sum(...)
    local total = 0
    for i = 1, select('#', ...) do
        total = total + select(i, ...)
    end
    return total
end
results[#results + 1] = "vararg=" .. vararg_sum(1, 2, 3, 4, 5)

-- Test 10: Method chaining
local Chain = {}
Chain.__index = Chain
function Chain.new(val)
    return setmetatable({val = val}, Chain)
end
function Chain:add(n)
    self.val = self.val + n
    return self
end
function Chain:mul(n)
    self.val = self.val * n
    return self
end
function Chain:get()
    return self.val
end
local chained = Chain.new(1):add(2):mul(3):add(4):get()
results[#results + 1] = "chain=" .. chained

print(table.concat(results, ","))
-- Expected: deterministic across runs
