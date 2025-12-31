-- Test: Edge case stress testing
local results = {}

-- Test 1: Many nested closures
local function nest_closures(depth)
    if depth <= 0 then
        return function() return 0 end
    end
    local inner = nest_closures(depth - 1)
    return function()
        return depth + inner()
    end
end
local nested = nest_closures(50)
results[#results + 1] = "nested_closures=" .. nested()

-- Test 2: Large table iteration
local large = {}
for i = 1, 10000 do
    large[i] = i
end
local sum = 0
for i, v in ipairs(large) do
    sum = sum + v
end
results[#results + 1] = "large_iter=" .. sum

-- Test 3: Deep metatable chain
local function create_chain(depth)
    if depth <= 0 then
        return {val = "bottom"}
    end
    return setmetatable({}, {__index = create_chain(depth - 1)})
end
local deep_mt = create_chain(20)
results[#results + 1] = "deep_mt=" .. deep_mt.val

-- Test 4: Many coroutine switches
local switch_count = 0
local switcher = coroutine.create(function()
    for i = 1, 1000 do
        switch_count = switch_count + 1
        coroutine.yield(i)
    end
end)
while coroutine.status(switcher) ~= "dead" do
    coroutine.resume(switcher)
end
results[#results + 1] = "coro_switches=" .. switch_count

-- Test 5: Recursive pattern with many branches
local function count_paths(n, m, memo)
    memo = memo or {}
    local key = n .. "," .. m
    if memo[key] then return memo[key] end
    if n == 0 or m == 0 then return 1 end
    local result = count_paths(n - 1, m, memo) + count_paths(n, m - 1, memo)
    memo[key] = result
    return result
end
results[#results + 1] = "paths=" .. count_paths(10, 10)

-- Test 6: String concatenation stress
local parts = {}
for i = 1, 1000 do
    parts[i] = tostring(i)
end
local concat_result = table.concat(parts, ",")
results[#results + 1] = "concat_len=" .. #concat_result

-- Test 7: Many upvalues
local function many_upvalues()
    local a, b, c, d, e, f, g, h, i, j = 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
    local k, l, m, n, o, p, q, r, s, t = 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
    return function()
        return a + b + c + d + e + f + g + h + i + j +
               k + l + m + n + o + p + q + r + s + t
    end
end
results[#results + 1] = "upvalues=" .. many_upvalues()()

-- Test 8: Vararg stress
local function sum_all(...)
    local total = 0
    for i = 1, select('#', ...) do
        total = total + select(i, ...)
    end
    return total
end
local vararg_args = {}
for i = 1, 100 do
    vararg_args[i] = i
end
results[#results + 1] = "vararg_stress=" .. sum_all(table.unpack(vararg_args))

-- Test 9: Deeply nested function calls
local function deep_call(n)
    if n <= 0 then return 0 end
    return 1 + deep_call(n - 1)
end
results[#results + 1] = "deep_call=" .. deep_call(100)

-- Test 10: Complex expression evaluation
local function complex_expr()
    local a, b, c = 1, 2, 3
    local t = {x = 10, y = 20}
    local f = function(n) return n * 2 end
    return ((a + b) * c + t.x - t.y) * f(a) + (function() return 100 end)()
end
results[#results + 1] = "complex_expr=" .. complex_expr()

-- Test 11: Table as sparse array
local sparse = {}
sparse[1] = 1
sparse[1000] = 1000
sparse[10000] = 10000
local sparse_sum = (sparse[1] or 0) + (sparse[1000] or 0) + (sparse[10000] or 0)
results[#results + 1] = "sparse=" .. sparse_sum

-- Test 12: Error recovery loop
local error_count = 0
local success_count = 0
for i = 1, 100 do
    local ok = pcall(function()
        if i % 10 == 0 then error("periodic") end
    end)
    if ok then
        success_count = success_count + 1
    else
        error_count = error_count + 1
    end
end
results[#results + 1] = "error_recovery=" .. success_count .. ":" .. error_count

-- Test 13: Metatable arithmetic chain
local function num(n)
    return setmetatable({n = n}, {
        __add = function(a, b) return num(a.n + b.n) end,
        __mul = function(a, b) return num(a.n * b.n) end,
        __sub = function(a, b) return num(a.n - b.n) end
    })
end
local chain_result = num(1) + num(2) * num(3) + num(4) - num(5)
-- Note: Lua doesn't have operator precedence for metamethods
results[#results + 1] = "meta_chain=" .. chain_result.n

print(table.concat(results, ","))
-- Expected: comprehensive stress test results
