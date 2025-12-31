-- Test: Coroutine stress tests
local results = {}

-- Test 1: Many coroutines
local cos = {}
for i = 1, 100 do
    cos[i] = coroutine.create(function()
        return i * i
    end)
end
local sum1 = 0
for i = 1, 100 do
    local _, v = coroutine.resume(cos[i])
    sum1 = sum1 + v
end
results[#results + 1] = "many=" .. sum1

-- Test 2: Deep yield chain
local co2 = coroutine.create(function()
    local total = 0
    for i = 1, 50 do
        total = total + coroutine.yield(i)
    end
    return total
end)
local sum2 = 0
for i = 1, 50 do
    local _, v = coroutine.resume(co2, i)
    sum2 = sum2 + v
end
coroutine.resume(co2, 51)
results[#results + 1] = "deep_yield=" .. sum2

-- Test 3: Coroutine pool pattern
local pool = {}
local function get_worker()
    for i, co in ipairs(pool) do
        if coroutine.status(co) ~= "dead" then
            return co
        end
    end
    local new_co = coroutine.create(function(task)
        while task do
            task = coroutine.yield(task * 2)
        end
    end)
    pool[#pool + 1] = new_co
    return new_co
end

local pool_results = {}
for i = 1, 10 do
    local worker = get_worker()
    local _, result = coroutine.resume(worker, i)
    pool_results[#pool_results + 1] = result
end
results[#results + 1] = "pool=" .. #pool_results

-- Test 4: Interleaved execution
local order = {}
local co4a = coroutine.create(function()
    for i = 1, 5 do
        order[#order + 1] = "a" .. i
        coroutine.yield()
    end
end)
local co4b = coroutine.create(function()
    for i = 1, 5 do
        order[#order + 1] = "b" .. i
        coroutine.yield()
    end
end)
for i = 1, 5 do
    coroutine.resume(co4a)
    coroutine.resume(co4b)
end
results[#results + 1] = "interleave=" .. #order

-- Test 5: Rapid create/resume/gc cycle
local gc_count = 0
for i = 1, 100 do
    local co = coroutine.create(function()
        return i
    end)
    local _, v = coroutine.resume(co)
    if v == i then gc_count = gc_count + 1 end
end
results[#results + 1] = "rapid_gc=" .. gc_count

print(table.concat(results, ","))
-- Expected: many=338350,deep_yield=1275,pool=10,interleave=10,rapid_gc=100
