-- Test: Function factories (returning closures)
local results = {}

-- Test 1: Simple counter factory
local function makeCounter()
    local count = 0
    return function()
        count = count + 1
        return count
    end
end
local c1 = makeCounter()
local c2 = makeCounter()
results[#results + 1] = "counter=" .. c1() .. ";" .. c1() .. ";" .. c2() .. ";" .. c1()

-- Test 2: Configurable factory
local function makeMultiplier(factor)
    return function(x)
        return x * factor
    end
end
local double = makeMultiplier(2)
local triple = makeMultiplier(3)
results[#results + 1] = "mult=" .. double(5) .. ";" .. triple(5)

-- Test 3: Factory returning multiple functions
local function makeGetSet(initial)
    local value = initial
    local function get()
        return value
    end
    local function set(v)
        value = v
    end
    return get, set
end
local get1, set1 = makeGetSet(100)
results[#results + 1] = "getset1=" .. get1()
set1(200)
results[#results + 1] = "getset2=" .. get1()

-- Test 4: Factory with accumulator
local function makeAccumulator()
    local total = 0
    return function(n)
        total = total + n
        return total
    end
end
local acc = makeAccumulator()
results[#results + 1] = "acc=" .. acc(10) .. ";" .. acc(20) .. ";" .. acc(5)

-- Test 5: Nested factory
local function makeOuterFactory()
    local outer_count = 0
    return function()
        outer_count = outer_count + 1
        local inner_count = 0
        return function()
            inner_count = inner_count + 1
            return outer_count .. ":" .. inner_count
        end
    end
end
local outerF = makeOuterFactory()
local inner1 = outerF()
local inner2 = outerF()
results[#results + 1] = "nested_factory=" .. inner1() .. ";" .. inner1() .. ";" .. inner2()

print(table.concat(results, ","))
-- Expected: counter=1;2;1;3,mult=10;15,getset1=100,getset2=200,acc=10;30;35,nested_factory=1:1;1:2;2:1
