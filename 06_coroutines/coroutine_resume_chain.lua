-- Test: Resume chain patterns
local results = {}

-- Test 1: Long resume chain
local co1 = coroutine.create(function()
    for i = 1, 10 do
        coroutine.yield(i)
    end
    return "done"
end)
local sum = 0
for i = 1, 11 do
    local ok, val = coroutine.resume(co1)
    if type(val) == "number" then
        sum = sum + val
    end
end
results[#results + 1] = "chain=" .. sum

-- Test 2: Alternating resumes between coroutines
local co2a = coroutine.create(function()
    coroutine.yield("a1")
    coroutine.yield("a2")
    return "a_done"
end)
local co2b = coroutine.create(function()
    coroutine.yield("b1")
    coroutine.yield("b2")
    return "b_done"
end)
local seq = {}
while coroutine.status(co2a) ~= "dead" or coroutine.status(co2b) ~= "dead" do
    if coroutine.status(co2a) ~= "dead" then
        local _, v = coroutine.resume(co2a)
        seq[#seq + 1] = v
    end
    if coroutine.status(co2b) ~= "dead" then
        local _, v = coroutine.resume(co2b)
        seq[#seq + 1] = v
    end
end
results[#results + 1] = "alt=" .. #seq

-- Test 3: Resume with accumulating state
local co3 = coroutine.create(function(initial)
    local total = initial
    while true do
        local add = coroutine.yield(total)
        if add == nil then return total end
        total = total + add
    end
end)
coroutine.resume(co3, 0)
coroutine.resume(co3, 10)
coroutine.resume(co3, 20)
local _, final = coroutine.resume(co3, 30)
results[#results + 1] = "accum=" .. final

-- Test 4: Rapid resume/yield
local co4 = coroutine.create(function()
    local count = 0
    for i = 1, 100 do
        count = count + 1
        coroutine.yield()
    end
    return count
end)
for i = 1, 100 do
    coroutine.resume(co4)
end
local _, r4 = coroutine.resume(co4)
results[#results + 1] = "rapid=" .. r4

print(table.concat(results, ","))
-- Expected: chain=55,alt=6,accum=60,rapid=100
