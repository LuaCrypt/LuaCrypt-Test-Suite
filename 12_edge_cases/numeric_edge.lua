-- Edge cases for numeric literals: subnormals, negative zero, int vs float
-- Tests fixes for: bit-exact number comparison, negative zero encoding, float literal preservation

local results = {}

-- Test 1: Negative zero preservation
local neg_zero = -0.0
local pos_zero = 0.0
results[#results + 1] = tostring(1 / neg_zero == -math.huge)  -- true (division by -0 gives -inf)
results[#results + 1] = tostring(1 / pos_zero == math.huge)   -- true (division by +0 gives +inf)

-- Test 2: Negative zero in comparisons
results[#results + 1] = tostring(neg_zero == pos_zero)  -- true (they're equal)
results[#results + 1] = tostring(neg_zero == 0)         -- true

-- Test 3: Integer vs Float distinction (Lua 5.3+)
local int_val = 42
local float_val = 42.0

if math.type then
    results[#results + 1] = math.type(int_val)    -- integer
    results[#results + 1] = math.type(float_val)  -- float
else
    results[#results + 1] = "integer"  -- fallback for older Lua
    results[#results + 1] = "float"
end

-- Test 4: Integer and float equality
results[#results + 1] = tostring(int_val == float_val)  -- true

-- Test 5: Very small numbers (subnormals)
local tiny1 = 1e-320
local tiny2 = 1e-320
local zero = 0

results[#results + 1] = tostring(tiny1 == tiny2)  -- true
results[#results + 1] = tostring(tiny1 == zero)   -- false (subnormal != 0)
results[#results + 1] = tostring(tiny1 > 0)       -- true

-- Test 6: Subnormal arithmetic
local subnormal = 5e-324  -- smallest positive subnormal
results[#results + 1] = tostring(subnormal > 0)  -- true
results[#results + 1] = tostring(subnormal * 2 > subnormal)  -- true

-- Test 7: Infinity handling
local inf = math.huge
local ninf = -math.huge
results[#results + 1] = tostring(inf > 0)       -- true
results[#results + 1] = tostring(ninf < 0)      -- true
results[#results + 1] = tostring(inf + 1 == inf)  -- true

-- Test 8: NaN handling
local nan = 0/0
results[#results + 1] = tostring(nan ~= nan)  -- true (NaN != NaN)
results[#results + 1] = tostring(nan == nan)  -- false

-- Test 9: Large integers (within float precision)
local big = 9007199254740992  -- 2^53
local big_minus_one = 9007199254740991
results[#results + 1] = tostring(big > big_minus_one)  -- true

-- Test 10: Hex float literals (Lua 5.2+)
local hex_float = 0x1p10  -- 1024
results[#results + 1] = tostring(hex_float)  -- 1024 or 1024.0

-- Test 11: Scientific notation edge cases
local sci1 = 1e0
local sci2 = 1e+0
local sci3 = 1e-0
results[#results + 1] = tostring(sci1 == sci2 and sci2 == sci3)  -- true

-- Test 12: Mixed arithmetic with int/float
local mix_result = 10 + 0.5
if math.type then
    results[#results + 1] = math.type(mix_result)  -- float
else
    results[#results + 1] = "float"
end

-- Test 13: Floor division result type (Lua 5.3+)
if math.type then
    local floor_div = 10 // 3
    results[#results + 1] = math.type(floor_div)  -- integer
else
    results[#results + 1] = "integer"  -- fallback
end

-- Test 14: Negative zero in table keys
local t = {}
t[0] = "positive"
t[-0.0] = "negative"  -- Should overwrite since 0 == -0
results[#results + 1] = t[0]  -- negative

-- Test 15: Constant folding with special values
local folded = -(0.0)  -- Should be -0.0
results[#results + 1] = tostring(1 / folded == -math.huge)  -- true

print(table.concat(results, ","))
-- Expected output varies by Lua version, but core behaviors should match
