-- Test: Upvalue capture timing (when is the value captured?)
local results = {}

-- Test 1: Value at definition time vs call time
local x = "initial"
local function getX()
    return x
end
-- x is captured by reference, not value
x = "modified"
results[#results + 1] = "timing=" .. getX()  -- "modified"

-- Test 2: Closure in loop - classic problem
local funcs = {}
for i = 1, 3 do
    funcs[i] = function() return i end
end
-- Without local copy, all closures see final value of i (4 after loop)
local loop_results = {}
for i = 1, 3 do
    loop_results[i] = funcs[i]()
end
results[#results + 1] = "loop_problem=" .. table.concat(loop_results, ";")

-- Test 3: Fix with local copy
local fixed_funcs = {}
for i = 1, 3 do
    local i = i  -- Create local copy
    fixed_funcs[i] = function() return i end
end
local fixed_results = {}
for i = 1, 3 do
    fixed_results[i] = fixed_funcs[i]()
end
results[#results + 1] = "loop_fixed=" .. table.concat(fixed_results, ";")

-- Test 4: Generic for loop variable capture
local gen_funcs = {}
local arr = {"a", "b", "c"}
for i, v in ipairs(arr) do
    gen_funcs[i] = function() return i, v end
end
local gen_results = {}
for i = 1, 3 do
    local gi, gv = gen_funcs[i]()
    gen_results[i] = gi .. ":" .. gv
end
results[#results + 1] = "generic=" .. table.concat(gen_results, ";")

-- Test 5: While loop capture (using do block for local copy)
local while_funcs = {}
local w_idx = 1
while w_idx <= 3 do
    local w_copy = w_idx
    while_funcs[w_idx] = function() return w_copy end
    w_idx = w_idx + 1
end
results[#results + 1] = "while=" .. while_funcs[1]() .. ";" .. while_funcs[2]() .. ";" .. while_funcs[3]()

print(table.concat(results, ","))
-- Expected: timing=modified,loop_problem=4;4;4,loop_fixed=1;2;3,generic=1:a;2:b;3:c,while=1;2;3
-- Note: loop_problem shows all 4s because numeric for loop variable ends at 4 after the loop
