-- Test: Coroutine value transfer patterns
local results = {}

-- Test 1: Bidirectional transfer
local co1 = coroutine.create(function(x)
    local a = coroutine.yield(x * 2)
    local b = coroutine.yield(a * 2)
    return b * 2
end)
local _, v1a = coroutine.resume(co1, 5)
local _, v1b = coroutine.resume(co1, v1a)
local _, v1c = coroutine.resume(co1, v1b)
results[#results + 1] = "bidir=" .. v1a .. ":" .. v1b .. ":" .. v1c

-- Test 2: Nil transfer
local co2 = coroutine.create(function(x)
    local a = coroutine.yield(x)
    return a == nil and "nil_received" or "not_nil"
end)
coroutine.resume(co2, "start")
local _, v2 = coroutine.resume(co2, nil)
results[#results + 1] = "nil_xfer=" .. v2

-- Test 3: Multiple value transfer
local co3 = coroutine.create(function(a, b, c)
    local x, y, z = coroutine.yield(a + b + c, a * b * c)
    return x, y, z
end)
local _, s3, p3 = coroutine.resume(co3, 2, 3, 4)
local _, r3a, r3b, r3c = coroutine.resume(co3, 10, 20, 30)
results[#results + 1] = "multi_out=" .. s3 .. ":" .. p3
results[#results + 1] = "multi_in=" .. r3a .. ":" .. r3b .. ":" .. r3c

-- Test 4: Table transfer
local co4 = coroutine.create(function(t)
    t.modified = true
    local t2 = coroutine.yield(t)
    t2.also_modified = true
    return t2
end)
local input = {original = true}
local _, out1 = coroutine.resume(co4, input)
local _, out2 = coroutine.resume(co4, out1)
results[#results + 1] = "tbl_mod=" .. tostring(out2.modified)
results[#results + 1] = "tbl_also=" .. tostring(out2.also_modified)
results[#results + 1] = "tbl_same=" .. tostring(input == out2)

-- Test 5: Function transfer
local co5 = coroutine.create(function(f)
    local g = coroutine.yield(function(x) return f(x) * 2 end)
    return g(5)
end)
local _, wrapper = coroutine.resume(co5, function(x) return x + 1 end)
local _, result5 = coroutine.resume(co5, function(x) return x * 3 end)
results[#results + 1] = "func_wrap=" .. wrapper(3)
results[#results + 1] = "func_exec=" .. result5

print(table.concat(results, ","))
-- Expected: bidir=10:20:40,nil_xfer=nil_received,multi_out=9:24,multi_in=10:20:30,tbl_mod=true,tbl_also=true,tbl_same=true,func_wrap=8,func_exec=15
