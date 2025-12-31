-- Test: Complex coroutine patterns
local results = {}

-- Test 1: Scheduler simulation
local tasks = {}
local function addTask(fn)
    tasks[#tasks + 1] = coroutine.create(fn)
end
local function runTasks()
    local completed = 0
    while #tasks > 0 do
        for i = #tasks, 1, -1 do
            local co = tasks[i]
            if coroutine.status(co) == "dead" then
                table.remove(tasks, i)
                completed = completed + 1
            else
                coroutine.resume(co)
            end
        end
    end
    return completed
end

local log = {}
addTask(function()
    log[#log + 1] = "a1"
    coroutine.yield()
    log[#log + 1] = "a2"
end)
addTask(function()
    log[#log + 1] = "b1"
    coroutine.yield()
    log[#log + 1] = "b2"
    coroutine.yield()
    log[#log + 1] = "b3"
end)
local completed = runTasks()
results[#results + 1] = "scheduler=" .. completed .. ":" .. #log

-- Test 2: Async/await simulation
local function async(fn)
    return coroutine.create(fn)
end
local function await(co)
    while coroutine.status(co) ~= "dead" do
        local ok, val = coroutine.resume(co)
        if val then
            coroutine.yield(val)
        end
    end
end
local asyncFn = async(function()
    coroutine.yield("step1")
    coroutine.yield("step2")
    return "done"
end)
local steps = {}
while coroutine.status(asyncFn) ~= "dead" do
    local _, v = coroutine.resume(asyncFn)
    if v then steps[#steps + 1] = v end
end
results[#results + 1] = "async=" .. table.concat(steps, ";")

-- Test 3: Generator with state
local function fibonacci(max)
    return coroutine.wrap(function()
        local a, b = 0, 1
        while a <= max do
            coroutine.yield(a)
            a, b = b, a + b
        end
    end)
end
local fibs = {}
for n in fibonacci(20) do
    fibs[#fibs + 1] = n
end
results[#results + 1] = "fib=" .. table.concat(fibs, ";")

-- Test 4: Cooperative multitasking
local function task1()
    local sum = 0
    for i = 1, 3 do
        sum = sum + i
        coroutine.yield()
    end
    return sum
end
local function task2()
    local prod = 1
    for i = 1, 3 do
        prod = prod * i
        coroutine.yield()
    end
    return prod
end
local t1, t2 = coroutine.create(task1), coroutine.create(task2)
local r1, r2
while coroutine.status(t1) ~= "dead" or coroutine.status(t2) ~= "dead" do
    if coroutine.status(t1) ~= "dead" then
        local ok, v = coroutine.resume(t1)
        if v then r1 = v end
    end
    if coroutine.status(t2) ~= "dead" then
        local ok, v = coroutine.resume(t2)
        if v then r2 = v end
    end
end
results[#results + 1] = "coop=" .. r1 .. ":" .. r2

print(table.concat(results, ","))
-- Expected: scheduler=2:5,async=step1;step2;done,fib=0;1;1;2;3;5;8;13,coop=6:6
