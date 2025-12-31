-- Test: Closure lifetime and upvalue persistence
local results = {}

-- Test 1: Closure outlives creating scope
local function makeCounter()
    local count = 0
    return function()
        count = count + 1
        return count
    end
end
local counter = makeCounter()
-- makeCounter has returned, but count persists
results[#results + 1] = "outlives=" .. counter() .. ";" .. counter() .. ";" .. counter()

-- Test 2: Multiple closures share upvalue
local function makeShared()
    local shared = 0
    local function inc() shared = shared + 1 end
    local function dec() shared = shared - 1 end
    local function get() return shared end
    return inc, dec, get
end
local inc, dec, get = makeShared()
inc()
inc()
dec()
results[#results + 1] = "shared=" .. get()

-- Test 3: Closure in returned table
local function makeObject()
    local state = 100
    return {
        get = function() return state end,
        set = function(v) state = v end,
        add = function(n) state = state + n end
    }
end
local obj = makeObject()
results[#results + 1] = "obj_get=" .. obj.get()
obj.add(50)
results[#results + 1] = "obj_add=" .. obj.get()

-- Test 4: Independent instances
local c1 = makeCounter()
local c2 = makeCounter()
c1(); c1(); c1()
c2()
results[#results + 1] = "independent=" .. c1() .. ";" .. c2()

-- Test 5: Closure persists through reassignment
local getValue
do
    local secret = "hidden"
    getValue = function()
        return secret
    end
end
-- secret is out of scope, but closure still has access
results[#results + 1] = "persist=" .. getValue()

print(table.concat(results, ","))
-- Expected: outlives=1;2;3,shared=1,obj_get=100,obj_add=150,independent=4;2,persist=hidden
