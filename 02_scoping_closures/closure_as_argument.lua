-- Test: Closures passed as arguments
local results = {}

-- Test 1: Simple callback
local function callWith(fn, value)
    return fn(value)
end
local mult = 3
results[#results + 1] = "callback=" .. callWith(function(x) return x * mult end, 10)

-- Test 2: Closure as iterator
local function forEach(arr, fn)
    for i, v in ipairs(arr) do
        fn(i, v)
    end
end
local sum = 0
forEach({10, 20, 30}, function(i, v)
    sum = sum + v
end)
results[#results + 1] = "iterator=" .. sum

-- Test 3: Closure modifying captured state
local function transform(arr, fn)
    local result = {}
    for i, v in ipairs(arr) do
        result[i] = fn(v)
    end
    return result
end
local factor = 2
local doubled = transform({1, 2, 3}, function(x) return x * factor end)
results[#results + 1] = "transform=" .. table.concat(doubled, ";")

-- Test 4: Higher-order with closure
local function compose(f, g)
    return function(x)
        return f(g(x))
    end
end
local addOne = function(x) return x + 1 end
local double = function(x) return x * 2 end
local composed = compose(addOne, double)
results[#results + 1] = "compose=" .. composed(5)

-- Test 5: Closure as sort comparator
local data = {{n = 3}, {n = 1}, {n = 2}}
local ascending = true
table.sort(data, function(a, b)
    if ascending then
        return a.n < b.n
    else
        return a.n > b.n
    end
end)
local sorted = {}
for _, v in ipairs(data) do
    sorted[#sorted + 1] = v.n
end
results[#results + 1] = "sort=" .. table.concat(sorted, ";")

-- Test 6: Closure capturing another closure
local function makeAdder(n)
    return function(x) return x + n end
end
local add5 = makeAdder(5)
local function apply(fn, x)
    return fn(x)
end
results[#results + 1] = "nested_closure=" .. apply(add5, 10)

print(table.concat(results, ","))
-- Expected: callback=30,iterator=60,transform=2;4;6,compose=11,sort=1;2;3,nested_closure=15
