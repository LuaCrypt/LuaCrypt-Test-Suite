-- Test: Side effects in if conditions
local results = {}
local counter = 0

-- Test 1: Increment in condition
local function incAndReturn(val)
    counter = counter + 1
    return val
end

if incAndReturn(true) then
    results[#results + 1] = "c=" .. counter
end

-- Test 2: Multiple calls in AND (both evaluated when first is true)
counter = 0
if incAndReturn(true) and incAndReturn(true) then
    results[#results + 1] = "and_c=" .. counter
end

-- Test 3: Multiple calls in AND (short-circuit)
counter = 0
if incAndReturn(false) and incAndReturn(true) then
    results[#results + 1] = "short_and_taken"
end
results[#results + 1] = "short_and_c=" .. counter

-- Test 4: Multiple calls in OR (short-circuit)
counter = 0
if incAndReturn(true) or incAndReturn(true) then
    results[#results + 1] = "short_or_c=" .. counter
end

-- Test 5: Modification during condition
local state = {value = 0}
local function modifyAndCheck()
    state.value = state.value + 10
    return state.value > 5
end

if modifyAndCheck() then
    results[#results + 1] = "modified=" .. state.value
end

-- Test 6: Multiple modifications
state.value = 0
if modifyAndCheck() and modifyAndCheck() then
    results[#results + 1] = "multi_mod=" .. state.value
end

print(table.concat(results, ","))
-- Expected: c=1,and_c=2,short_and_c=1,short_or_c=1,modified=10,multi_mod=20
