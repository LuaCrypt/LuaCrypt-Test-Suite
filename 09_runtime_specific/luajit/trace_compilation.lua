-- Test: LuaJIT trace compilation behavior
local results = {}

if not jit then
    results[#results + 1] = "skip=not_luajit"
    print(table.concat(results, ","))
    return
end

-- Test 1: JIT enabled
local jit_on = jit.status()
results[#results + 1] = "jit=" .. (jit_on and "on" or "off")

-- Test 2: Simple hot loop
jit.on()
local sum = 0
for i = 1, 10000 do
    sum = sum + i
end
results[#results + 1] = "hotloop=" .. sum

-- Test 3: Nested loops
local nested_sum = 0
for i = 1, 100 do
    for j = 1, 100 do
        nested_sum = nested_sum + i + j
    end
end
results[#results + 1] = "nested=" .. nested_sum

-- Test 4: Loop with conditional
local cond_sum = 0
for i = 1, 1000 do
    if i % 2 == 0 then
        cond_sum = cond_sum + i
    else
        cond_sum = cond_sum - i
    end
end
results[#results + 1] = "cond=" .. cond_sum

-- Test 5: Loop with function call
local function add_one(x)
    return x + 1
end
local call_sum = 0
for i = 1, 1000 do
    call_sum = call_sum + add_one(i)
end
results[#results + 1] = "call=" .. call_sum

-- Test 6: Loop with table access
local arr = {}
for i = 1, 100 do
    arr[i] = i
end
local arr_sum = 0
for i = 1, 100 do
    arr_sum = arr_sum + arr[i]
end
results[#results + 1] = "array=" .. arr_sum

-- Test 7: Loop with closure
local function make_counter()
    local count = 0
    return function()
        count = count + 1
        return count
    end
end
local counter = make_counter()
local closure_sum = 0
for i = 1, 100 do
    closure_sum = closure_sum + counter()
end
results[#results + 1] = "closure=" .. closure_sum

-- Test 8: Polymorphic call (trace abort trigger)
local function poly(x)
    return x + 1
end
local poly_sum = 0
for i = 1, 100 do
    poly_sum = poly_sum + poly(i)
    if i == 50 then
        poly_sum = poly_sum + poly("0" + 0)  -- type change
    end
end
results[#results + 1] = "poly=" .. poly_sum

-- Test 9: JIT off/on
jit.off()
local off_sum = 0
for i = 1, 100 do
    off_sum = off_sum + i
end
jit.on()
results[#results + 1] = "toggle=" .. off_sum

-- Test 10: Recursive function (typically not traced)
local function rec_sum(n)
    if n <= 0 then return 0 end
    return n + rec_sum(n - 1)
end
results[#results + 1] = "recurse=" .. rec_sum(100)

-- Test 11: Loop with pcall (trace abort)
local pcall_sum = 0
for i = 1, 100 do
    local ok, val = pcall(function() return i end)
    if ok then pcall_sum = pcall_sum + val end
end
results[#results + 1] = "pcall_loop=" .. pcall_sum

-- Test 12: Math heavy loop
local math_sum = 0
for i = 1, 1000 do
    math_sum = math_sum + math.sin(i) * math.cos(i)
end
results[#results + 1] = "math=" .. (math_sum > -1000 and math_sum < 1000 and "valid" or "invalid")

print(table.concat(results, ","))
-- Expected (on LuaJIT): jit=on,hotloop=50005000,nested=1010000,cond=-500,call=501500,array=5050,closure=5050,poly=5101,toggle=5050,recurse=5050,pcall_loop=5050,math=valid
