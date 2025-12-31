-- Test: Promise/Future pattern simulation
local results = {}

-- Test 1: Basic promise
local function createPromise(executor)
    local state = "pending"
    local value = nil
    local callbacks = {}

    local function resolve(val)
        if state == "pending" then
            state = "resolved"
            value = val
            for _, cb in ipairs(callbacks) do
                cb(value)
            end
        end
    end

    local function reject(err)
        if state == "pending" then
            state = "rejected"
            value = err
        end
    end

    executor(resolve, reject)

    return {
        andThen = function(cb)
            if state == "resolved" then
                cb(value)
            else
                callbacks[#callbacks + 1] = cb
            end
        end,
        getState = function() return state end,
        getValue = function() return value end
    }
end

local p1_result = nil
local p1 = createPromise(function(resolve, reject)
    resolve(42)
end)
p1.andThen(function(v) p1_result = v end)
results[#results + 1] = "promise=" .. p1.getState() .. ":" .. p1_result

-- Test 2: Chained promises (simulated)
local chain_log = {}
local p2 = createPromise(function(resolve, reject)
    resolve(1)
end)
p2.andThen(function(v)
    chain_log[#chain_log + 1] = v
    local p3 = createPromise(function(resolve, reject)
        resolve(v + 1)
    end)
    p3.andThen(function(v2)
        chain_log[#chain_log + 1] = v2
    end)
end)
results[#results + 1] = "chain=" .. table.concat(chain_log, ">")

-- Test 3: Deferred pattern
local function createDeferred()
    local promise
    local resolveFunc

    promise = createPromise(function(resolve, reject)
        resolveFunc = resolve
    end)

    return {
        promise = promise,
        resolve = resolveFunc
    }
end

local deferred = createDeferred()
local defer_result = nil
deferred.promise.andThen(function(v) defer_result = v end)
deferred.resolve(100)
results[#results + 1] = "deferred=" .. defer_result

-- Test 4: Promise.all simulation
local function promiseAll(promises)
    local results = {}
    local resolved = 0
    local total = #promises
    local allResolved = false
    local allCallbacks = {}

    for i, p in ipairs(promises) do
        p.andThen(function(v)
            results[i] = v
            resolved = resolved + 1
            if resolved == total and not allResolved then
                allResolved = true
                for _, cb in ipairs(allCallbacks) do
                    cb(results)
                end
            end
        end)
    end

    return {
        andThen = function(cb)
            if allResolved then
                cb(results)
            else
                allCallbacks[#allCallbacks + 1] = cb
            end
        end
    }
end

local all_result = nil
local promises = {
    createPromise(function(r) r(1) end),
    createPromise(function(r) r(2) end),
    createPromise(function(r) r(3) end)
}
promiseAll(promises).andThen(function(vals)
    all_result = table.concat(vals, "+")
end)
results[#results + 1] = "all=" .. all_result

-- Test 5: Race pattern
local function promiseRace(promises)
    local winner = nil
    local callbacks = {}

    for _, p in ipairs(promises) do
        p.andThen(function(v)
            if not winner then
                winner = v
                for _, cb in ipairs(callbacks) do
                    cb(v)
                end
            end
        end)
    end

    return {
        andThen = function(cb)
            if winner then
                cb(winner)
            else
                callbacks[#callbacks + 1] = cb
            end
        end
    }
end

local race_result = nil
promiseRace({
    createPromise(function(r) r("first") end),
    createPromise(function(r) r("second") end)
}).andThen(function(v) race_result = v end)
results[#results + 1] = "race=" .. race_result

-- Test 6: Async/await simulation with coroutines
local function async(fn)
    return function(...)
        local co = coroutine.create(fn)
        local function step(...)
            local ok, result = coroutine.resume(co, ...)
            if coroutine.status(co) == "dead" then
                return result
            end
        end
        return step(...)
    end
end

local function await(promise)
    -- In real async, this would suspend
    return promise.getValue()
end

local async_result = nil
local asyncFn = async(function()
    local p = createPromise(function(r) r(50) end)
    async_result = await(p)
    return async_result
end)
asyncFn()
results[#results + 1] = "async=" .. async_result

-- Test 7: Multiple handlers
local handler_count = 0
local p7 = createPromise(function(r) r("done") end)
p7.andThen(function(v) handler_count = handler_count + 1 end)
p7.andThen(function(v) handler_count = handler_count + 1 end)
p7.andThen(function(v) handler_count = handler_count + 1 end)
results[#results + 1] = "handlers=" .. handler_count

print(table.concat(results, ","))
-- Expected: promise=resolved:42,chain=1>2,deferred=100,all=1+2+3,race=first,async=50,handlers=3
