-- Test: Closures and garbage collection interaction
local results = {}

-- Test 1: Closure keeps reference alive
local function makeKeeper()
    local data = {value = "kept"}
    return function()
        return data.value
    end
end
local keeper = makeKeeper()
collectgarbage("collect")
results[#results + 1] = "kept_alive=" .. keeper()

-- Test 2: Independent closures with same structure
local function makePair()
    local a = {x = 1}
    local b = {x = 2}
    return function() return a.x end, function() return b.x end
end
local getA, getB = makePair()
collectgarbage("collect")
results[#results + 1] = "pair=" .. getA() .. ";" .. getB()

-- Test 3: Closure chain keeps all upvalues
local function chain()
    local v1 = "a"
    local function f1()
        local v2 = "b"
        local function f2()
            return v1 .. v2
        end
        return f2
    end
    return f1()
end
local chained = chain()
collectgarbage("collect")
results[#results + 1] = "chained=" .. chained()

-- Test 4: Closure in table keeps data
local t = {}
do
    local secret = "hidden"
    t.reveal = function()
        return secret
    end
end
collectgarbage("collect")
results[#results + 1] = "table_closure=" .. t.reveal()

-- Test 5: Multiple closures sharing upvalue
local function makeShared()
    local count = 0
    return {
        inc = function() count = count + 1 end,
        dec = function() count = count - 1 end,
        get = function() return count end
    }
end
local shared = makeShared()
shared.inc(); shared.inc(); shared.dec()
collectgarbage("collect")
results[#results + 1] = "shared_gc=" .. shared.get()

print(table.concat(results, ","))
-- Expected: kept_alive=kept,pair=1;2,chained=ab,table_closure=hidden,shared_gc=1
