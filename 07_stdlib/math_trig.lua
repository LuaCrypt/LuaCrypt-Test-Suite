-- Test: Trigonometric math functions
local results = {}

-- Helper for approximate comparison
local function approx(a, b, eps)
    eps = eps or 0.0001
    return math.abs(a - b) < eps
end

-- Test 1: sin values
results[#results + 1] = "sin0=" .. (approx(math.sin(0), 0) and "ok" or "fail")
results[#results + 1] = "sin_pi2=" .. (approx(math.sin(math.pi/2), 1) and "ok" or "fail")
results[#results + 1] = "sin_pi=" .. (approx(math.sin(math.pi), 0) and "ok" or "fail")

-- Test 2: cos values
results[#results + 1] = "cos0=" .. (approx(math.cos(0), 1) and "ok" or "fail")
results[#results + 1] = "cos_pi2=" .. (approx(math.cos(math.pi/2), 0) and "ok" or "fail")
results[#results + 1] = "cos_pi=" .. (approx(math.cos(math.pi), -1) and "ok" or "fail")

-- Test 3: tan values
results[#results + 1] = "tan0=" .. (approx(math.tan(0), 0) and "ok" or "fail")
results[#results + 1] = "tan_pi4=" .. (approx(math.tan(math.pi/4), 1) and "ok" or "fail")

-- Test 4: Inverse trig
results[#results + 1] = "asin=" .. (approx(math.asin(1), math.pi/2) and "ok" or "fail")
results[#results + 1] = "acos=" .. (approx(math.acos(0), math.pi/2) and "ok" or "fail")
results[#results + 1] = "atan=" .. (approx(math.atan(1), math.pi/4) and "ok" or "fail")

-- Test 5: atan2 (if available)
if math.atan2 then
    results[#results + 1] = "atan2=" .. (approx(math.atan2(1, 1), math.pi/4) and "ok" or "fail")
else
    -- Lua 5.3+ uses atan with two args
    results[#results + 1] = "atan2=" .. (approx(math.atan(1, 1), math.pi/4) and "ok" or "fail")
end

-- Test 6: Hyperbolic (if available)
if math.sinh then
    results[#results + 1] = "sinh=" .. (approx(math.sinh(0), 0) and "ok" or "fail")
    results[#results + 1] = "cosh=" .. (approx(math.cosh(0), 1) and "ok" or "fail")
    results[#results + 1] = "tanh=" .. (approx(math.tanh(0), 0) and "ok" or "fail")
end

-- Test 7: Radians/degrees
results[#results + 1] = "rad=" .. (approx(math.rad(180), math.pi) and "ok" or "fail")
results[#results + 1] = "deg=" .. (approx(math.deg(math.pi), 180) and "ok" or "fail")

-- Test 8: Identity: sin^2 + cos^2 = 1
local angle = 1.234
local identity = math.sin(angle)^2 + math.cos(angle)^2
results[#results + 1] = "identity=" .. (approx(identity, 1) and "ok" or "fail")

-- Test 9: Periodic property
local period_check = approx(math.sin(0), math.sin(2 * math.pi))
results[#results + 1] = "periodic=" .. (period_check and "ok" or "fail")

print(table.concat(results, ","))
-- Expected: sin0=ok,sin_pi2=ok,sin_pi=ok,cos0=ok,cos_pi2=ok,cos_pi=ok,tan0=ok,tan_pi4=ok,asin=ok,acos=ok,atan=ok,atan2=ok,sinh=ok,cosh=ok,tanh=ok,rad=ok,deg=ok,identity=ok,periodic=ok
