-- Test: Error context preservation
local results = {}

-- Test 1: Error with context table
local function withContext(fn, context)
    local ok, result = pcall(fn)
    if not ok then
        return false, {
            error = result,
            context = context,
            time = os.time and os.time() or 0
        }
    end
    return true, result
end

local ok1, res1 = withContext(function()
    error("context error")
end, {operation = "test1"})
results[#results + 1] = "context=" .. res1.context.operation

-- Test 2: Accumulating context through call stack
local function wrapWithLevel(fn, level)
    local ok, result = pcall(fn)
    if not ok then
        if type(result) == "table" then
            result.levels = (result.levels or 0) + 1
        else
            result = {original = result, levels = 1}
        end
    end
    return ok, result
end

local ok2, res2 = pcall(function()
    wrapWithLevel(function()
        wrapWithLevel(function()
            wrapWithLevel(function()
                error("deep")
            end, 1)
        end, 2)
    end, 3)
end)
-- Note: levels won't propagate through pcall as expected

-- Test 3: Error chain
local function chainedOperation()
    local step1 = function()
        error({step = 1, msg = "step1 failed"})
    end
    local step2 = function()
        local ok, err = pcall(step1)
        if not ok then
            err.step = 2
            error(err)
        end
    end
    return pcall(step2)
end
local ok3, err3 = chainedOperation()
results[#results + 1] = "chain_step=" .. (type(err3) == "table" and err3.step or "unknown")

-- Test 4: Source tracking
local function track(fn, source)
    local ok, result = pcall(fn)
    if not ok then
        return false, source .. ": " .. tostring(result)
    end
    return true, result
end
local ok4, res4 = track(function() error("tracked") end, "module.function")
results[#results + 1] = "tracked=" .. (string.find(res4, "module") and "yes" or "no")

-- Test 5: Retry with context
local function retryWithContext(fn, maxRetries)
    local attempts = {}
    for i = 1, maxRetries do
        local ok, result = pcall(fn)
        if ok then
            return true, result, attempts
        end
        attempts[#attempts + 1] = result
    end
    return false, "max retries", attempts
end
local attempt = 0
local ok5, res5, history = retryWithContext(function()
    attempt = attempt + 1
    if attempt < 3 then error("try " .. attempt) end
    return "success"
end, 5)
results[#results + 1] = "retry_attempts=" .. #history

print(table.concat(results, ","))
-- Expected: context=test1,chain_step=2,tracked=yes,retry_attempts=2
