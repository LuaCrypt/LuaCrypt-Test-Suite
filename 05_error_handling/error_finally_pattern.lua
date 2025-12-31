-- Test: Finally-like patterns in Lua
local results = {}

-- Test 1: Basic finally pattern
local finally_ran = false
local function withFinally()
    local ok, result = pcall(function()
        error("fail")
    end)
    finally_ran = true  -- "finally" - always runs
    if not ok then
        return nil, result
    end
    return result
end
local r, e = withFinally()
results[#results + 1] = "finally=" .. tostring(finally_ran)

-- Test 2: Resource cleanup pattern
local resource_closed = false
local function useResource()
    local resource = {open = true}
    local ok, result = pcall(function()
        -- Use resource
        error("operation failed")
    end)
    -- Cleanup (finally)
    resource.open = false
    resource_closed = true

    if not ok then
        return nil, result
    end
    return result
end
useResource()
results[#results + 1] = "cleanup=" .. tostring(resource_closed)

-- Test 3: Nested finally
local order = {}
local function nestedFinally()
    local function inner()
        local ok = pcall(function()
            error("inner fail")
        end)
        order[#order + 1] = "inner_finally"
        return ok
    end

    local ok = pcall(function()
        inner()
        error("outer fail")
    end)
    order[#order + 1] = "outer_finally"
    return ok
end
nestedFinally()
results[#results + 1] = "nested=" .. table.concat(order, ";")

-- Test 4: Return value with finally
local function returnWithFinally(shouldError)
    local result
    local ok, err = pcall(function()
        if shouldError then error("err") end
        result = "success"
    end)
    -- finally
    result = result or "default"
    return result
end
results[#results + 1] = "return=" .. returnWithFinally(false) .. ":" .. returnWithFinally(true)

-- Test 5: Multiple resources
local closes = {}
local function multiResource()
    local r1, r2 = {id = 1}, {id = 2}
    local ok, err = pcall(function()
        -- use resources
        error("multi fail")
    end)
    -- Cleanup in reverse order
    closes[#closes + 1] = r2.id
    closes[#closes + 1] = r1.id
    return ok
end
multiResource()
results[#results + 1] = "multi=" .. table.concat(closes, ";")

print(table.concat(results, ","))
-- Expected: finally=true,cleanup=true,nested=inner_finally;outer_finally,return=success:default,multi=2;1
