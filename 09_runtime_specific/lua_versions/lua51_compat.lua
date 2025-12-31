-- Test: Lua 5.1 compatibility features
local results = {}

-- Test 1: Basic version check
local version = _VERSION
results[#results + 1] = "version=" .. (version:match("5%.[1234]") and "valid" or "unknown")

-- Test 2: module/require (5.1 style, deprecated in later versions)
if module then
    results[#results + 1] = "module=exists"
else
    results[#results + 1] = "module=nil"
end

-- Test 3: setfenv/getfenv (5.1 only)
if setfenv then
    local function test()
        return x or "nil"
    end
    setfenv(test, {x = 42})
    results[#results + 1] = "setfenv=" .. test()
else
    results[#results + 1] = "setfenv=deprecated"
end

-- Test 4: unpack location
if unpack then
    results[#results + 1] = "unpack=global"
elseif table.unpack then
    results[#results + 1] = "unpack=table"
else
    results[#results + 1] = "unpack=missing"
end

-- Test 5: loadstring vs load
if loadstring then
    local fn = loadstring("return 42")
    results[#results + 1] = "loadstring=" .. fn()
else
    results[#results + 1] = "loadstring=deprecated"
end

-- Test 6: math.log with base (5.2+)
local log_with_base = pcall(function()
    return math.log(8, 2)
end)
results[#results + 1] = "log_base=" .. (log_with_base and "yes" or "no")

-- Test 7: table.pack (5.2+)
if table.pack then
    local t = table.pack(1, 2, 3)
    results[#results + 1] = "pack=" .. t.n
else
    results[#results + 1] = "pack=nil"
end

-- Test 8: # operator on strings
local str = "hello"
results[#results + 1] = "strlen=" .. #str

-- Test 9: pairs/ipairs metamethods (5.2+)
local mt_pairs = {}
local t9 = setmetatable({}, {
    __pairs = function(t)
        return pairs(mt_pairs)
    end
})
mt_pairs.test = true
local found_test = false
for k, v in pairs(t9) do
    if k == "test" then found_test = true end
end
results[#results + 1] = "mtpairs=" .. (found_test and "works" or "ignored")

-- Test 10: arg table (main chunk)
results[#results + 1] = "arg=" .. (arg and "exists" or "nil")

print(table.concat(results, ","))
-- Expected varies by Lua version
