-- Test: Producer-consumer patterns with coroutines
local results = {}

-- Test 1: Simple producer-consumer
local function producer()
    local values = {10, 20, 30, 40}
    return coroutine.create(function()
        for _, v in ipairs(values) do
            coroutine.yield(v)
        end
    end)
end

local function consumer(prod)
    local sum = 0
    while coroutine.status(prod) ~= "dead" do
        local ok, val = coroutine.resume(prod)
        if ok and val then
            sum = sum + val
        end
    end
    return sum
end

local prod = producer()
results[#results + 1] = "prodcons=" .. consumer(prod)

-- Test 2: Bidirectional communication
local co2 = coroutine.create(function()
    local total = 0
    while true do
        local cmd, value = coroutine.yield(total)
        if cmd == "add" then
            total = total + value
        elseif cmd == "sub" then
            total = total - value
        elseif cmd == "quit" then
            return total
        end
    end
end)

coroutine.resume(co2)  -- Start
coroutine.resume(co2, "add", 10)
coroutine.resume(co2, "add", 20)
coroutine.resume(co2, "sub", 5)
local _, final = coroutine.resume(co2, "quit", 0)
results[#results + 1] = "bidir=" .. final

-- Test 3: Pipeline of coroutines
local function make_filter(fn)
    return coroutine.wrap(function(source)
        while true do
            local val = source()
            if val == nil then return end
            if fn(val) then
                coroutine.yield(val)
            end
        end
    end)
end

local function make_mapper(fn)
    return coroutine.wrap(function(source)
        while true do
            local val = source()
            if val == nil then return end
            coroutine.yield(fn(val))
        end
    end)
end

-- Test 4: Request-response pattern
local server = coroutine.create(function()
    while true do
        local request = coroutine.yield("ready")
        if request == "stop" then
            return "stopped"
        end
        coroutine.yield("processed: " .. request)
    end
end)

local responses = {}
coroutine.resume(server)  -- Start
local _, r1 = coroutine.resume(server, "request1")
responses[#responses + 1] = r1
local _, r2 = coroutine.resume(server, "request2")
responses[#responses + 1] = r2
coroutine.resume(server)  -- ready
local _, r3 = coroutine.resume(server, "stop")
responses[#responses + 1] = r3
results[#results + 1] = "reqres=" .. (string.find(responses[1], "processed") and "ok" or "fail")

print(table.concat(results, ","))
-- Expected: prodcons=100,bidir=25,reqres=ok
