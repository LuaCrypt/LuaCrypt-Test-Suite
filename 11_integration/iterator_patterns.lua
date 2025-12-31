-- Test: Iterator pattern implementations
local results = {}

-- Test 1: Simple stateless iterator
local function range(n)
    local i = 0
    return function()
        i = i + 1
        if i <= n then
            return i
        end
    end
end
local range_sum = 0
for v in range(5) do
    range_sum = range_sum + v
end
results[#results + 1] = "range=" .. range_sum

-- Test 2: Stateful iterator
local function fibonacci(max)
    local a, b = 0, 1
    return function()
        local val = a
        if val <= max then
            a, b = b, a + b
            return val
        end
    end
end
local fib_vals = {}
for v in fibonacci(20) do
    fib_vals[#fib_vals + 1] = v
end
results[#results + 1] = "fib=" .. table.concat(fib_vals, ":")

-- Test 3: Key-value iterator
local function enumerate(t)
    local i = 0
    local n = #t
    return function()
        i = i + 1
        if i <= n then
            return i, t[i]
        end
    end
end
local enum_log = {}
for i, v in enumerate({"a", "b", "c"}) do
    enum_log[#enum_log + 1] = i .. "=" .. v
end
results[#results + 1] = "enum=" .. table.concat(enum_log, ",")

-- Test 4: Filter iterator
local function filter(iter, pred)
    return function()
        while true do
            local v = iter()
            if v == nil then return nil end
            if pred(v) then return v end
        end
    end
end
local filtered = {}
for v in filter(range(10), function(x) return x % 2 == 0 end) do
    filtered[#filtered + 1] = v
end
results[#results + 1] = "filter=" .. table.concat(filtered, ":")

-- Test 5: Map iterator
local function map(iter, fn)
    return function()
        local v = iter()
        if v ~= nil then
            return fn(v)
        end
    end
end
local mapped = {}
for v in map(range(5), function(x) return x * x end) do
    mapped[#mapped + 1] = v
end
results[#results + 1] = "map=" .. table.concat(mapped, ":")

-- Test 6: Take iterator
local function take(iter, n)
    local count = 0
    return function()
        count = count + 1
        if count <= n then
            return iter()
        end
    end
end
local taken = {}
for v in take(range(100), 3) do
    taken[#taken + 1] = v
end
results[#results + 1] = "take=" .. table.concat(taken, ":")

-- Test 7: Zip iterator
local function zip(iter1, iter2)
    return function()
        local v1 = iter1()
        local v2 = iter2()
        if v1 and v2 then
            return v1, v2
        end
    end
end
local zipped = {}
local iter1 = range(3)
local function letters()
    local i = 0
    local chars = {"a", "b", "c"}
    return function()
        i = i + 1
        return chars[i]
    end
end
for n, c in zip(range(3), letters()) do
    zipped[#zipped + 1] = n .. c
end
results[#results + 1] = "zip=" .. table.concat(zipped, ":")

-- Test 8: Chain iterator
local function chain(iter1, iter2)
    local use_second = false
    return function()
        if not use_second then
            local v = iter1()
            if v ~= nil then return v end
            use_second = true
        end
        return iter2()
    end
end
local chained = {}
for v in chain(range(3), range(2)) do
    chained[#chained + 1] = v
end
results[#results + 1] = "chain=" .. table.concat(chained, ":")

-- Test 9: Cycle iterator (limited)
local function cycle(t, times)
    local i = 0
    local count = 0
    local n = #t
    return function()
        i = i + 1
        if i > n then
            i = 1
            count = count + 1
            if count >= times then return nil end
        end
        return t[i]
    end
end
local cycled = {}
for v in cycle({"a", "b"}, 3) do
    cycled[#cycled + 1] = v
end
results[#results + 1] = "cycle=" .. table.concat(cycled, "")

-- Test 10: Reduce pattern
local function reduce(iter, fn, init)
    local acc = init
    for v in iter do
        acc = fn(acc, v)
    end
    return acc
end
local sum = reduce(range(5), function(a, b) return a + b end, 0)
results[#results + 1] = "reduce=" .. sum

print(table.concat(results, ","))
-- Expected: range=15,fib=0:1:1:2:3:5:8:13,enum=1=a,2=b,3=c,filter=2:4:6:8:10,map=1:4:9:16:25,take=1:2:3,zip=1a:2b:3c,chain=1:2:3:1:2,cycle=ababab,reduce=15
