-- Test: Coroutine execution order determinism
local results = {}

-- Test 1: Simple yield sequence
local co1 = coroutine.create(function()
    coroutine.yield(1)
    coroutine.yield(2)
    coroutine.yield(3)
    return 4
end)
local seq1 = {}
while coroutine.status(co1) ~= "dead" do
    local _, v = coroutine.resume(co1)
    seq1[#seq1 + 1] = v
end
results[#results + 1] = "seq=" .. table.concat(seq1, ":")

-- Test 2: Interleaved coroutines
local order = {}
local function make_coro(name, count)
    return coroutine.create(function()
        for i = 1, count do
            order[#order + 1] = name .. i
            coroutine.yield()
        end
    end)
end
local coA = make_coro("A", 3)
local coB = make_coro("B", 3)
for i = 1, 3 do
    coroutine.resume(coA)
    coroutine.resume(coB)
end
results[#results + 1] = "interleave=" .. table.concat(order, "")

-- Test 3: Producer-consumer determinism
local produced = {}
local consumed = {}
local producer = coroutine.create(function()
    for i = 1, 5 do
        produced[#produced + 1] = i
        coroutine.yield(i)
    end
end)
local consumer = coroutine.create(function()
    while true do
        local val = coroutine.yield()
        if val == nil then return end
        consumed[#consumed + 1] = val
    end
end)
coroutine.resume(consumer)  -- start consumer
for i = 1, 5 do
    local _, val = coroutine.resume(producer)
    coroutine.resume(consumer, val)
end
results[#results + 1] = "prodcons=" .. table.concat(produced) .. ":" .. table.concat(consumed)

-- Test 4: Nested coroutine order
local nested_order = {}
local outer_co = coroutine.create(function()
    nested_order[#nested_order + 1] = "o1"
    local inner = coroutine.create(function()
        nested_order[#nested_order + 1] = "i1"
        coroutine.yield()
        nested_order[#nested_order + 1] = "i2"
    end)
    coroutine.resume(inner)
    nested_order[#nested_order + 1] = "o2"
    coroutine.resume(inner)
    nested_order[#nested_order + 1] = "o3"
end)
coroutine.resume(outer_co)
results[#results + 1] = "nested=" .. table.concat(nested_order, "")

-- Test 5: Value transfer determinism
local co5 = coroutine.create(function(init)
    local val = init
    for i = 1, 3 do
        val = coroutine.yield(val * 2)
    end
    return val * 2
end)
local xfer = {}
local _, v = coroutine.resume(co5, 1)
xfer[1] = v
_, v = coroutine.resume(co5, v)
xfer[2] = v
_, v = coroutine.resume(co5, v)
xfer[3] = v
_, v = coroutine.resume(co5, v)
xfer[4] = v
results[#results + 1] = "xfer=" .. table.concat(xfer, ":")

-- Test 6: Multiple coroutines same function
local function worker()
    local sum = 0
    for i = 1, 3 do
        sum = sum + i
        coroutine.yield(sum)
    end
    return sum
end
local w1 = coroutine.create(worker)
local w2 = coroutine.create(worker)
local r1, r2 = {}, {}
for i = 1, 4 do
    local _, v = coroutine.resume(w1)
    r1[#r1 + 1] = v
    _, v = coroutine.resume(w2)
    r2[#r2 + 1] = v
end
results[#results + 1] = "multi=" .. (table.concat(r1) == table.concat(r2) and "same" or "diff")

-- Test 7: State after yield
local state_before, state_after
local co7 = coroutine.create(function()
    local x = 10
    state_before = x
    coroutine.yield()
    x = 20
    state_after = x
end)
coroutine.resume(co7)
coroutine.resume(co7)
results[#results + 1] = "state=" .. state_before .. ":" .. state_after

-- Test 8: Error in coroutine determinism
local co8 = coroutine.create(function()
    coroutine.yield("before")
    error("test error")
end)
local _, v8a = coroutine.resume(co8)
local ok8, err8 = coroutine.resume(co8)
results[#results + 1] = "error=" .. v8a .. ":" .. tostring(not ok8)

print(table.concat(results, ","))
-- Expected: deterministic across runs
