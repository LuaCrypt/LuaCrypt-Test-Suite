-- Test: Scope rules in repeat-until (local in body visible in condition)
local results = {}

-- Test 1: Local declared in body used in condition
local count = 0
repeat
    count = count + 1
    local done = count >= 4
until done
results[#results + 1] = "local_cond=" .. count

-- Test 2: Multiple locals in condition
local n = 0
repeat
    n = n + 1
    local a = n * 2
    local b = n + 5
until a > 5 and b > 8
results[#results + 1] = "multi_local=" .. n

-- Test 3: Shadowing in repeat
local x = 100
repeat
    local x = 0  -- Shadows outer x
    x = x + 1
until x > 0  -- Uses inner x
results[#results + 1] = "shadow_outer=" .. x  -- Outer unchanged

-- Test 4: Function defined in body used in condition
local counter = 0
repeat
    counter = counter + 1
    local function check()
        return counter >= 3
    end
until check()
results[#results + 1] = "func_cond=" .. counter

print(table.concat(results, ","))
-- Expected: local_cond=4,multi_local=4,shadow_outer=100,func_cond=3
