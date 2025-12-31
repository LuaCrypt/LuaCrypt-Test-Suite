-- Test: State modification patterns in while loops
local results = {}

-- Test 1: Multiple variables modified
local a, b = 0, 10
while a < b do
    a = a + 1
    b = b - 1
end
results[#results + 1] = "converge_a=" .. a .. "_b=" .. b

-- Test 2: Swap pattern in loop
local x, y = 1, 100
local steps = 0
while x < y do
    local temp = x
    x = y - x
    y = temp + 10
    steps = steps + 1
    if steps > 10 then break end  -- Safety limit
end
results[#results + 1] = "swap_steps=" .. steps

-- Test 3: Array traversal
local arr = {10, 20, 30, 40, 50}
local idx = 1
local sum = 0
while arr[idx] do
    sum = sum + arr[idx]
    idx = idx + 1
end
results[#results + 1] = "arr_sum=" .. sum

-- Test 4: Linked list style
local nodes = {
    {value = 1, next = 2},
    {value = 2, next = 3},
    {value = 3, next = 4},
    {value = 4, next = nil}
}
local current = 1
local values = {}
while current do
    values[#values + 1] = nodes[current].value
    current = nodes[current].next
end
results[#results + 1] = "linked=" .. table.concat(values, ";")

-- Test 5: Fibonacci sequence
local fib_a, fib_b = 0, 1
local fibs = {fib_a, fib_b}
while fib_b < 50 do
    fib_a, fib_b = fib_b, fib_a + fib_b
    fibs[#fibs + 1] = fib_b
end
results[#results + 1] = "fib=" .. table.concat(fibs, ";")

print(table.concat(results, ","))
-- Expected: converge_a=5_b=5,swap_steps=3,arr_sum=150,linked=1;2;3;4,fib=0;1;1;2;3;5;8;13;21;34;55
