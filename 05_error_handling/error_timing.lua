-- Test: Error timing (eager vs lazy evaluation)
local results = {}

-- Test 1: Eager error (immediate)
local eager_evaluated = false
local function eagerError()
    eager_evaluated = true
    error("eager")
end

local function useEager()
    return pcall(eagerError)
end
useEager()
results[#results + 1] = "eager=" .. tostring(eager_evaluated)

-- Test 2: Lazy error (deferred in closure)
local lazy_evaluated = false
local function createLazy()
    return function()
        lazy_evaluated = true
        error("lazy")
    end
end
local lazyFn = createLazy()
results[#results + 1] = "lazy_before=" .. tostring(lazy_evaluated)
pcall(lazyFn)
results[#results + 1] = "lazy_after=" .. tostring(lazy_evaluated)

-- Test 3: Error in condition (short-circuit)
local checked = {false, false, false}
local function check(n)
    checked[n] = true
    if n == 2 then error("check " .. n) end
    return true
end
local ok3 = pcall(function()
    return check(1) and check(2) and check(3)
end)
results[#results + 1] = "short_circuit=" .. tostring(checked[1]) .. ":" .. tostring(checked[2]) .. ":" .. tostring(checked[3])

-- Test 4: Error in default value pattern
local function getDefault()
    error("default error")
end
local function safeDefault(val)
    local ok, result = pcall(function()
        return val or getDefault()  -- getDefault only called if val is nil/false
    end)
    return ok and result or "failed"
end
results[#results + 1] = "default=" .. safeDefault(42) .. ":" .. safeDefault(nil)

-- Test 5: Error order in multiple assignment
local order = {}
local function f1()
    order[#order + 1] = "f1"
    return 1
end
local function f2()
    order[#order + 1] = "f2"
    error("f2 error")
end
local function f3()
    order[#order + 1] = "f3"
    return 3
end
local ok5 = pcall(function()
    local a, b, c = f1(), f2(), f3()
end)
results[#results + 1] = "order=" .. table.concat(order, ";")

print(table.concat(results, ","))
-- Expected: eager=true,lazy_before=false,lazy_after=true,short_circuit=true:true:false,default=42:failed,order=f1;f2
