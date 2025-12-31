-- Test: Nested pcall
local results = {}

-- Test 1: Nested success
local ok1, res1 = pcall(function()
    local ok2, res2 = pcall(function()
        return 42
    end)
    return ok2 and res2 or "inner_fail"
end)
results[#results + 1] = "nested_ok=" .. tostring(ok1) .. ":" .. res1

-- Test 2: Inner fails, outer catches
local ok3, res3 = pcall(function()
    local ok4, err4 = pcall(function()
        error("inner error")
    end)
    return ok4 and "unexpected" or "caught"
end)
results[#results + 1] = "inner_fail=" .. res3

-- Test 3: Outer fails
local ok5, err5 = pcall(function()
    pcall(function()
        -- Inner succeeds
    end)
    error("outer error")
end)
results[#results + 1] = "outer_fail=" .. tostring(ok5)

-- Test 4: Three levels
local ok6, res6 = pcall(function()
    return pcall(function()
        return pcall(function()
            return "deep"
        end)
    end)
end)
results[#results + 1] = "three_level=" .. tostring(ok6)

-- Test 5: Error propagation
local ok7, err7 = pcall(function()
    local ok, err = pcall(function()
        error("propagate")
    end)
    if not ok then
        error(err)  -- Re-throw
    end
end)
results[#results + 1] = "propagate=" .. tostring(ok7)

-- Test 6: Mixed success/fail
local log = {}
local ok8, res8 = pcall(function()
    log[#log + 1] = "outer_start"
    local ok_a = pcall(function()
        log[#log + 1] = "inner_a"
    end)
    local ok_b = pcall(function()
        log[#log + 1] = "inner_b"
        error("b_fail")
    end)
    log[#log + 1] = "outer_end"
    return ok_a and ok_b
end)
results[#results + 1] = "mixed=" .. table.concat(log, ";")

print(table.concat(results, ","))
-- Expected: nested_ok=true:42,inner_fail=caught,outer_fail=false,three_level=true,propagate=false,mixed=outer_start;inner_a;inner_b;outer_end
