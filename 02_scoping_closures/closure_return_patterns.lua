-- Test: Various patterns for returning closures
local results = {}

-- Test 1: Return closure directly
local function direct()
    local x = 10
    return function() return x end
end
results[#results + 1] = "direct=" .. direct()()

-- Test 2: Return closure in table
local function inTable()
    local x = 20
    return {get = function() return x end}
end
results[#results + 1] = "table=" .. inTable().get()

-- Test 3: Return multiple closures
local function multiple()
    local x = 0
    return function() x = x + 1; return x end,
           function() x = x - 1; return x end,
           function() return x end
end
local inc, dec, get = multiple()
inc(); inc(); dec()
results[#results + 1] = "multiple=" .. get()

-- Test 4: Conditional closure return
local function conditional(flag)
    local x = 100
    if flag then
        return function() return x * 2 end
    else
        return function() return x / 2 end
    end
end
results[#results + 1] = "cond=" .. conditional(true)() .. ";" .. conditional(false)()

-- Test 5: Return closure from loop
local function fromLoop()
    local funcs = {}
    for i = 1, 3 do
        funcs[i] = function() return i end
    end
    return funcs
end
local loopFuncs = fromLoop()
results[#results + 1] = "loop=" .. loopFuncs[1]() .. ";" .. loopFuncs[2]() .. ";" .. loopFuncs[3]()

-- Test 6: Return closure that returns closure
local function nested()
    local x = 5
    return function()
        return function()
            return x
        end
    end
end
results[#results + 1] = "nested=" .. nested()()()

print(table.concat(results, ","))
-- Expected: direct=10,table=20,multiple=1,cond=200;50,loop=1;2;3,nested=5
