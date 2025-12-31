-- Test: Mixed feature integration
local results = {}

-- Test 1: Coroutines with closures
local function create_generator(start, step)
    local value = start
    return coroutine.wrap(function()
        while true do
            coroutine.yield(value)
            value = value + step
        end
    end)
end
local gen = create_generator(0, 5)
local gen_vals = {gen(), gen(), gen(), gen()}
results[#results + 1] = "coro_closure=" .. table.concat(gen_vals, ":")

-- Test 2: Metatables with coroutines
local lazy_mt = {
    __index = function(t, k)
        if not t._cache[k] then
            t._cache[k] = t._compute(k)
        end
        return t._cache[k]
    end
}
local function createLazySequence(fn)
    return setmetatable({
        _cache = {},
        _compute = fn
    }, lazy_mt)
end
local squares = createLazySequence(function(n) return n * n end)
results[#results + 1] = "meta_lazy=" .. squares[5] .. ":" .. squares[10]

-- Test 3: Error handling in coroutines with closures
local error_log = {}
local safe_gen = coroutine.wrap(function()
    for i = 1, 5 do
        local ok, result = pcall(function()
            if i == 3 then error("skip") end
            return i * 2
        end)
        if ok then
            coroutine.yield(result)
        else
            error_log[#error_log + 1] = i
        end
    end
end)
local safe_vals = {}
for v in safe_gen do
    safe_vals[#safe_vals + 1] = v
end
results[#results + 1] = "safe_gen=" .. table.concat(safe_vals, ":") .. "|" .. table.concat(error_log, ":")

-- Test 4: Debug with closures
local function create_traced(fn, name)
    return function(...)
        local info = debug.getinfo(1, "n")
        local args = {...}
        local result = fn(...)
        return result
    end
end
local traced_add = create_traced(function(a, b) return a + b end, "add")
results[#results + 1] = "debug_closure=" .. traced_add(10, 20)

-- Test 5: Varargs with metatables
local vararg_mt = {
    __call = function(t, ...)
        local sum = 0
        for i = 1, select('#', ...) do
            sum = sum + select(i, ...)
        end
        return sum + t.base
    end
}
local summer = setmetatable({base = 100}, vararg_mt)
results[#results + 1] = "vararg_meta=" .. summer(1, 2, 3, 4, 5)

-- Test 6: Tables as coroutine state
local function table_producer(t)
    return coroutine.wrap(function()
        for k, v in pairs(t) do
            coroutine.yield(k, v)
        end
    end)
end
local pair_sum = 0
for k, v in table_producer({a = 1, b = 2, c = 3}) do
    pair_sum = pair_sum + v
end
results[#results + 1] = "table_coro=" .. pair_sum

-- Test 7: Recursive metatables
local function createProxy(target, handler)
    return setmetatable({}, {
        __index = function(_, k)
            local v = target[k]
            if handler.get then
                return handler.get(target, k, v)
            end
            return v
        end,
        __newindex = function(_, k, v)
            if handler.set then
                handler.set(target, k, v)
            else
                target[k] = v
            end
        end
    })
end
local log = {}
local obj = {x = 1, y = 2}
local proxy = createProxy(obj, {
    get = function(t, k, v)
        log[#log + 1] = "get:" .. k
        return v
    end,
    set = function(t, k, v)
        log[#log + 1] = "set:" .. k
        t[k] = v
    end
})
local _ = proxy.x
proxy.z = 3
results[#results + 1] = "proxy=" .. table.concat(log, ",")

-- Test 8: Complex iterator with state
local function pairs_with_transform(t, fn)
    local keys = {}
    for k in pairs(t) do
        keys[#keys + 1] = k
    end
    table.sort(keys)
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], fn(t[keys[i]])
        end
    end
end
local transformed = {}
for k, v in pairs_with_transform({c = 3, a = 1, b = 2}, function(x) return x * 10 end) do
    transformed[#transformed + 1] = k .. "=" .. v
end
results[#results + 1] = "transform=" .. table.concat(transformed, ",")

-- Test 9: Closure over coroutine
local function make_async_counter()
    local co = coroutine.create(function()
        local count = 0
        while true do
            count = count + 1
            coroutine.yield(count)
        end
    end)
    return function()
        local _, val = coroutine.resume(co)
        return val
    end
end
local async_count = make_async_counter()
results[#results + 1] = "async_closure=" .. async_count() .. ":" .. async_count() .. ":" .. async_count()

-- Test 10: All features combined
local function create_reactive_store()
    local state = {}
    local watchers = {}

    local store_mt = {
        __index = function(_, k)
            return state[k]
        end,
        __newindex = function(_, k, v)
            local old = state[k]
            state[k] = v
            if watchers[k] then
                for _, w in ipairs(watchers[k]) do
                    local ok, err = pcall(w, v, old)
                end
            end
        end
    }

    local store = setmetatable({}, store_mt)

    return {
        store = store,
        watch = function(key, fn)
            watchers[key] = watchers[key] or {}
            watchers[key][#watchers[key] + 1] = fn
        end,
        batch = function(updates)
            return coroutine.wrap(function()
                for k, v in pairs(updates) do
                    store[k] = v
                    coroutine.yield(k)
                end
            end)
        end
    }
end

local reactive = create_reactive_store()
local watch_log = {}
reactive.watch("x", function(new, old)
    watch_log[#watch_log + 1] = (old or "nil") .. ">" .. new
end)
reactive.store.x = 1
reactive.store.x = 2
local batch_keys = {}
for k in reactive.batch({a = 10, b = 20}) do
    batch_keys[#batch_keys + 1] = k
end
results[#results + 1] = "reactive_all=" .. table.concat(watch_log, ",") .. "|" .. #batch_keys

print(table.concat(results, ","))
-- Expected shows all features working together
