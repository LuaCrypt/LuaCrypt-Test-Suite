-- Test: Nested coroutines
local results = {}

-- Test 1: Coroutine creating coroutine
local co1 = coroutine.create(function()
    local inner = coroutine.create(function()
        return "inner_result"
    end)
    local ok, result = coroutine.resume(inner)
    return "outer_got:" .. result
end)
local ok1, res1 = coroutine.resume(co1)
results[#results + 1] = "nested_create=" .. res1

-- Test 2: Yield from inner doesn't affect outer
local log = {}
local co2_inner
local co2 = coroutine.create(function()
    log[#log + 1] = "outer_start"
    co2_inner = coroutine.create(function()
        log[#log + 1] = "inner_yield"
        coroutine.yield("from_inner")
        log[#log + 1] = "inner_after"
        return "inner_done"
    end)
    local ok, val = coroutine.resume(co2_inner)
    log[#log + 1] = "outer_got:" .. val
    return "outer_done"
end)
coroutine.resume(co2)
results[#results + 1] = "yield_scope=" .. table.concat(log, ";")

-- Test 3: Deep nesting
local function createNested(depth)
    if depth <= 0 then
        return coroutine.create(function()
            return "bottom"
        end)
    end
    return coroutine.create(function()
        local inner = createNested(depth - 1)
        local ok, result = coroutine.resume(inner)
        return "level" .. depth .. ":" .. result
    end)
end
local deep = createNested(3)
local okd, resd = coroutine.resume(deep)
results[#results + 1] = "deep=" .. resd

-- Test 4: Multiple coroutines in parallel
local co_a = coroutine.create(function()
    coroutine.yield("a1")
    return "a2"
end)
local co_b = coroutine.create(function()
    coroutine.yield("b1")
    return "b2"
end)
local seq = {}
local _, v = coroutine.resume(co_a)
seq[#seq + 1] = v
_, v = coroutine.resume(co_b)
seq[#seq + 1] = v
_, v = coroutine.resume(co_a)
seq[#seq + 1] = v
_, v = coroutine.resume(co_b)
seq[#seq + 1] = v
results[#results + 1] = "parallel=" .. table.concat(seq, ";")

print(table.concat(results, ","))
-- Expected: nested_create=outer_got:inner_result,yield_scope=outer_start;inner_yield;outer_got:from_inner,deep=level3:level2:level1:bottom,parallel=a1;b1;a2;b2
