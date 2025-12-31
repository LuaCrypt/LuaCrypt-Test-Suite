-- Test: Control flow within functions
local results = {}

-- Test 1: Loop in function
local function sumTo(n)
    local sum = 0
    for i = 1, n do
        sum = sum + i
    end
    return sum
end
results[#results + 1] = "loop_func=" .. sumTo(5)

-- Test 2: Nested functions with control flow
local function outer_f(n)
    local function inner_f(m)
        local count = 0
        while count < m do
            count = count + 1
        end
        return count
    end
    local total = 0
    for i = 1, n do
        total = total + inner_f(i)
    end
    return total
end
results[#results + 1] = "nested_func=" .. outer_f(3)  -- 1+2+3=6

-- Test 3: Early return from loop
local function findValue(arr, target)
    for i, v in ipairs(arr) do
        if v == target then
            return i, v
        end
    end
    return nil, nil
end
local idx, val = findValue({10, 20, 30, 40}, 30)
results[#results + 1] = "early_ret=" .. idx .. ":" .. val

-- Test 4: Recursive with control flow
local function countDown(n, acc)
    acc = acc or {}
    if n <= 0 then
        return acc
    end
    acc[#acc + 1] = n
    return countDown(n - 1, acc)
end
local cd = countDown(5)
results[#results + 1] = "recursive=" .. table.concat(cd, ";")

-- Test 5: Higher-order function with control flow
local function filter(arr, predicate)
    local result = {}
    for i, v in ipairs(arr) do
        if predicate(v) then
            result[#result + 1] = v
        end
    end
    return result
end
local evens = filter({1, 2, 3, 4, 5, 6}, function(x) return x % 2 == 0 end)
results[#results + 1] = "filter=" .. table.concat(evens, ";")

print(table.concat(results, ","))
-- Expected: loop_func=15,nested_func=6,early_ret=3:30,recursive=5;4;3;2;1,filter=2;4;6
