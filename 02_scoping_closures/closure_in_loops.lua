-- Test: Closures created in loops
local results = {}

-- Test 1: Numeric for - each iteration gets its own loop variable
local numfor_funcs = {}
for i = 1, 4 do
    numfor_funcs[i] = function() return i * 10 end
end
local numfor_results = {}
for i = 1, 4 do
    numfor_results[i] = numfor_funcs[i]()
end
results[#results + 1] = "numfor=" .. table.concat(numfor_results, ";")

-- Test 2: Generic for with pairs
local pairs_funcs = {}
local t = {a = 1, b = 2, c = 3}
for k, v in pairs(t) do
    pairs_funcs[k] = function() return v end
end
local pairs_sum = 0
for k, f in pairs(pairs_funcs) do
    pairs_sum = pairs_sum + f()
end
results[#results + 1] = "pairs_sum=" .. pairs_sum

-- Test 3: While loop needs explicit local
local while_funcs = {}
local j = 1
while j <= 3 do
    local captured_j = j
    while_funcs[j] = function() return captured_j end
    j = j + 1
end
results[#results + 1] = "while=" .. while_funcs[1]() .. ";" .. while_funcs[2]() .. ";" .. while_funcs[3]()

-- Test 4: Repeat loop
local repeat_funcs = {}
local r = 0
repeat
    r = r + 1
    local captured_r = r
    repeat_funcs[r] = function() return captured_r end
until r >= 3
results[#results + 1] = "repeat=" .. repeat_funcs[1]() .. ";" .. repeat_funcs[2]() .. ";" .. repeat_funcs[3]()

-- Test 5: Nested loops
local nested_funcs = {}
for i = 1, 2 do
    for j = 1, 2 do
        local key = i .. "_" .. j
        nested_funcs[key] = function() return i + j end
    end
end
results[#results + 1] = "nested=" .. nested_funcs["1_1"]() .. ";" .. nested_funcs["1_2"]() .. ";" .. nested_funcs["2_1"]() .. ";" .. nested_funcs["2_2"]()

-- Test 6: Loop with multiple closures per iteration
local multi_funcs = {}
for i = 1, 3 do
    multi_funcs[i] = {
        get = function() return i end,
        double = function() return i * 2 end
    }
end
results[#results + 1] = "multi2=" .. multi_funcs[2].get() .. ":" .. multi_funcs[2].double()

print(table.concat(results, ","))
-- Expected: numfor=10;20;30;40,pairs_sum=6,while=1;2;3,repeat=1;2;3,nested=2;3;3;4,multi2=2:4
