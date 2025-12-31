-- Test: Memoization patterns with closures
local results = {}

-- Test 1: Simple memoization
local function memoize(fn)
    local cache = {}
    return function(x)
        if cache[x] == nil then
            cache[x] = fn(x)
        end
        return cache[x]
    end
end

local callCount = 0
local expensive = memoize(function(n)
    callCount = callCount + 1
    return n * n
end)

expensive(5)
expensive(5)
expensive(5)
expensive(3)
results[#results + 1] = "memo_calls=" .. callCount
results[#results + 1] = "memo_result=" .. expensive(5)

-- Test 2: Memoized recursive (fibonacci)
local fibCalls = 0
local fib
fib = memoize(function(n)
    fibCalls = fibCalls + 1
    if n <= 1 then return n end
    return fib(n - 1) + fib(n - 2)
end)
local fibResult = fib(10)
results[#results + 1] = "fib=" .. fibResult .. "_calls=" .. fibCalls

-- Test 3: Multi-argument memoization
local function memo2(fn)
    local cache = {}
    return function(a, b)
        local key = a .. "," .. b
        if cache[key] == nil then
            cache[key] = fn(a, b)
        end
        return cache[key]
    end
end

local addCalls = 0
local memoAdd = memo2(function(a, b)
    addCalls = addCalls + 1
    return a + b
end)
memoAdd(1, 2)
memoAdd(1, 2)
memoAdd(2, 1)
results[#results + 1] = "memo2_calls=" .. addCalls

-- Test 4: Cache clearing closure
local function createCached()
    local cache = {}
    local function get(key)
        return cache[key]
    end
    local function set(key, value)
        cache[key] = value
    end
    local function clear()
        cache = {}
    end
    return get, set, clear
end

local get, set, clear = createCached()
set("x", 100)
results[#results + 1] = "cache1=" .. tostring(get("x"))
clear()
results[#results + 1] = "cache2=" .. tostring(get("x"))

print(table.concat(results, ","))
-- Expected: memo_calls=2,memo_result=25,fib=55_calls=11,memo2_calls=2,cache1=100,cache2=nil
