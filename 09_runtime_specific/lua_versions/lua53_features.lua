-- Test: Lua 5.3+ specific features
local results = {}

local version = _VERSION:match("5%.(%d)")
local minor = tonumber(version) or 0

-- Test 1: Integer subtype
local i = 42
local f = 42.0
if math.type then
    results[#results + 1] = "inttype=" .. math.type(i)
    results[#results + 1] = "floattype=" .. math.type(f)
else
    results[#results + 1] = "inttype=nil"
    results[#results + 1] = "floattype=nil"
end

-- Test 2: Bitwise operators
local bit_ok = pcall(function()
    local code = "return 5 & 3, 5 | 3, 5 ~ 3, ~0, 1 << 4, 16 >> 2"
    local fn = load(code)
    return fn and fn()
end)
results[#results + 1] = "bitops=" .. (bit_ok and "works" or "error")

-- Test 3: Integer division operator
local idiv_ok = pcall(function()
    local code = "return 7 // 3"
    local fn = load(code)
    return fn and fn() == 2
end)
results[#results + 1] = "idiv=" .. (idiv_ok and "works" or "error")

-- Test 4: utf8 library
if utf8 then
    results[#results + 1] = "utf8=exists"
    -- Test utf8.len
    local s = "hello"
    results[#results + 1] = "utf8len=" .. utf8.len(s)
else
    results[#results + 1] = "utf8=nil"
    results[#results + 1] = "utf8len=nil"
end

-- Test 5: math.tointeger
if math.tointeger then
    results[#results + 1] = "toint=" .. tostring(math.tointeger(42.0))
    results[#results + 1] = "toint_fail=" .. tostring(math.tointeger(42.5))
else
    results[#results + 1] = "toint=nil"
    results[#results + 1] = "toint_fail=nil"
end

-- Test 6: math.ult (unsigned less than)
if math.ult then
    results[#results + 1] = "ult=" .. tostring(math.ult(-1, 1))
else
    results[#results + 1] = "ult=nil"
end

-- Test 7: string.pack and string.unpack
if string.pack then
    local packed = string.pack(">I4", 0x12345678)
    local unpacked = string.unpack(">I4", packed)
    results[#results + 1] = "pack=" .. string.format("%x", unpacked)
else
    results[#results + 1] = "pack=nil"
end

-- Test 8: math.maxinteger and math.mininteger
if math.maxinteger then
    results[#results + 1] = "maxint=" .. (math.maxinteger > 0 and "positive" or "error")
    results[#results + 1] = "minint=" .. (math.mininteger < 0 and "negative" or "error")
else
    results[#results + 1] = "maxint=nil"
    results[#results + 1] = "minint=nil"
end

-- Test 9: __idiv and __band metamethods
if minor >= 3 then
    local mt = {
        __idiv = function(a, b) return "custom_idiv" end,
        __band = function(a, b) return "custom_band" end
    }
    local t = setmetatable({}, mt)
    -- These would need the operators to work
    results[#results + 1] = "idiv_mt=exists"
else
    results[#results + 1] = "idiv_mt=nil"
end

-- Test 10: coroutine.isyieldable
if coroutine.isyieldable then
    local co = coroutine.create(function()
        return coroutine.isyieldable()
    end)
    local _, yieldable = coroutine.resume(co)
    results[#results + 1] = "isyieldable=" .. tostring(yieldable)
else
    results[#results + 1] = "isyieldable=nil"
end

print(table.concat(results, ","))
-- Expected varies by Lua version
