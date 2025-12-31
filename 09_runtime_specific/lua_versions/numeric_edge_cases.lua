-- Test: Numeric edge cases across versions
local results = {}

-- Test 1: Integer limits
if math.maxinteger then
    results[#results + 1] = "maxint_type=" .. math.type(math.maxinteger)
else
    results[#results + 1] = "maxint_type=nil"
end

-- Test 2: Integer overflow behavior
local large = 2^62
if math.type then
    results[#results + 1] = "large_type=" .. math.type(large)
else
    results[#results + 1] = "large_type=" .. type(large)
end

-- Test 3: Float precision
local precise = 0.1 + 0.2
results[#results + 1] = "float_prec=" .. (precise == 0.3 and "exact" or "inexact")

-- Test 4: Subnormal numbers
local subnorm = 1e-320
results[#results + 1] = "subnorm=" .. (subnorm > 0 and "nonzero" or "zero")

-- Test 5: Hexadecimal floats (5.2+)
local hex_ok = pcall(function()
    return load("return 0x1.5p+3")()
end)
if hex_ok then
    local val = load("return 0x1.5p+3")()
    results[#results + 1] = "hexfloat=" .. val
else
    results[#results + 1] = "hexfloat=nil"
end

-- Test 6: tostring precision
local pi_str = tostring(math.pi)
results[#results + 1] = "pi_digits=" .. #pi_str

-- Test 7: tonumber edge cases
results[#results + 1] = "tonumber_ws=" .. tostring(tonumber("  42  "))
results[#results + 1] = "tonumber_hex=" .. tostring(tonumber("0xff"))
results[#results + 1] = "tonumber_neg=" .. tostring(tonumber("-1e5"))

-- Test 8: Division by zero
local div_zero = 1/0
results[#results + 1] = "divzero=" .. (div_zero == math.huge and "inf" or "other")

-- Test 9: Negative zero
local neg_zero = -0.0
local pos_zero = 0.0
results[#results + 1] = "negzero_eq=" .. tostring(neg_zero == pos_zero)
results[#results + 1] = "negzero_str=" .. (1/neg_zero < 0 and "-inf" or "+inf")

-- Test 10: Very small differences
local a = 1.0000000000000001
local b = 1.0000000000000002
results[#results + 1] = "tiny_diff=" .. tostring(a == b)

-- Test 11: math.modf
local int_part, frac_part = math.modf(3.7)
results[#results + 1] = "modf=" .. int_part .. ":" .. string.format("%.1f", frac_part)

-- Test 12: math.fmod vs % operator
local fmod_neg = math.fmod(-5, 3)
local mod_neg = -5 % 3
results[#results + 1] = "fmod_vs_mod=" .. fmod_neg .. ":" .. mod_neg

-- Test 13: Large integer comparison
local big1 = 2^53
local big2 = 2^53 + 1
if math.type then
    results[#results + 1] = "big_cmp=" .. tostring(big1 < big2)
else
    results[#results + 1] = "big_cmp=skip"
end

-- Test 14: NaN propagation
local nan = 0/0
results[#results + 1] = "nan_add=" .. tostring(nan + 1 ~= nan + 1)
local nan_str = tostring(nan)
results[#results + 1] = "nan_type=" .. ((nan_str == "nan" or nan_str == "-nan") and "nan" or "other")

print(table.concat(results, ","))
-- Expected varies by Lua version and platform
