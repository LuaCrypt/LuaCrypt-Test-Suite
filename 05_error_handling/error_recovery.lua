-- Test: Error recovery patterns
local results = {}

-- Test 1: Default value on error
local function safeGet(t, key, default)
    local ok, val = pcall(function()
        return t[key]
    end)
    if ok then
        return val ~= nil and val or default
    end
    return default
end
results[#results + 1] = "default=" .. safeGet({a = 1}, "a", 0) .. ":" .. safeGet({}, "b", 99)

-- Test 2: Retry pattern
local attempts = 0
local function unreliable()
    attempts = attempts + 1
    if attempts < 3 then
        error("not ready")
    end
    return "success"
end

local function retry(fn, maxAttempts)
    for i = 1, maxAttempts do
        local ok, result = pcall(fn)
        if ok then return true, result end
    end
    return false, "max attempts"
end

local ok, result = retry(unreliable, 5)
results[#results + 1] = "retry=" .. tostring(ok) .. ":" .. result

-- Test 3: Cleanup on error
local cleanedUp = false
local function withCleanup()
    local ok, err = pcall(function()
        error("operation failed")
    end)
    cleanedUp = true  -- Always cleanup
    if not ok then
        return nil, err
    end
    return "done"
end
local res, err = withCleanup()
results[#results + 1] = "cleanup=" .. tostring(cleanedUp) .. ":" .. tostring(res)

-- Test 4: Error wrapping
local function wrapError(fn)
    local ok, result = pcall(fn)
    if not ok then
        return nil, {original = result, wrapped = true}
    end
    return result
end
local r, e = wrapError(function() error("inner") end)
results[#results + 1] = "wrap=" .. tostring(r) .. ":" .. tostring(e and e.wrapped)

-- Test 5: Multiple operations, continue on error
local successes = 0
local ops = {
    function() return 1 end,
    function() error("fail") end,
    function() return 2 end,
    function() error("fail2") end,
    function() return 3 end
}
for _, op in ipairs(ops) do
    local ok = pcall(op)
    if ok then successes = successes + 1 end
end
results[#results + 1] = "continue=" .. successes

print(table.concat(results, ","))
-- Expected: default=1:99,retry=true:success,cleanup=true:nil,wrap=nil:true,continue=3
