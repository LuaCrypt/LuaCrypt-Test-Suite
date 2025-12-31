-- Test: Upvalue mutation timing and behavior
local results = {}

-- Test 1: Mutation before closure call
local x = 1
local function getX()
    return x
end
x = 2
x = 3
results[#results + 1] = "before_call=" .. getX()

-- Test 2: Mutation interleaved with calls
local y = 0
local function incAndGet()
    y = y + 1
    return y
end
results[#results + 1] = "seq=" .. incAndGet() .. ";" .. incAndGet() .. ";" .. incAndGet()

-- Test 3: Multiple closures mutating same upvalue
local counter = 0
local function add(n)
    counter = counter + n
end
local function sub(n)
    counter = counter - n
end
local function get()
    return counter
end
add(10)
sub(3)
add(5)
results[#results + 1] = "multi_mut=" .. get()

-- Test 4: Closure modifies upvalue, outer sees change
local shared = 100
local function modify()
    shared = shared * 2
end
modify()
results[#results + 1] = "outer_sees=" .. shared

-- Test 5: Nested modification
local outer_val = 1
local function outer_fn()
    local function inner_fn()
        outer_val = outer_val + 10
    end
    inner_fn()
    outer_val = outer_val + 100
end
outer_fn()
results[#results + 1] = "nested_mod=" .. outer_val

-- Test 6: Mutation in loop
local loop_val = 0
local function addToLoop(n)
    loop_val = loop_val + n
end
for i = 1, 5 do
    addToLoop(i)
end
results[#results + 1] = "loop_mut=" .. loop_val

print(table.concat(results, ","))
-- Expected: before_call=3,seq=1;2;3,multi_mut=12,outer_sees=200,nested_mod=111,loop_mut=15
