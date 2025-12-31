-- Test: Arithmetic precision determinism
local results = {}

-- Test 1: Basic arithmetic
local a = 123.456
local b = 789.012
results[#results + 1] = "add=" .. string.format("%.6f", a + b)
results[#results + 1] = "sub=" .. string.format("%.6f", b - a)
results[#results + 1] = "mul=" .. string.format("%.6f", a * b)
results[#results + 1] = "div=" .. string.format("%.6f", b / a)

-- Test 2: Power operations
results[#results + 1] = "pow=" .. string.format("%.6f", 2.5 ^ 3.5)

-- Test 3: Modulo
results[#results + 1] = "mod=" .. string.format("%.6f", 17.5 % 3.2)

-- Test 4: Integer operations
local i1 = 1234567890
local i2 = 987654321
results[#results + 1] = "iadd=" .. (i1 + i2)
results[#results + 1] = "imul=" .. (i1 * 2)

-- Test 5: Mixed int/float
results[#results + 1] = "mixed=" .. string.format("%.6f", 42 + 3.14159)

-- Test 6: Trigonometry
results[#results + 1] = "sin=" .. string.format("%.6f", math.sin(1.234))
results[#results + 1] = "cos=" .. string.format("%.6f", math.cos(1.234))
results[#results + 1] = "tan=" .. string.format("%.6f", math.tan(1.234))

-- Test 7: Logarithms
results[#results + 1] = "log=" .. string.format("%.6f", math.log(100))
results[#results + 1] = "exp=" .. string.format("%.6f", math.exp(2.5))

-- Test 8: Square root
results[#results + 1] = "sqrt=" .. string.format("%.6f", math.sqrt(2))

-- Test 9: Floor/ceil/abs
results[#results + 1] = "floor=" .. math.floor(-3.7)
results[#results + 1] = "ceil=" .. math.ceil(-3.7)
results[#results + 1] = "abs=" .. math.abs(-42.5)

-- Test 10: Min/max
results[#results + 1] = "min=" .. math.min(1.5, -2.5, 3.5, -0.5)
results[#results + 1] = "max=" .. math.max(1.5, -2.5, 3.5, -0.5)

-- Test 11: Modf
local int_part, frac_part = math.modf(-3.7)
results[#results + 1] = "modf=" .. int_part .. ":" .. string.format("%.1f", frac_part)

-- Test 12: Complex expression
local complex = ((a + b) * (a - b)) / (a * b) + math.sqrt(a * a + b * b)
results[#results + 1] = "complex=" .. string.format("%.6f", complex)

-- Test 13: Accumulated error
local sum = 0
for i = 1, 1000 do
    sum = sum + 0.001
end
results[#results + 1] = "accum=" .. string.format("%.6f", sum)

-- Test 14: Large number precision
local large = 1e15 + 1
results[#results + 1] = "large=" .. string.format("%.0f", large)

print(table.concat(results, ","))
-- Expected: consistent values across runs on same platform
