-- Test: Math library differences across Lua versions
local results = {}

-- Test 1: math.log with base argument (5.2+)
local log_base = pcall(function()
    return math.log(8, 2)
end)
if log_base then
    results[#results + 1] = "log_base=" .. math.floor(math.log(8, 2))
else
    results[#results + 1] = "log_base=nil"
end

-- Test 2: math.log10 (deprecated in 5.2+, removed in some)
if math.log10 then
    results[#results + 1] = "log10=" .. math.floor(math.log10(100))
else
    results[#results + 1] = "log10=nil"
end

-- Test 3: math.atan2 (deprecated in 5.3+, use math.atan with two args)
if math.atan2 then
    results[#results + 1] = "atan2=" .. math.floor(math.atan2(1, 1) * 100)
else
    -- Try math.atan with two args
    local ok, val = pcall(function() return math.atan(1, 1) end)
    if ok then
        results[#results + 1] = "atan2_alt=" .. math.floor(val * 100)
    else
        results[#results + 1] = "atan2=nil"
    end
end

-- Test 4: math.pow (deprecated, use ^ operator)
if math.pow then
    results[#results + 1] = "pow=" .. math.pow(2, 10)
else
    results[#results + 1] = "pow=nil"
end

-- Test 5: math.cosh/sinh/tanh (removed in 5.3+)
if math.cosh then
    results[#results + 1] = "cosh=" .. math.floor(math.cosh(0))
else
    results[#results + 1] = "cosh=nil"
end

-- Test 6: math.ldexp/frexp
if math.ldexp then
    results[#results + 1] = "ldexp=" .. math.ldexp(0.5, 3)
else
    results[#results + 1] = "ldexp=nil"
end

-- Test 7: math.type (5.3+)
if math.type then
    results[#results + 1] = "type_int=" .. math.type(42)
    results[#results + 1] = "type_float=" .. math.type(42.5)
else
    results[#results + 1] = "type_int=nil"
    results[#results + 1] = "type_float=nil"
end

-- Test 8: math.tointeger (5.3+)
if math.tointeger then
    results[#results + 1] = "tointeger=" .. tostring(math.tointeger(42.0))
else
    results[#results + 1] = "tointeger=nil"
end

-- Test 9: math.ult (5.3+)
if math.ult then
    -- unsigned less than
    results[#results + 1] = "ult=" .. tostring(math.ult(-1, 1))
else
    results[#results + 1] = "ult=nil"
end

-- Test 10: math.maxinteger/mininteger (5.3+)
if math.maxinteger then
    results[#results + 1] = "maxint=" .. (math.maxinteger > 0 and "pos" or "neg")
else
    results[#results + 1] = "maxint=nil"
end

-- Test 11: Integer division behavior
local div_result = 7 / 3
local idiv_result
if math.floor then
    idiv_result = math.floor(7 / 3)
end
results[#results + 1] = "div=" .. string.format("%.2f", div_result)
results[#results + 1] = "idiv=" .. (idiv_result or "nil")

-- Test 12: Negative modulo behavior
local mod_neg = -5 % 3
results[#results + 1] = "mod_neg=" .. mod_neg

-- Test 13: math.random integer return
math.randomseed(12345)
local r = math.random(1, 10)
local rand_type = math.type and math.type(r) or type(r)
results[#results + 1] = "rand_type=" .. rand_type

print(table.concat(results, ","))
-- Expected varies by Lua version
