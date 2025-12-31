-- Test: Basic upvalue (closure) behavior
local results = {}

-- Test 1: Simple upvalue read
local x = 10
local function readX()
    return x
end
results[#results + 1] = "read=" .. readX()

-- Test 2: Upvalue write
local y = 1
local function incY()
    y = y + 1
end
incY()
incY()
results[#results + 1] = "write=" .. y

-- Test 3: Multiple upvalues
local a, b = 10, 20
local function sum()
    return a + b
end
results[#results + 1] = "multi=" .. sum()

-- Test 4: Upvalue modification reflects in closure
local z = 5
local function getZ()
    return z
end
results[#results + 1] = "before=" .. getZ()
z = 50
results[#results + 1] = "after=" .. getZ()

-- Test 5: Closure captures current value
local n = 100
local function capture()
    return n
end
n = 200
results[#results + 1] = "capture=" .. capture()  -- Returns 200 (reference, not copy)

-- Test 6: Independent closures share upvalue
local counter = 0
local function inc()
    counter = counter + 1
end
local function get()
    return counter
end
inc()
inc()
results[#results + 1] = "shared=" .. get()

print(table.concat(results, ","))
-- Expected: read=10,write=3,multi=30,before=5,after=50,capture=200,shared=2
