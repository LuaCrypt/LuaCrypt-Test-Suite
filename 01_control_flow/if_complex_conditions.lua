-- Test: Complex conditions in if statements
local results = {}

-- Test 1: AND condition
local a, b = 5, 10
if a > 0 and b > 0 then
    results[#results + 1] = "both_positive"
end

-- Test 2: OR condition
local c = -5
if c > 0 or b > 0 then
    results[#results + 1] = "one_positive"
end

-- Test 3: NOT condition
if not (a < 0) then
    results[#results + 1] = "not_negative"
end

-- Test 4: Mixed AND/OR (precedence)
if a > 0 and b > 0 or c > 0 then
    results[#results + 1] = "mixed1"
end

-- Test 5: Parenthesized conditions
if a > 0 and (b > 0 or c > 0) then
    results[#results + 1] = "mixed2"
end

-- Test 6: Short-circuit evaluation
local called = false
local function sideEffect()
    called = true
    return true
end

if false and sideEffect() then
    results[#results + 1] = "unreachable"
end
results[#results + 1] = called and "called" or "not_called"

-- Reset and test OR short-circuit
called = false
if true or sideEffect() then
    results[#results + 1] = "or_branch"
end
results[#results + 1] = called and "or_called" or "or_not_called"

print(table.concat(results, ","))
-- Expected: both_positive,one_positive,not_negative,mixed1,mixed2,not_called,or_branch,or_not_called
