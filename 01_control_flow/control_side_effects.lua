-- Test: Control flow with side effects
local results = {}

-- Test 1: Side effects in loop condition
local counter1 = 0
local function check1()
    counter1 = counter1 + 1
    return counter1 < 4
end
while check1() do
    -- empty
end
results[#results + 1] = "while_cond=" .. counter1

-- Test 2: Side effects in for bounds (evaluated once)
local counter2 = 0
local function getLimit()
    counter2 = counter2 + 1
    return 5
end
for i = 1, getLimit() do
    -- empty
end
results[#results + 1] = "for_bounds=" .. counter2

-- Test 3: Side effects in if condition
local counter3 = 0
local function checkAndInc()
    counter3 = counter3 + 1
    return counter3 > 2
end
if checkAndInc() then
    results[#results + 1] = "if1=true"
end
if checkAndInc() then
    results[#results + 1] = "if2=true"
end
if checkAndInc() then
    results[#results + 1] = "if3=true"
end
results[#results + 1] = "if_calls=" .. counter3

-- Test 4: Side effects with short-circuit
local counter4 = 0
local function incAndFalse()
    counter4 = counter4 + 1
    return false
end
local function incAndTrue()
    counter4 = counter4 + 1
    return true
end
if incAndFalse() and incAndTrue() then
    -- Short-circuit: incAndTrue not called
end
results[#results + 1] = "short_and=" .. counter4

counter4 = 0
if incAndTrue() or incAndTrue() then
    -- Short-circuit: second incAndTrue not called
end
results[#results + 1] = "short_or=" .. counter4

-- Test 5: Modification during iteration
local arr = {1, 2, 3, 4, 5}
local collected = {}
for i, v in ipairs(arr) do
    collected[#collected + 1] = v
    if i == 2 then
        arr[6] = 6  -- Won't affect current ipairs iteration
    end
end
results[#results + 1] = "mod_iter=" .. #collected

print(table.concat(results, ","))
-- Expected: while_cond=4,for_bounds=1,if1=true,if2=true,if3=true,if_calls=3,short_and=1,short_or=1,mod_iter=5
