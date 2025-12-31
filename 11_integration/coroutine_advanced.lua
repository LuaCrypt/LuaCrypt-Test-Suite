-- Test: Advanced coroutine integration patterns
local results = {}

-- Test 1: Coroutine pipeline
local function pipe_stage(name, transform)
    return coroutine.wrap(function(input)
        while input do
            local output = transform(input)
            input = coroutine.yield(output)
        end
    end)
end

local double = pipe_stage("double", function(x) return x * 2 end)
local add_one = pipe_stage("add_one", function(x) return x + 1 end)
local square = pipe_stage("square", function(x) return x * x end)

local function pipeline(stages, initial)
    local value = initial
    for _, stage in ipairs(stages) do
        value = stage(value)
    end
    return value
end

results[#results + 1] = "pipeline=" .. pipeline({double, add_one, square}, 3)

-- Test 2: Cooperative scheduler
local tasks = {}
local task_log = {}

local function spawn(name, fn)
    tasks[#tasks + 1] = {
        name = name,
        co = coroutine.create(fn)
    }
end

local function schedule()
    while #tasks > 0 do
        local task = table.remove(tasks, 1)
        local ok, status = coroutine.resume(task.co)
        if coroutine.status(task.co) ~= "dead" then
            tasks[#tasks + 1] = task
        else
            task_log[#task_log + 1] = task.name .. ":done"
        end
    end
end

spawn("A", function()
    for i = 1, 3 do
        task_log[#task_log + 1] = "A" .. i
        coroutine.yield()
    end
end)

spawn("B", function()
    for i = 1, 2 do
        task_log[#task_log + 1] = "B" .. i
        coroutine.yield()
    end
end)

schedule()
results[#results + 1] = "sched=" .. #task_log

-- Test 3: Channel-like communication
local function createChannel()
    local buffer = {}
    local receivers = {}

    return {
        send = function(value)
            if #receivers > 0 then
                local receiver = table.remove(receivers, 1)
                coroutine.resume(receiver, value)
            else
                buffer[#buffer + 1] = value
            end
        end,
        receive = function()
            if #buffer > 0 then
                return table.remove(buffer, 1)
            else
                receivers[#receivers + 1] = coroutine.running()
                return coroutine.yield()
            end
        end
    }
end

local channel = createChannel()
local channel_log = {}

local producer = coroutine.create(function()
    for i = 1, 3 do
        channel.send(i)
        channel_log[#channel_log + 1] = "sent:" .. i
    end
end)

local consumer = coroutine.create(function()
    for i = 1, 3 do
        local val = channel.receive()
        channel_log[#channel_log + 1] = "recv:" .. val
    end
end)

coroutine.resume(producer)
coroutine.resume(consumer)
results[#results + 1] = "channel=" .. #channel_log

-- Test 4: Generator with state machine
local function statefulGenerator(states, transitions)
    return coroutine.wrap(function()
        local current = states[1]
        while current do
            current = coroutine.yield(current)
            current = transitions[current] and transitions[current]() or nil
        end
    end)
end

local gen = statefulGenerator(
    {"init", "running", "done"},
    {
        init = function() return "running" end,
        running = function() return "done" end,
        done = function() return nil end
    }
)
local state_seq = {}
local state = gen()
while state do
    state_seq[#state_seq + 1] = state
    state = gen(state)
end
results[#results + 1] = "stategen=" .. table.concat(state_seq, ">")

-- Test 5: Coroutine-based iterator factory
local function lazy_map(source, fn)
    return coroutine.wrap(function()
        for item in source do
            coroutine.yield(fn(item))
        end
    end)
end

local function lazy_filter(source, pred)
    return coroutine.wrap(function()
        for item in source do
            if pred(item) then
                coroutine.yield(item)
            end
        end
    end)
end

local function from_table(t)
    return coroutine.wrap(function()
        for _, v in ipairs(t) do
            coroutine.yield(v)
        end
    end)
end

local source = from_table({1, 2, 3, 4, 5, 6, 7, 8, 9, 10})
local doubled = lazy_map(source, function(x) return x * 2 end)
local evens = lazy_filter(doubled, function(x) return x % 4 == 0 end)
local lazy_result = {}
for v in evens do
    lazy_result[#lazy_result + 1] = v
end
results[#results + 1] = "lazy=" .. table.concat(lazy_result, ":")

-- Test 6: Coroutine pool
local function createPool(size)
    local workers = {}
    local available = {}

    for i = 1, size do
        local worker = {
            id = i,
            co = nil,
            task = nil
        }
        workers[i] = worker
        available[#available + 1] = worker
    end

    return {
        submit = function(task)
            if #available > 0 then
                local worker = table.remove(available, 1)
                worker.co = coroutine.create(task)
                return worker.id
            end
            return nil
        end,
        run = function()
            local completed = 0
            for _, w in ipairs(workers) do
                if w.co and coroutine.status(w.co) ~= "dead" then
                    coroutine.resume(w.co)
                    if coroutine.status(w.co) == "dead" then
                        available[#available + 1] = w
                        w.co = nil
                        completed = completed + 1
                    end
                end
            end
            return completed
        end,
        available = function()
            return #available
        end
    }
end

local pool = createPool(3)
pool.submit(function() coroutine.yield() end)
pool.submit(function() coroutine.yield() end)
local before = pool.available()
pool.run()
pool.run()
local after = pool.available()
results[#results + 1] = "pool=" .. before .. ">" .. after

-- Test 7: Async/await pattern
local pending = {}

local function async_op(value, delay_sim)
    return function(callback)
        pending[#pending + 1] = {
            value = value,
            callback = callback,
            ready = delay_sim or 0
        }
    end
end

local function run_pending()
    local completed = {}
    for i, p in ipairs(pending) do
        if p.ready <= 0 then
            p.callback(p.value)
            completed[#completed + 1] = i
        else
            p.ready = p.ready - 1
        end
    end
    for i = #completed, 1, -1 do
        table.remove(pending, completed[i])
    end
end

local async_results = {}
async_op(10, 0)(function(v) async_results[#async_results + 1] = v end)
async_op(20, 1)(function(v) async_results[#async_results + 1] = v end)
run_pending()
run_pending()
results[#results + 1] = "async=" .. table.concat(async_results, ":")

print(table.concat(results, ","))
-- Expected: pipeline=49,sched=7,channel=6,stategen=init>running>done,lazy=4:8:12:16:20,pool=1>3,async=10:20
