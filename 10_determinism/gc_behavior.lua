-- Test: GC-related determinism
local results = {}

-- Test 1: Weak table values collected
local weak_v = setmetatable({}, {__mode = "v"})
local function test_weak_v()
    local obj = {id = 1}
    weak_v.key = obj
    return weak_v.key ~= nil
end
local before = test_weak_v()
collectgarbage("collect")
collectgarbage("collect")
local after = weak_v.key ~= nil
results[#results + 1] = "weak_v=" .. tostring(before) .. ":" .. tostring(after)

-- Test 2: Weak table keys collected
local weak_k = setmetatable({}, {__mode = "k"})
local function test_weak_k()
    local key = {}
    weak_k[key] = "value"
    return next(weak_k) ~= nil
end
local before_k = test_weak_k()
collectgarbage("collect")
collectgarbage("collect")
local after_k = next(weak_k) ~= nil
results[#results + 1] = "weak_k=" .. tostring(before_k) .. ":" .. tostring(after_k)

-- Test 3: __gc order (LIFO for objects in same cycle)
local gc_order = {}
for i = 1, 3 do
    local idx = i
    setmetatable({}, {
        __gc = function()
            gc_order[#gc_order + 1] = idx
        end
    })
end
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "gc_order=" .. table.concat(gc_order, ":")

-- Test 4: Resurrection
local resurrected = nil
local res_mt = {
    __gc = function(self)
        resurrected = self
    end
}
local function create_resurrect()
    return setmetatable({val = 42}, res_mt)
end
create_resurrect()
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "resurrect=" .. (resurrected and resurrected.val or "nil")

-- Test 5: Finalizer chain
local chain_log = {}
local function make_chain(id, next_obj)
    return setmetatable({id = id, next = next_obj}, {
        __gc = function(self)
            chain_log[#chain_log + 1] = self.id
        end
    })
end
local c3 = make_chain(3, nil)
local c2 = make_chain(2, c3)
local c1 = make_chain(1, c2)
c1, c2, c3 = nil, nil, nil
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "chain=" .. #chain_log

-- Test 6: Memory after collection
local before_mem = collectgarbage("count")
local big_tables = {}
for i = 1, 100 do
    big_tables[i] = {}
    for j = 1, 100 do
        big_tables[i][j] = j
    end
end
local during_mem = collectgarbage("count")
big_tables = nil
collectgarbage("collect")
collectgarbage("collect")
local after_mem = collectgarbage("count")
results[#results + 1] = "mem=" .. (during_mem > before_mem and after_mem < during_mem and "correct" or "unexpected")

-- Test 7: Closure upvalue keeps object alive
local kept_by_closure = nil
local function closure_keeper()
    local obj = {data = "kept"}
    kept_by_closure = function() return obj end
end
closure_keeper()
collectgarbage("collect")
local closure_result = kept_by_closure()
results[#results + 1] = "closure_keep=" .. (closure_result and closure_result.data or "nil")

-- Test 8: Ephemeron behavior (weak key + referenced value)
local ephemeron = setmetatable({}, {__mode = "k"})
local function test_ephemeron()
    local key = {}
    local value = {ref_to_key = key}  -- value references key
    ephemeron[key] = value
end
test_ephemeron()
collectgarbage("collect")
collectgarbage("collect")
local eph_empty = next(ephemeron) == nil
results[#results + 1] = "ephemeron=" .. tostring(eph_empty)

print(table.concat(results, ","))
-- Expected: deterministic behavior (though timing may vary)
