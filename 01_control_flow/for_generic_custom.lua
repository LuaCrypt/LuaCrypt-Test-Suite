-- Test: Generic for with custom iterators
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

local sum = 0
for v in range(5) do
    sum = sum + v
end
results[#results + 1] = "range=" .. sum

-- Test 2: Iterator with state
local function countdown(start)
    local n = start
    return function()
        if n > 0 then
            local current = n
            n = n - 1
            return current
        end
    end
end

local down = {}
for v in countdown(5) do
    down[#down + 1] = v
end
results[#results + 1] = "countdown=" .. table.concat(down, ";")

-- Test 3: Iterator returning multiple values
local function entries(t)
    local k = nil
    return function()
        k = next(t, k)
        if k then
            return k, t[k]
        end
    end
end

local t = {a = 1, b = 2}
local entry_count = 0
for k, v in entries(t) do
    entry_count = entry_count + 1
end
results[#results + 1] = "multi_val=" .. entry_count

-- Test 4: Stateful iterator (closure captures state)
local function fibonacci(max)
    local a, b = 0, 1
    return function()
        if a <= max then
            local current = a
            a, b = b, a + b
            return current
        end
    end
end

local fibs = {}
for v in fibonacci(20) do
    fibs[#fibs + 1] = v
end
results[#results + 1] = "fib=" .. table.concat(fibs, ";")

-- Test 5: Iterator with control variable (standard pattern)
local function iter(t, i)
    i = i + 1
    local v = t[i]
    if v then
        return i, v
    end
end

local function myipairs(t)
    return iter, t, 0
end

local arr = {"x", "y", "z"}
local vals = {}
for i, v in myipairs(arr) do
    vals[#vals + 1] = i .. ":" .. v
end
results[#results + 1] = "custom_ipairs=" .. table.concat(vals, ";")

print(table.concat(results, ","))
-- Expected: range=15,countdown=5;4;3;2;1,multi_val=2,fib=0;1;1;2;3;5;8;13,custom_ipairs=1:x;2:y;3:z
