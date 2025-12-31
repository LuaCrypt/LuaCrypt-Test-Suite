-- Test: Expressions in numeric for loop bounds
local results = {}

-- Test 1: Variable bounds
local start, stop = 2, 6
local sum = 0
for i = start, stop do
    sum = sum + i
end
results[#results + 1] = "var_bounds=" .. sum  -- 2+3+4+5+6=20

-- Test 2: Function calls for bounds (evaluated once!)
local call_count = 0
local function getStart()
    call_count = call_count + 1
    return 1
end
local function getEnd()
    call_count = call_count + 1
    return 5
end
local function getStep()
    call_count = call_count + 1
    return 1
end
for i = getStart(), getEnd(), getStep() do
    -- Body
end
results[#results + 1] = "calls=" .. call_count  -- Should be 3 (each called once)

-- Test 3: Arithmetic expressions
local base = 10
local sum2 = 0
for i = base - 5, base + 5, (base / 5) do
    sum2 = sum2 + i
end
results[#results + 1] = "expr=" .. sum2  -- 5,7,9,11,13,15 = 60

-- Test 4: Table field as bound
local config = {min = 1, max = 4, step = 1}
local count = 0
for i = config.min, config.max, config.step do
    count = count + 1
end
results[#results + 1] = "table=" .. count

-- Test 5: Bounds modified during loop (should not affect iteration)
local limit = 3
local actual = 0
for i = 1, limit do
    limit = 100  -- This should NOT extend the loop
    actual = actual + 1
end
results[#results + 1] = "modified=" .. actual .. "_limit=" .. limit

print(table.concat(results, ","))
-- Expected: var_bounds=20,calls=3,expr=60,table=4,modified=3_limit=100
