-- Test: Complex break scenarios
local results = {}

-- Test 1: Break in deeply nested if
local found = nil
for i = 1, 10 do
    if i > 3 then
        if i < 8 then
            if i == 5 then
                found = i
                break
            end
        end
    end
end
results[#results + 1] = "deep_if=" .. tostring(found)

-- Test 2: Break after multiple conditions
local last = 0
for i = 1, 100 do
    last = i
    local should_break = false
    if i > 5 then
        if i % 2 == 0 then
            should_break = true
        end
    end
    if should_break then break end
end
results[#results + 1] = "multi_cond=" .. last

-- Test 3: Break with side effects
local side_effect = 0
for i = 1, 10 do
    side_effect = side_effect + 1
    if i >= 3 then
        side_effect = side_effect * 10  -- This runs for i=3
        break
    end
end
results[#results + 1] = "side=" .. side_effect

-- Test 4: Break in function called from loop (does NOT break loop)
local function maybeBreak(val)
    if val > 5 then
        return true
    end
    return false
end

local func_last = 0
for i = 1, 10 do
    func_last = i
    if maybeBreak(i) then
        break
    end
end
results[#results + 1] = "func_break=" .. func_last

print(table.concat(results, ","))
-- Expected: deep_if=5,multi_cond=6,side=30,func_break=6
