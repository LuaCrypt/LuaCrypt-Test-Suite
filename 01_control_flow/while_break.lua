-- Test: Break in while loops
local results = {}

-- Test 1: Simple break
local i = 0
while true do
    i = i + 1
    if i >= 5 then
        break
    end
end
results[#results + 1] = "simple=" .. i

-- Test 2: Break with condition
local j = 0
while j < 100 do
    j = j + 1
    if j == 7 then
        break
    end
end
results[#results + 1] = "cond=" .. j

-- Test 3: Break in nested while (inner only)
local outer = 0
local inner_breaks = 0
while outer < 3 do
    outer = outer + 1
    local inner = 0
    while true do
        inner = inner + 1
        if inner >= 2 then
            inner_breaks = inner_breaks + 1
            break
        end
    end
end
results[#results + 1] = "nested_outer=" .. outer .. "_inner=" .. inner_breaks

-- Test 4: Code after break is not executed
local after_break = false
local k = 0
while k < 10 do
    k = k + 1
    if k == 3 then
        break
        after_break = true  -- This line is unreachable but should parse
    end
end
results[#results + 1] = "after=" .. tostring(after_break)

-- Test 5: Break in else branch
local m = 0
while m < 100 do
    m = m + 1
    if m < 5 then
        -- continue
    else
        break
    end
end
results[#results + 1] = "else_break=" .. m

print(table.concat(results, ","))
-- Expected: simple=5,cond=7,nested_outer=3_inner=3,after=false,else_break=5
