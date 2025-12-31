-- Test: Nested closures (multiple upvalue layers)
local results = {}

-- Test 1: Two levels of closure
local a = 10
local function level1()
    local b = 20
    local function level2()
        return a + b
    end
    return level2()
end
results[#results + 1] = "two_level=" .. level1()

-- Test 2: Three levels deep
local x = 1
local function outer()
    local y = 2
    local function middle()
        local z = 3
        local function inner()
            return x + y + z
        end
        return inner()
    end
    return middle()
end
results[#results + 1] = "three_level=" .. outer()

-- Test 3: Modify upvalue from deep nesting
local counter = 0
local function makeAdder()
    local function add(n)
        local function doAdd()
            counter = counter + n
        end
        doAdd()
    end
    return add
end
local adder = makeAdder()
adder(5)
adder(10)
results[#results + 1] = "deep_mod=" .. counter

-- Test 4: Each level has its own upvalue
local function factory()
    local outer_val = 100
    local function makeGetter()
        local inner_val = 200
        local function getter()
            return outer_val + inner_val
        end
        return getter
    end
    return makeGetter()
end
local getter = factory()
results[#results + 1] = "multi_upval=" .. getter()

-- Test 5: Closure returning closure
local function createCounter()
    local count = 0
    return function()
        return function()
            count = count + 1
            return count
        end
    end
end
local getInc = createCounter()
local inc = getInc()
results[#results + 1] = "ret_closure=" .. inc() .. ";" .. inc() .. ";" .. inc()

print(table.concat(results, ","))
-- Expected: two_level=30,three_level=6,deep_mod=15,multi_upval=300,ret_closure=1;2;3
