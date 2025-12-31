-- Test: Error boundary patterns
local results = {}

-- Test 1: Error boundary function
local function errorBoundary(fn, fallback)
    local ok, result = pcall(fn)
    if ok then
        return result
    end
    return fallback
end
results[#results + 1] = "boundary=" .. errorBoundary(function() return 42 end, 0)
results[#results + 1] = "fallback=" .. errorBoundary(function() error("e") end, 99)

-- Test 2: Error boundary with logging
local errorLog = {}
local function loggedBoundary(fn)
    local ok, result = pcall(fn)
    if not ok then
        errorLog[#errorLog + 1] = tostring(result)
    end
    return ok, result
end
loggedBoundary(function() error("logged") end)
results[#results + 1] = "logged=" .. #errorLog

-- Test 3: Propagating boundary
local function propagatingBoundary(fn)
    local ok, result = pcall(fn)
    if ok then
        return result
    end
    -- Transform and rethrow
    error({wrapped = true, original = result})
end
local ok3, err3 = pcall(function()
    propagatingBoundary(function() error("original") end)
end)
results[#results + 1] = "propagate=" .. tostring(type(err3) == "table" and err3.wrapped)

-- Test 4: Selective error handling
local function selectiveBoundary(fn)
    local ok, result = pcall(fn)
    if ok then return true, result end

    if type(result) == "table" and result.recoverable then
        return false, nil  -- Handle silently
    end
    error(result)  -- Rethrow non-recoverable
end
local ok4a, _ = pcall(function()
    return selectiveBoundary(function()
        error({recoverable = true})
    end)
end)
local ok4b, _ = pcall(function()
    return selectiveBoundary(function()
        error({recoverable = false})
    end)
end)
results[#results + 1] = "selective=" .. tostring(ok4a) .. ":" .. tostring(ok4b)

-- Test 5: Chained boundaries
local function boundary1(fn)
    return pcall(fn)
end
local function boundary2(fn)
    local ok, result = boundary1(fn)
    return ok, ok and result * 2 or result
end
local ok5, val5 = boundary2(function() return 10 end)
results[#results + 1] = "chained=" .. val5

print(table.concat(results, ","))
-- Expected: boundary=42,fallback=99,logged=1,propagate=true,selective=true:false,chained=20
