-- Test: Local variable shadowing
local results = {}

-- Test 1: Simple shadowing
local x = 10
do
    local x = 20  -- Shadows outer x
    results[#results + 1] = "inner=" .. x
end
results[#results + 1] = "outer=" .. x

-- Test 2: Multiple levels of shadowing
local a = 1
do
    local a = 2
    do
        local a = 3
        results[#results + 1] = "d3=" .. a
    end
    results[#results + 1] = "d2=" .. a
end
results[#results + 1] = "d1=" .. a

-- Test 3: Shadowing in function
local y = 100
local function shadow()
    local y = 200
    return y
end
results[#results + 1] = "func=" .. shadow() .. "_out=" .. y

-- Test 4: Shadowing in loop
local z = 50
for i = 1, 3 do
    local z = i * 10
    if i == 2 then
        results[#results + 1] = "loop=" .. z
    end
end
results[#results + 1] = "after_loop=" .. z

-- Test 5: Shadow with same initial value
local same = 5
do
    local same = same + 10  -- Uses outer 'same' in expression, then shadows
    results[#results + 1] = "same_inner=" .. same
end
results[#results + 1] = "same_outer=" .. same

-- Test 6: Shadowing parameter
local function paramShadow(n)
    results[#results + 1] = "param=" .. n
    local n = n * 2  -- Shadow the parameter
    results[#results + 1] = "shadow_param=" .. n
end
paramShadow(7)

print(table.concat(results, ","))
-- Expected: inner=20,outer=10,d3=3,d2=2,d1=1,func=200_out=100,loop=20,after_loop=50,same_inner=15,same_outer=5,param=7,shadow_param=14
