-- Test: Coroutine state preservation
local results = {}

-- Test 1: Local variables preserved across yield
local co1 = coroutine.create(function()
    local x = 10
    coroutine.yield()
    x = x + 5
    coroutine.yield()
    return x
end)
coroutine.resume(co1)
coroutine.resume(co1)
local ok1, val1 = coroutine.resume(co1)
results[#results + 1] = "locals=" .. val1

-- Test 2: Upvalues preserved
local counter = 0
local co2 = coroutine.create(function()
    counter = counter + 1
    coroutine.yield(counter)
    counter = counter + 10
    return counter
end)
local _, v2a = coroutine.resume(co2)
local _, v2b = coroutine.resume(co2)
results[#results + 1] = "upvalue=" .. v2a .. ";" .. v2b

-- Test 3: Loop state preserved
local co3 = coroutine.create(function()
    local sum = 0
    for i = 1, 5 do
        sum = sum + i
        coroutine.yield(sum)
    end
    return sum
end)
local sums = {}
for i = 1, 6 do
    local ok, val = coroutine.resume(co3)
    sums[#sums + 1] = tostring(val)
end
results[#results + 1] = "loop=" .. table.concat(sums, ";")

-- Test 4: Table state preserved
local co4 = coroutine.create(function()
    local t = {count = 0}
    for i = 1, 3 do
        t.count = t.count + i
        t["key" .. i] = true
        coroutine.yield(t.count)
    end
    return t.count
end)
local _, c1 = coroutine.resume(co4)
local _, c2 = coroutine.resume(co4)
local _, c3 = coroutine.resume(co4)
results[#results + 1] = "table=" .. c1 .. ";" .. c2 .. ";" .. c3

-- Test 5: Function reference preserved
local co5 = coroutine.create(function()
    local function inc(x)
        return x + 1
    end
    local val = 0
    val = inc(val)
    coroutine.yield(val)
    val = inc(val)
    return val
end)
local _, r5a = coroutine.resume(co5)
local _, r5b = coroutine.resume(co5)
results[#results + 1] = "func=" .. r5a .. ";" .. r5b

print(table.concat(results, ","))
-- Expected: locals=15,upvalue=1;11,loop=1;3;6;10;15;15,table=1;3;6,func=1;2
