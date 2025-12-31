-- Test: Combined debug information retrieval
local results = {}

-- Test 1: Full function introspection
local outer_var = 100
local function introspect_me(a, b, c)
    local local_var = a + b
    local function nested()
        return outer_var + local_var
    end

    -- Get all info about this function
    local info = debug.getinfo(1, "nSluf")

    return {
        name = info.name or "anonymous",
        what = info.what,
        source = info.source and "has_source" or "no_source",
        linedefined = type(info.linedefined),
        nups = info.nups,
        nparams = info.nparams or -1,
        isvararg = info.isvararg and "yes" or "no"
    }
end

local info1 = introspect_me(1, 2, 3)
results[#results + 1] = "what=" .. info1.what
results[#results + 1] = "nups=" .. info1.nups

-- Test 2: Walk the call stack
local function level3()
    local stack = {}
    local level = 1
    while true do
        local info = debug.getinfo(level, "n")
        if not info then break end
        stack[#stack + 1] = info.name or "?"
        level = level + 1
    end
    return #stack
end
local function level2()
    return level3()
end
local function level1()
    return level2()
end
results[#results + 1] = "stack=" .. level1()

-- Test 3: All locals at once
local function all_locals()
    local a, b, c = 1, 2, 3
    local d = "four"
    local locals = {}
    local i = 1
    while true do
        local name, val = debug.getlocal(1, i)
        if not name then break end
        locals[name] = val
        i = i + 1
    end
    return locals
end
local locs = all_locals()
results[#results + 1] = "locals=" .. (locs.a and locs.b and locs.c and "found" or "missing")

-- Test 4: All upvalues at once
local uv1, uv2 = "up1", "up2"
local function all_upvalues()
    local _ = uv1 .. uv2
    return function()
        local ups = {}
        local fn = debug.getinfo(1, "f").func
        local i = 1
        while true do
            local name, val = debug.getupvalue(fn, i)
            if not name then break end
            ups[#ups + 1] = name
            i = i + 1
        end
        return ups
    end
end
local upval_checker = all_upvalues()
local ups = upval_checker()
results[#results + 1] = "upvals=" .. #ups

-- Test 5: Function identity through getinfo
local function identity_test()
    local info = debug.getinfo(1, "f")
    return info.func
end
local fn = identity_test
results[#results + 1] = "identity=" .. tostring(identity_test() == fn)

-- Test 6: Activelines (Lua 5.2+)
local function multiline()
    local x = 1
    local y = 2
    local z = 3
    return x + y + z
end
local info6 = debug.getinfo(multiline, "L")
if info6.activelines then
    local count = 0
    for _ in pairs(info6.activelines) do
        count = count + 1
    end
    results[#results + 1] = "lines=" .. (count > 0 and "has" or "none")
else
    results[#results + 1] = "lines=skip"
end

-- Test 7: Short source
local function short_src_test() end
local info7 = debug.getinfo(short_src_test, "S")
results[#results + 1] = "shortsrc=" .. (info7.short_src and "has" or "none")

-- Test 8: lastlinedefined
local function range_test()
    return 1
end
local info8 = debug.getinfo(range_test, "S")
results[#results + 1] = "lastline=" .. (info8.lastlinedefined and "has" or "none")

print(table.concat(results, ","))
-- Expected: what=Lua,nups=2,stack=4,locals=found,upvals>=1,identity=true,lines=has,shortsrc=has,lastline=has
