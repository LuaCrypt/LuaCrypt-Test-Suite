-- Test: Complex shadowing scenarios
local results = {}

-- Test 1: Shadow across if/else branches
local x = 1
if true then
    local x = 2
    results[#results + 1] = "if_branch=" .. x
else
    local x = 3
end
results[#results + 1] = "after_if=" .. x

-- Test 2: Shadowing in nested functions
local outer = 100
local function level1()
    local outer = 200
    local function level2()
        local outer = 300
        return outer
    end
    return outer + level2()
end
results[#results + 1] = "nested_func=" .. level1() .. "_top=" .. outer

-- Test 3: Shadow in loop with closure
local funcs = {}
for i = 1, 3 do
    local i = i * 10  -- Shadow loop variable
    funcs[#funcs + 1] = function() return i end
end
local closure_vals = {}
for _, f in ipairs(funcs) do
    closure_vals[#closure_vals + 1] = f()
end
results[#results + 1] = "loop_closure=" .. table.concat(closure_vals, ";")

-- Test 4: Shadow in repeat-until (body vars visible in condition)
local count = 0
repeat
    count = count + 1
    local stop = count >= 3
    local count = count * 10  -- Shadow after using outer
    results[#results + 1] = "repeat_" .. (count/10) .. "=" .. count
until stop  -- Uses non-shadowed 'stop'

-- Test 5: Multiple shadows in expression
local v = 1
local result = (function()
    local v = 2
    return (function()
        local v = 3
        return v
    end)() + v
end)() + v
results[#results + 1] = "multi_shadow=" .. result  -- 3+2+1=6

print(table.concat(results, ","))
-- Expected: if_branch=2,after_if=1,nested_func=500_top=100,loop_closure=10;20;30,repeat_1=10,repeat_2=20,repeat_3=30,multi_shadow=6
