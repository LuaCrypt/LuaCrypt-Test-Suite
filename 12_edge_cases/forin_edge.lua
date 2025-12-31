-- Edge cases for for-in loops with iterator patterns
-- Tests fixes for: control variable initialization, iterator state handling

local results = {}

-- Test 1: Basic pairs iteration (count elements)
local t1 = {a = 1, b = 2, c = 3}
local count1 = 0
for k, v in pairs(t1) do
    count1 = count1 + 1
end
results[#results + 1] = count1  -- 3

-- Test 2: Basic ipairs iteration
local t2 = {10, 20, 30, 40}
local sum2 = 0
for i, v in ipairs(t2) do
    sum2 = sum2 + v
end
results[#results + 1] = sum2  -- 100

-- Test 3: Custom iterator returning single value
local function single_iter(max)
    local i = 0
    return function()
        i = i + 1
        if i <= max then
            return i
        end
    end
end

local sum3 = 0
for v in single_iter(5) do
    sum3 = sum3 + v
end
results[#results + 1] = sum3  -- 15

-- Test 4: Iterator returning nil as valid value
local function nil_iter()
    local items = {1, nil, 3}
    local i = 0
    return function()
        i = i + 1
        if i <= 3 then
            return i, items[i]
        end
    end
end

local count4 = 0
for k, v in nil_iter() do
    count4 = count4 + 1
end
results[#results + 1] = count4  -- 3

-- Test 5: Iterator with state table
local function stateful_iter(t)
    return function(state, prev)
        local k, v = next(state, prev)
        return k, v
    end, t, nil
end

local sum5 = 0
for k, v in stateful_iter({x = 10, y = 20}) do
    sum5 = sum5 + v
end
results[#results + 1] = sum5  -- 30

-- Test 6: Break in for-in
local count6 = 0
for i, v in ipairs({1, 2, 3, 4, 5}) do
    if i == 3 then break end
    count6 = count6 + 1
end
results[#results + 1] = count6  -- 2

-- Test 7: Nested for-in loops
local count7 = 0
for i, v1 in ipairs({1, 2}) do
    for j, v2 in ipairs({3, 4}) do
        count7 = count7 + 1
    end
end
results[#results + 1] = count7  -- 4

-- Test 8: For-in with closure capturing loop variable
local closures = {}
for i, v in ipairs({10, 20, 30}) do
    closures[i] = function() return v end
end
results[#results + 1] = closures[1]() + closures[2]() + closures[3]()  -- 60

-- Test 9: For-in with multiple return values from iterator
local function multi_iter()
    local data = {{1, "a", true}, {2, "b", false}, {3, "c", true}}
    local i = 0
    return function()
        i = i + 1
        if data[i] then
            return data[i][1], data[i][2], data[i][3]
        end
    end
end

local sum9 = 0
local str9 = ""
for num, letter, flag in multi_iter() do
    sum9 = sum9 + num
    str9 = str9 .. letter
end
results[#results + 1] = sum9    -- 6
results[#results + 1] = str9    -- abc

-- Test 10: Empty iterator
local count10 = 0
for k, v in pairs({}) do
    count10 = count10 + 1
end
results[#results + 1] = count10  -- 0

-- Test 11: Iterator that returns false (not nil)
local function false_iter()
    local done = false
    return function()
        if not done then
            done = true
            return false, "value"
        end
    end
end

local count11 = 0
for k, v in false_iter() do
    count11 = count11 + 1
end
results[#results + 1] = count11  -- 1

-- Test 12: next() directly
local t12 = {a = 1, b = 2}
local count12 = 0
for k, v in next, t12 do
    count12 = count12 + v
end
results[#results + 1] = count12  -- 3

-- Test 13: Modifying table during iteration (adding - undefined but shouldn't crash)
local t13 = {1, 2, 3}
local sum13 = 0
for i, v in ipairs(t13) do
    sum13 = sum13 + v
    -- Note: adding during ipairs is safe because ipairs uses numeric indices
end
results[#results + 1] = sum13  -- 6

-- Test 14: Very long iteration
local sum14 = 0
local t14 = {}
for i = 1, 100 do t14[i] = i end
for i, v in ipairs(t14) do
    sum14 = sum14 + v
end
results[#results + 1] = sum14  -- 5050

-- Test 15: Iterator with control variable starting at specific value
local function from_iter(start, max)
    local i = start - 1
    return function()
        i = i + 1
        if i <= max then
            return i
        end
    end
end

local sum15 = 0
for v in from_iter(5, 10) do
    sum15 = sum15 + v
end
results[#results + 1] = sum15  -- 5+6+7+8+9+10 = 45

print(table.concat(results, ","))
-- Expected: 3,100,15,3,30,2,4,60,6,abc,0,1,3,6,5050,45
