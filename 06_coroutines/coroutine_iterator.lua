-- Test: Coroutines as iterators
local results = {}

-- Test 1: Simple iterator
local function range(n)
    return coroutine.wrap(function()
        for i = 1, n do
            coroutine.yield(i)
        end
    end)
end
local sum1 = 0
for v in range(5) do
    sum1 = sum1 + v
end
results[#results + 1] = "range=" .. sum1

-- Test 2: Iterator with pairs
local function pairs_iter(t)
    return coroutine.wrap(function()
        for k, v in pairs(t) do
            coroutine.yield(k, v)
        end
    end)
end
local count = 0
for k, v in pairs_iter({a = 1, b = 2, c = 3}) do
    count = count + 1
end
results[#results + 1] = "pairs=" .. count

-- Test 3: Filtered iterator
local function filter(iter, predicate)
    return coroutine.wrap(function()
        for v in iter do
            if predicate(v) then
                coroutine.yield(v)
            end
        end
    end)
end
local evens = {}
for v in filter(range(10), function(x) return x % 2 == 0 end) do
    evens[#evens + 1] = v
end
results[#results + 1] = "filter=" .. table.concat(evens, ";")

-- Test 4: Mapped iterator
local function map(iter, fn)
    return coroutine.wrap(function()
        for v in iter do
            coroutine.yield(fn(v))
        end
    end)
end
local doubled = {}
for v in map(range(5), function(x) return x * 2 end) do
    doubled[#doubled + 1] = v
end
results[#results + 1] = "map=" .. table.concat(doubled, ";")

-- Test 5: Stateful iterator
local function counter()
    local count = 0
    return coroutine.wrap(function()
        while true do
            count = count + 1
            coroutine.yield(count)
        end
    end)
end
local cnt = counter()
local first5 = {}
for i = 1, 5 do
    first5[#first5 + 1] = cnt()
end
results[#results + 1] = "counter=" .. table.concat(first5, ";")

print(table.concat(results, ","))
-- Expected: range=15,pairs=3,filter=2;4;6;8;10,map=2;4;6;8;10,counter=1;2;3;4;5
