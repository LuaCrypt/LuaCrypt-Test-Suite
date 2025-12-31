-- Test: Lua 5.4+ specific features
local results = {}

local version = _VERSION:match("5%.(%d)")
local minor = tonumber(version) or 0

-- Test 1: const and close attributes
local const_ok = pcall(function()
    local code = [[
        local x <const> = 42
        return x
    ]]
    local fn = load(code)
    return fn and fn() == 42
end)
results[#results + 1] = "const=" .. (const_ok and "works" or "error")

-- Test 2: to-be-closed variables
local close_ok = pcall(function()
    local code = [[
        local closed = false
        do
            local t <close> = setmetatable({}, {
                __close = function() closed = true end
            })
        end
        return closed
    ]]
    local fn = load(code)
    return fn and fn() == true
end)
results[#results + 1] = "close=" .. (close_ok and "works" or "error")

-- Test 3: warn function
if warn then
    results[#results + 1] = "warn=exists"
else
    results[#results + 1] = "warn=nil"
end

-- Test 4: coroutine.close
if coroutine.close then
    local co = coroutine.create(function()
        coroutine.yield()
    end)
    coroutine.resume(co)
    local ok = coroutine.close(co)
    results[#results + 1] = "coclose=" .. tostring(ok)
else
    results[#results + 1] = "coclose=nil"
end

-- Test 5: New random number generator
if math.randomseed then
    -- 5.4 allows calling randomseed with no args
    local ok = pcall(function()
        math.randomseed()
    end)
    results[#results + 1] = "randseed=" .. (ok and "noarg" or "argneeded")
end

-- Test 6: Generational GC mode
if collectgarbage then
    local modes = {"generational", "incremental"}
    local gen_ok = pcall(function()
        collectgarbage("generational")
    end)
    results[#results + 1] = "gengc=" .. (gen_ok and "works" or "error")
end

-- Test 7: userdata can have multiple user values (5.4+)
-- This is mostly a C-level feature, skip in pure Lua

-- Test 8: __close metamethod
if minor >= 4 then
    local closed_count = 0
    local close_mt = {
        __close = function(self, err)
            closed_count = closed_count + 1
        end
    }
    local ok = pcall(function()
        local code = [[
            local t <close> = setmetatable({}, ...)
            -- leaving scope triggers __close
        ]]
        local fn = load(code)
        if fn then fn(close_mt) end
    end)
    results[#results + 1] = "close_mt=" .. (ok and "works" or "error")
else
    results[#results + 1] = "close_mt=skip"
end

-- Test 9: Empty vararg in middle of list
local vararg_ok = pcall(function()
    local function test(...)
        return select('#', ..., nil)
    end
    return test(1, 2, 3)
end)
results[#results + 1] = "vararg=" .. (vararg_ok and "works" or "error")

-- Test 10: New metamethod __close error handling
if minor >= 4 then
    local close_error_ok = pcall(function()
        local code = [[
            local t <close> = setmetatable({}, {
                __close = function(self, err)
                    if err then return end
                end
            })
            error("test")
        ]]
        local fn = load(code)
        if fn then pcall(fn) end
    end)
    results[#results + 1] = "close_err=" .. (close_error_ok and "handled" or "error")
else
    results[#results + 1] = "close_err=skip"
end

print(table.concat(results, ","))
-- Expected varies by Lua version
