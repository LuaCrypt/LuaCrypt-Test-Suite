-- Test: Basic math library functions
local results = {}

-- Test 1: Basic arithmetic
results[#results + 1] = "abs=" .. math.abs(-5)
results[#results + 1] = "floor=" .. math.floor(3.7)
results[#results + 1] = "ceil=" .. math.ceil(3.2)

-- Test 2: Min/max
results[#results + 1] = "min=" .. math.min(5, 2, 8, 1, 9)
results[#results + 1] = "max=" .. math.max(5, 2, 8, 1, 9)

-- Test 3: Trigonometry
results[#results + 1] = "sin0=" .. math.floor(math.sin(0) * 1000)
results[#results + 1] = "cos0=" .. math.floor(math.cos(0) * 1000)

-- Test 4: Power and sqrt
results[#results + 1] = "sqrt=" .. math.sqrt(16)
results[#results + 1] = "pow=" .. (2 ^ 10)

-- Test 5: Modulo
results[#results + 1] = "fmod=" .. math.fmod(10, 3)
if math.modf then
    local int, frac = math.modf(5.7)
    results[#results + 1] = "modf=" .. int
end

-- Test 6: Log and exp
results[#results + 1] = "exp=" .. math.floor(math.exp(0))
results[#results + 1] = "log=" .. math.floor(math.log(math.exp(1)))

-- Test 7: Constants
results[#results + 1] = "pi=" .. math.floor(math.pi * 100)
if math.huge then
    results[#results + 1] = "huge=" .. (math.huge > 10^100 and "big" or "small")
end

print(table.concat(results, ","))
-- Expected: abs=5,floor=3,ceil=4,min=1,max=9,sin0=0,cos0=1000,sqrt=4,pow=1024,fmod=1,modf=5,exp=1,log=1,pi=314,huge=big
