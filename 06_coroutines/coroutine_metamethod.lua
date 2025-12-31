-- Test: Coroutines with metamethods
local results = {}

-- Test 1: Yield in __index
local mt1 = {
    __index = function(t, k)
        return k .. "_default"
    end
}
local t1 = setmetatable({existing = "value"}, mt1)
local co1 = coroutine.create(function()
    return t1.existing, t1.missing
end)
local _, v1a, v1b = coroutine.resume(co1)
results[#results + 1] = "index=" .. v1a .. ":" .. v1b

-- Test 2: Coroutine in __call
local mt2 = {
    __call = function(t, x)
        return x * t.multiplier
    end
}
local callable = setmetatable({multiplier = 3}, mt2)
local co2 = coroutine.create(function()
    local sum = 0
    for i = 1, 5 do
        sum = sum + callable(i)
        coroutine.yield(sum)
    end
    return sum
end)
local sums = {}
for i = 1, 5 do
    local _, v = coroutine.resume(co2)
    sums[#sums + 1] = v
end
local _, final2 = coroutine.resume(co2)
results[#results + 1] = "call=" .. final2

-- Test 3: Arithmetic metamethods in coroutine
local function make_num(n)
    return setmetatable({n = n}, {
        __add = function(a, b) return make_num(a.n + b.n) end,
        __mul = function(a, b) return make_num(a.n * b.n) end
    })
end
local co3 = coroutine.create(function()
    local a = make_num(2)
    local b = make_num(3)
    coroutine.yield((a + b).n)
    return (a * b).n
end)
local _, v3a = coroutine.resume(co3)
local _, v3b = coroutine.resume(co3)
results[#results + 1] = "arith=" .. v3a .. ":" .. v3b

-- Test 4: __tostring in coroutine
local mt4 = {
    __tostring = function(t)
        return "custom:" .. t.value
    end
}
local obj4 = setmetatable({value = 42}, mt4)
local co4 = coroutine.create(function()
    return tostring(obj4)
end)
local _, v4 = coroutine.resume(co4)
results[#results + 1] = "tostring=" .. v4

-- Test 5: Comparison metamethods
local function make_cmp(n)
    return setmetatable({n = n}, {
        __lt = function(a, b) return a.n < b.n end,
        __le = function(a, b) return a.n <= b.n end,
        __eq = function(a, b) return a.n == b.n end
    })
end
local co5 = coroutine.create(function()
    local a, b, c = make_cmp(1), make_cmp(2), make_cmp(2)
    coroutine.yield(a < b)
    coroutine.yield(b <= c)
    return b == c
end)
local _, lt = coroutine.resume(co5)
local _, le = coroutine.resume(co5)
local _, eq = coroutine.resume(co5)
results[#results + 1] = "cmp=" .. tostring(lt) .. ":" .. tostring(le) .. ":" .. tostring(eq)

print(table.concat(results, ","))
-- Expected: index=value:missing_default,call=45,arith=5:6,tostring=custom:42,cmp=true:true:true
