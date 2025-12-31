-- Test: Lua 5.2+ specific features
local results = {}

-- Test 1: _ENV
if _ENV then
    results[#results + 1] = "env=exists"
else
    results[#results + 1] = "env=nil"
end

-- Test 2: goto statement (5.2+)
local goto_works = pcall(function()
    local code = [[
        local x = 0
        ::start::
        x = x + 1
        if x < 3 then goto start end
        return x
    ]]
    local fn = load(code)
    return fn and fn() == 3
end)
results[#results + 1] = "goto=" .. (goto_works and "works" or "error")

-- Test 3: __pairs metamethod
local custom_pairs_called = false
local t3 = setmetatable({}, {
    __pairs = function(t)
        custom_pairs_called = true
        return pairs({a = 1})
    end
})
for k, v in pairs(t3) do end
results[#results + 1] = "pairs_mt=" .. (custom_pairs_called and "called" or "not")

-- Test 4: __ipairs metamethod
local custom_ipairs_called = false
local t4 = setmetatable({}, {
    __ipairs = function(t)
        custom_ipairs_called = true
        return ipairs({1, 2, 3})
    end
})
for i, v in ipairs(t4) do end
results[#results + 1] = "ipairs_mt=" .. (custom_ipairs_called and "called" or "not")

-- Test 5: bit32 library (5.2 only, removed in 5.3)
if bit32 then
    results[#results + 1] = "bit32=" .. bit32.band(0xFF, 0x0F)
else
    results[#results + 1] = "bit32=nil"
end

-- Test 6: table.pack and table.unpack
if table.pack then
    local t = table.pack(1, nil, 3)
    results[#results + 1] = "pack_n=" .. t.n
else
    results[#results + 1] = "pack_n=nil"
end

-- Test 7: rawlen function
if rawlen then
    local t = setmetatable({1, 2, 3}, {__len = function() return 99 end})
    results[#results + 1] = "rawlen=" .. rawlen(t)
else
    results[#results + 1] = "rawlen=nil"
end

-- Test 8: ephemeron tables (weak keys with strong values)
local weak_keys = setmetatable({}, {__mode = "k"})
local key = {}
weak_keys[key] = {data = "value"}
key = nil
collectgarbage("collect")
collectgarbage("collect")
local count = 0
for k, v in pairs(weak_keys) do count = count + 1 end
results[#results + 1] = "ephemeron=" .. count

-- Test 9: yield from metamethods (5.2+)
local co = coroutine.create(function()
    local t = setmetatable({}, {
        __index = function(t, k)
            coroutine.yield("in_metamethod")
            return k
        end
    })
    return t.test
end)
local ok1, v1 = coroutine.resume(co)
local ok2, v2 = coroutine.resume(co)
results[#results + 1] = "yield_mt=" .. (v1 == "in_metamethod" and "works" or "error")

-- Test 10: package.searchpath (5.2+)
if package.searchpath then
    results[#results + 1] = "searchpath=exists"
else
    results[#results + 1] = "searchpath=nil"
end

print(table.concat(results, ","))
-- Expected varies by Lua version
