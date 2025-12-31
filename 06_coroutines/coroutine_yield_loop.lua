-- Test: Yield in different loop types
local results = {}

-- Test 1: Yield in for loop
local co1 = coroutine.create(function()
    for i = 1, 5 do
        coroutine.yield(i * 10)
    end
    return "done"
end)
local for_vals = {}
for i = 1, 6 do
    local _, v = coroutine.resume(co1)
    for_vals[#for_vals + 1] = tostring(v)
end
results[#results + 1] = "for=" .. table.concat(for_vals, ";")

-- Test 2: Yield in while loop
local co2 = coroutine.create(function()
    local i = 0
    while i < 3 do
        i = i + 1
        coroutine.yield(i)
    end
    return "end"
end)
local while_vals = {}
for i = 1, 4 do
    local _, v = coroutine.resume(co2)
    while_vals[#while_vals + 1] = tostring(v)
end
results[#results + 1] = "while=" .. table.concat(while_vals, ";")

-- Test 3: Yield in repeat loop
local co3 = coroutine.create(function()
    local i = 0
    repeat
        i = i + 1
        coroutine.yield(i)
    until i >= 3
    return "done"
end)
local repeat_vals = {}
for i = 1, 4 do
    local _, v = coroutine.resume(co3)
    repeat_vals[#repeat_vals + 1] = tostring(v)
end
results[#results + 1] = "repeat=" .. table.concat(repeat_vals, ";")

-- Test 4: Yield in for-in loop
local co4 = coroutine.create(function()
    local t = {a = 1, b = 2, c = 3}
    for k, v in pairs(t) do
        coroutine.yield(v)
    end
    return 0
end)
local sum = 0
for i = 1, 4 do
    local _, v = coroutine.resume(co4)
    if type(v) == "number" then sum = sum + v end
end
results[#results + 1] = "forin_sum=" .. sum

-- Test 5: Nested loops with yield
local co5 = coroutine.create(function()
    for i = 1, 2 do
        for j = 1, 2 do
            coroutine.yield(i * 10 + j)
        end
    end
end)
local nested = {}
for i = 1, 4 do
    local _, v = coroutine.resume(co5)
    nested[#nested + 1] = v
end
results[#results + 1] = "nested=" .. table.concat(nested, ";")

print(table.concat(results, ","))
-- Expected: for=10;20;30;40;50;done,while=1;2;3;end,repeat=1;2;3;done,forin_sum=6,nested=11;12;21;22
