-- Test: Varargs as iterators
local results = {}

-- Test 1: Simple varargs iterator
local function varargIter(...)
    local args = {...}
    local i = 0
    return function()
        i = i + 1
        return args[i]
    end
end

local sum = 0
for v in varargIter(10, 20, 30, 40) do
    sum = sum + v
end
results[#results + 1] = "iter=" .. sum

-- Test 2: Iterator with index and value
local function varargPairs(...)
    local args = {...}
    local n = select("#", ...)
    local i = 0
    return function()
        i = i + 1
        if i <= n then
            return i, args[i]
        end
    end
end

local pairs_result = {}
for i, v in varargPairs("a", "b", "c") do
    pairs_result[#pairs_result + 1] = i .. ":" .. v
end
results[#results + 1] = "pairs=" .. table.concat(pairs_result, ";")

-- Test 3: Filter varargs
local function filter(predicate, ...)
    local result = {}
    for i = 1, select("#", ...) do
        local v = select(i, ...)
        if predicate(v) then
            result[#result + 1] = v
        end
    end
    local unpack_fn = table.unpack or unpack
    return unpack_fn(result)
end

local function isEven(n) return n % 2 == 0 end
local e1, e2, e3 = filter(isEven, 1, 2, 3, 4, 5, 6)
results[#results + 1] = "filter=" .. (e1 or "nil") .. ";" .. (e2 or "nil") .. ";" .. (e3 or "nil")

-- Test 4: Map over varargs
local function map(fn, ...)
    local result = {}
    for i = 1, select("#", ...) do
        result[i] = fn(select(i, ...))
    end
    local unpack_fn = table.unpack or unpack
    return unpack_fn(result)
end

local m1, m2, m3 = map(function(x) return x * 2 end, 5, 10, 15)
results[#results + 1] = "map=" .. (m1 or "nil") .. ";" .. (m2 or "nil") .. ";" .. (m3 or "nil")

-- Test 5: Reduce over varargs
local function reduce(fn, init, ...)
    local acc = init
    for i = 1, select("#", ...) do
        acc = fn(acc, select(i, ...))
    end
    return acc
end

local sum2 = reduce(function(a, b) return a + b end, 0, 1, 2, 3, 4, 5)
results[#results + 1] = "reduce=" .. sum2

print(table.concat(results, ","))
-- Expected: iter=100,pairs=1:a;2:b;3:c,filter=2;4;6,map=10;20;30,reduce=15
