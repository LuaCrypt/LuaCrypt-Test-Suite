-- Test: Basic if/elseif/else branching
local results = {}

-- Test 1: Simple if true
local x = 10
if x > 5 then
    results[#results + 1] = "gt5"
end

-- Test 2: Simple if false (no else)
if x > 20 then
    results[#results + 1] = "gt20"
end

-- Test 3: if-else
if x > 20 then
    results[#results + 1] = "branch_a"
else
    results[#results + 1] = "branch_b"
end

-- Test 4: if-elseif-else
if x > 20 then
    results[#results + 1] = "big"
elseif x > 5 then
    results[#results + 1] = "medium"
else
    results[#results + 1] = "small"
end

-- Test 5: Multiple elseif
local y = 3
if y == 1 then
    results[#results + 1] = "one"
elseif y == 2 then
    results[#results + 1] = "two"
elseif y == 3 then
    results[#results + 1] = "three"
elseif y == 4 then
    results[#results + 1] = "four"
else
    results[#results + 1] = "other"
end

-- Test 6: Nested if
if x > 5 then
    if x < 15 then
        results[#results + 1] = "nested_ok"
    end
end

print(table.concat(results, ","))
-- Expected: gt5,branch_b,medium,three,nested_ok
