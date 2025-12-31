-- Test: Deeply nested if statements
local results = {}

local a, b, c, d, e = 1, 2, 3, 4, 5

-- Test 1: 5 levels deep - all true
if a == 1 then
    if b == 2 then
        if c == 3 then
            if d == 4 then
                if e == 5 then
                    results[#results + 1] = "depth5_all"
                end
            end
        end
    end
end

-- Test 2: Mixed nesting with else
if a == 1 then
    if b == 99 then
        results[#results + 1] = "wrong"
    else
        if c == 3 then
            results[#results + 1] = "nested_else"
        end
    end
end

-- Test 3: Nesting with elseif
if a == 0 then
    results[#results + 1] = "a0"
elseif a == 1 then
    if b == 0 then
        results[#results + 1] = "b0"
    elseif b == 2 then
        if c == 0 then
            results[#results + 1] = "c0"
        elseif c == 3 then
            results[#results + 1] = "abc_match"
        end
    end
end

-- Test 4: Complex nested with early exit pattern
local function checkNested(x, y, z)
    if x <= 0 then
        return "x_bad"
    end
    if y <= 0 then
        return "y_bad"
    end
    if z <= 0 then
        return "z_bad"
    end
    return "all_good"
end

results[#results + 1] = checkNested(1, 2, 3)
results[#results + 1] = checkNested(0, 2, 3)
results[#results + 1] = checkNested(1, 0, 3)
results[#results + 1] = checkNested(1, 2, 0)

print(table.concat(results, ","))
-- Expected: depth5_all,nested_else,abc_match,all_good,x_bad,y_bad,z_bad
