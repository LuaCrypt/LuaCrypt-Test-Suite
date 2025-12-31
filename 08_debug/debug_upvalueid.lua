-- Test: debug.upvalueid and upvaluejoin (Lua 5.2+)
local results = {}

-- Skip if not available
if not debug.upvalueid then
    print("upvalueid=skip")
    return
end

-- Test 1: Get upvalue ID
local x = 10
local function f1()
    return x
end
local id1 = debug.upvalueid(f1, 1)
results[#results + 1] = "id=" .. (id1 and "has" or "nil")

-- Test 2: Same upvalue has same ID
local function f2()
    return x
end
local id2 = debug.upvalueid(f2, 1)
results[#results + 1] = "same=" .. tostring(id1 == id2)

-- Test 3: Different upvalues have different IDs
local y = 20
local function f3()
    return y
end
local id3 = debug.upvalueid(f3, 1)
results[#results + 1] = "diff=" .. tostring(id1 ~= id3)

-- Test 4: Upvaluejoin
local a = 100
local b = 200
local function fa()
    return a
end
local function fb()
    return b
end
-- Join fb's upvalue to fa's
debug.upvaluejoin(fb, 1, fa, 1)
results[#results + 1] = "join=" .. fb()

-- Test 5: Modification after join
a = 300
results[#results + 1] = "joined_mod=" .. fb()

-- Test 6: Both functions share
local function fc()
    return a
end
debug.upvaluejoin(fc, 1, fa, 1)
a = 400
results[#results + 1] = "shared=" .. (fa() == fb() and fb() == fc() and "yes" or "no")

-- Test 7: ID after join
local id_fa = debug.upvalueid(fa, 1)
local id_fb = debug.upvalueid(fb, 1)
results[#results + 1] = "id_join=" .. tostring(id_fa == id_fb)

-- Test 8: Multiple upvalues
local m, n = 1, 2
local function multi()
    return m + n
end
local id_m = debug.upvalueid(multi, 1)
local id_n = debug.upvalueid(multi, 2)
results[#results + 1] = "multi_diff=" .. tostring(id_m ~= id_n)

-- Test 9: Closure factory upvalues
local function make_closure()
    local private = 0
    return function()
        private = private + 1
        return private
    end
end
local c1 = make_closure()
local c2 = make_closure()
local id_c1 = debug.upvalueid(c1, 1)
local id_c2 = debug.upvalueid(c2, 1)
results[#results + 1] = "factory=" .. tostring(id_c1 ~= id_c2)

-- Test 10: Join closures from factory
debug.upvaluejoin(c2, 1, c1, 1)
c1()
c1()
results[#results + 1] = "factory_join=" .. c2()

print(table.concat(results, ","))
-- Expected: id=has,same=true,diff=true,join=100,joined_mod=300,shared=yes,id_join=true,multi_diff=true,factory=true,factory_join=3
