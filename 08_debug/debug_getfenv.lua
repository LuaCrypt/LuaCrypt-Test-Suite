-- Test: debug.getfenv and setfenv (Lua 5.1) or _ENV (Lua 5.2+)
local results = {}

-- Check Lua version for appropriate tests
local version = _VERSION:match("Lua (%d+%.%d+)")
local major, minor = version:match("(%d+)%.(%d+)")
major, minor = tonumber(major), tonumber(minor)

if major == 5 and minor == 1 then
    -- Lua 5.1 style: getfenv/setfenv

    -- Test 1: getfenv of function
    local function test1()
        return x or "nil"
    end
    local env1 = getfenv(test1)
    results[#results + 1] = "getfenv=" .. (env1 == _G and "global" or "other")

    -- Test 2: setfenv
    local function test2()
        return myvar or "nil"
    end
    setfenv(test2, {myvar = 42})
    results[#results + 1] = "setfenv=" .. test2()

    -- Test 3: Level-based getfenv
    local function inner()
        return getfenv(2)
    end
    local function outer()
        return inner()
    end
    local env3 = outer()
    results[#results + 1] = "level=" .. (env3 and "found" or "nil")

    -- Test 4: setfenv returns function
    local function test4() end
    local ret = setfenv(test4, {})
    results[#results + 1] = "return=" .. (ret == test4 and "same" or "diff")

    -- Test 5: New environment inherits nothing
    local function test5()
        return type(print)
    end
    setfenv(test5, {type = type})
    results[#results + 1] = "isolated=" .. test5()

else
    -- Lua 5.2+ style: _ENV

    -- Test 1: _ENV exists
    results[#results + 1] = "env=" .. (_ENV and "exists" or "nil")

    -- Test 2: _ENV is _G by default
    results[#results + 1] = "default=" .. tostring(_ENV == _G)

    -- Test 3: Local _ENV
    local function test3()
        local _ENV = {x = 42, tostring = tostring}
        return x
    end
    results[#results + 1] = "local_env=" .. test3()

    -- Test 4: _ENV as upvalue
    local captured_env
    local function test4()
        captured_env = _ENV
    end
    test4()
    results[#results + 1] = "upvalue=" .. tostring(captured_env == _G)

    -- Test 5: Sandbox with _ENV
    local sandbox = setmetatable({}, {__index = _G})
    local fn = load("return type(print)", "test", "t", sandbox)
    results[#results + 1] = "sandbox=" .. (fn and fn() or "error")

    -- Test 6: debug.getupvalue can get _ENV
    local function uses_global()
        return print
    end
    local found_env = false
    for i = 1, 10 do
        local name, val = debug.getupvalue(uses_global, i)
        if name == "_ENV" then
            found_env = true
            break
        end
        if not name then break end
    end
    results[#results + 1] = "debug_env=" .. (found_env and "found" or "notfound")

    -- Test 7: Modify _ENV via debug
    local function isolated()
        return testvar or "nil"
    end
    for i = 1, 10 do
        local name, val = debug.getupvalue(isolated, i)
        if name == "_ENV" then
            debug.setupvalue(isolated, i, {testvar = 99})
            break
        end
        if not name then break end
    end
    results[#results + 1] = "modify=" .. isolated()
end

print(table.concat(results, ","))
-- Expected varies by Lua version
