-- Test: Early return patterns
local results = {}

-- Test 1: Guard clause
local function guard(x)
    if x < 0 then return "negative" end
    if x == 0 then return "zero" end
    return "positive"
end
results[#results + 1] = "guard=" .. guard(-5) .. ";" .. guard(0) .. ";" .. guard(5)

-- Test 2: Return from nested if
local function nested(x, y)
    if x > 0 then
        if y > 0 then
            return "both_pos"
        else
            return "x_pos"
        end
    else
        return "x_neg"
    end
end
results[#results + 1] = "nested=" .. nested(1, 1) .. ";" .. nested(1, -1) .. ";" .. nested(-1, 1)

-- Test 3: Return from loop
local function findFirst(arr, target)
    for i, v in ipairs(arr) do
        if v == target then
            return i
        end
    end
    return nil
end
results[#results + 1] = "find=" .. tostring(findFirst({10, 20, 30}, 20))
results[#results + 1] = "notfound=" .. tostring(findFirst({10, 20, 30}, 99))

-- Test 4: Multiple early returns
local function classify(n)
    if n < 0 then return "neg" end
    if n == 0 then return "zero" end
    if n < 10 then return "small" end
    if n < 100 then return "medium" end
    return "large"
end
results[#results + 1] = "classify=" .. classify(-1) .. ";" .. classify(0) .. ";" .. classify(5) .. ";" .. classify(50) .. ";" .. classify(500)

-- Test 5: Return after side effect
local counter = 0
local function withSideEffect(x)
    counter = counter + 1
    if x < 0 then return false end
    counter = counter + 10
    return true
end
withSideEffect(-1)
withSideEffect(1)
results[#results + 1] = "side=" .. counter

-- Test 6: Code after return is not executed
local executed = false
local function unreachable()
    if true then
        return "done"
    end
    executed = true  -- Never runs (but valid syntax)
end
unreachable()
results[#results + 1] = "unreach=" .. tostring(executed)

print(table.concat(results, ","))
-- Expected: guard=negative;zero;positive,nested=both_pos;x_pos;x_neg,find=2,notfound=nil,classify=neg;zero;small;medium;large,side=12,unreach=false
