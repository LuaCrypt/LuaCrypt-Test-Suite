-- Test: Coroutine scheduler patterns
local results = {}

-- Test 1: Simple round-robin scheduler
local tasks = {}
local function spawn(fn)
    tasks[#tasks + 1] = coroutine.create(fn)
end
local function run_all()
    local completed = 0
    while completed < #tasks do
        for i, co in ipairs(tasks) do
            if coroutine.status(co) ~= "dead" then
                local ok, err = coroutine.resume(co)
                if not ok then
                    error(err)
                end
                if coroutine.status(co) == "dead" then
                    completed = completed + 1
                end
            end
        end
    end
end

local order = {}
spawn(function()
    for i = 1, 3 do
        order[#order + 1] = "A" .. i
        coroutine.yield()
    end
end)
spawn(function()
    for i = 1, 3 do
        order[#order + 1] = "B" .. i
        coroutine.yield()
    end
end)
run_all()
results[#results + 1] = "rr=" .. table.concat(order, "")

-- Test 2: Priority scheduler
local pq = {}
local function spawn_prio(fn, priority)
    pq[#pq + 1] = {co = coroutine.create(fn), prio = priority}
end

local prio_order = {}
spawn_prio(function()
    for i = 1, 2 do
        prio_order[#prio_order + 1] = "L" .. i
        coroutine.yield()
    end
end, 1)
spawn_prio(function()
    for i = 1, 2 do
        prio_order[#prio_order + 1] = "H" .. i
        coroutine.yield()
    end
end, 10)

-- Run higher priority first
table.sort(pq, function(a, b) return a.prio > b.prio end)
for round = 1, 3 do
    for _, task in ipairs(pq) do
        if coroutine.status(task.co) ~= "dead" then
            coroutine.resume(task.co)
        end
    end
end
results[#results + 1] = "prio=" .. table.concat(prio_order, "")

-- Test 3: Cooperative multitasking with state
local workers = {}
local shared_state = {counter = 0}

for i = 1, 3 do
    workers[i] = coroutine.create(function()
        for j = 1, 3 do
            shared_state.counter = shared_state.counter + 1
            coroutine.yield()
        end
    end)
end

for round = 1, 3 do
    for _, w in ipairs(workers) do
        if coroutine.status(w) ~= "dead" then
            coroutine.resume(w)
        end
    end
end
results[#results + 1] = "shared=" .. shared_state.counter

-- Test 4: Event-driven simulation
local events = {}
local event_log = {}

local function emit(name)
    events[#events + 1] = name
end

local listener1 = coroutine.create(function()
    while true do
        local event = coroutine.yield()
        if event then
            event_log[#event_log + 1] = "L1:" .. event
        end
    end
end)

local listener2 = coroutine.create(function()
    while true do
        local event = coroutine.yield()
        if event then
            event_log[#event_log + 1] = "L2:" .. event
        end
    end
end)

-- Initialize listeners
coroutine.resume(listener1)
coroutine.resume(listener2)

-- Dispatch events
for _, e in ipairs({"start", "process", "end"}) do
    coroutine.resume(listener1, e)
    coroutine.resume(listener2, e)
end
results[#results + 1] = "events=" .. #event_log

-- Test 5: Pipeline pattern
local function stage(name, next_stage)
    return coroutine.create(function(input)
        while input do
            local output = input .. ">" .. name
            if next_stage and coroutine.status(next_stage) ~= "dead" then
                coroutine.resume(next_stage, output)
            end
            input = coroutine.yield(output)
        end
    end)
end

local final_output = {}
local stage3 = coroutine.create(function(input)
    while input do
        final_output[#final_output + 1] = input
        input = coroutine.yield()
    end
end)
coroutine.resume(stage3)

local stage2 = stage("B", stage3)
coroutine.resume(stage2)

local stage1 = stage("A", stage2)
coroutine.resume(stage1)

coroutine.resume(stage1, "1")
coroutine.resume(stage1, "2")
results[#results + 1] = "pipe=" .. #final_output

print(table.concat(results, ","))
-- Expected: rr=A1B1A2B2A3B3,prio=H1L1H2L2,shared=9,events=6,pipe=2
