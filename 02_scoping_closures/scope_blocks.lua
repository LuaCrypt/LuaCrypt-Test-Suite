-- Test: Block scoping with do/end
local results = {}

-- Test 1: Simple do block
local x = 1
do
    x = 2
end
results[#results + 1] = "simple_do=" .. x

-- Test 2: Local in do block
local y = 10
do
    local y = 20
    results[#results + 1] = "inner_do=" .. y
end
results[#results + 1] = "outer_do=" .. y

-- Test 3: Nested do blocks
local z = 0
do
    z = z + 1
    do
        z = z + 10
        do
            z = z + 100
        end
    end
end
results[#results + 1] = "nested_do=" .. z

-- Test 4: Do block with multiple locals
do
    local a, b, c = 1, 2, 3
    results[#results + 1] = "multi_local=" .. (a + b + c)
end

-- Test 5: Do block for limiting scope
local function process()
    local result = 0
    do
        local temp = 10
        local temp2 = 20
        result = temp + temp2
    end
    -- temp and temp2 not accessible here
    return result
end
results[#results + 1] = "limit_scope=" .. process()

-- Test 6: Do block inside loop
local sum = 0
for i = 1, 3 do
    do
        local val = i * 10
        sum = sum + val
    end
end
results[#results + 1] = "do_in_loop=" .. sum

print(table.concat(results, ","))
-- Expected: simple_do=2,inner_do=20,outer_do=10,nested_do=111,multi_local=6,limit_scope=30,do_in_loop=60
