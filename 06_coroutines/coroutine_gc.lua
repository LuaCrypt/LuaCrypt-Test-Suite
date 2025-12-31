-- Test: Coroutine garbage collection
local results = {}

-- Test 1: Dead coroutine can be collected
local weak_ref = setmetatable({}, {__mode = "v"})
do
    local co = coroutine.create(function() return 1 end)
    coroutine.resume(co)  -- Complete it
    weak_ref.co = co
end
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "dead_gc=" .. tostring(weak_ref.co == nil)

-- Test 2: Suspended coroutine with reference kept
local kept_co = coroutine.create(function()
    coroutine.yield()
end)
coroutine.resume(kept_co)  -- Suspend it
collectgarbage("collect")
results[#results + 1] = "kept=" .. coroutine.status(kept_co)

-- Test 3: Coroutine holds reference to local
local function testLocal()
    local big_table = {data = string.rep("x", 100)}
    return coroutine.create(function()
        return big_table.data:len()
    end)
end
local co3 = testLocal()
collectgarbage("collect")
local ok3, len = coroutine.resume(co3)
results[#results + 1] = "local_ref=" .. len

-- Test 4: Chain of references
local co4_outer = coroutine.create(function()
    local co4_inner = coroutine.create(function()
        return "inner_value"
    end)
    local ok, val = coroutine.resume(co4_inner)
    return val
end)
collectgarbage("collect")
local ok4, val4 = coroutine.resume(co4_outer)
results[#results + 1] = "chain=" .. val4

-- Test 5: Coroutine in table
local coro_table = {}
for i = 1, 5 do
    coro_table[i] = coroutine.create(function()
        return i
    end)
end
-- Remove some
coro_table[2] = nil
coro_table[4] = nil
collectgarbage("collect")
local count = 0
for k, v in pairs(coro_table) do
    count = count + 1
end
results[#results + 1] = "table_gc=" .. count

print(table.concat(results, ","))
-- Expected: dead_gc=true,kept=suspended,local_ref=100,chain=inner_value,table_gc=3
