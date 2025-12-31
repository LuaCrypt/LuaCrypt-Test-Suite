-- Test: Complex integration scenarios
local results = {}

-- Test 1: Event-driven calculator
local function createCalculator()
    local value = 0
    local history = {}
    local listeners = {}

    local function notify(event, data)
        if listeners[event] then
            for _, fn in ipairs(listeners[event]) do
                fn(data)
            end
        end
    end

    return {
        on = function(event, fn)
            listeners[event] = listeners[event] or {}
            listeners[event][#listeners[event] + 1] = fn
        end,
        add = function(n)
            history[#history + 1] = {op = "add", val = n, before = value}
            value = value + n
            notify("change", value)
        end,
        multiply = function(n)
            history[#history + 1] = {op = "mul", val = n, before = value}
            value = value * n
            notify("change", value)
        end,
        undo = function()
            if #history > 0 then
                local last = table.remove(history)
                value = last.before
                notify("undo", value)
            end
        end,
        getValue = function() return value end
    }
end

local calc = createCalculator()
local calc_log = {}
calc.on("change", function(v) calc_log[#calc_log + 1] = "c:" .. v end)
calc.on("undo", function(v) calc_log[#calc_log + 1] = "u:" .. v end)
calc.add(10)
calc.multiply(3)
calc.undo()
results[#results + 1] = "calc=" .. table.concat(calc_log, ",")

-- Test 2: Middleware chain
local function createMiddlewareChain()
    local middlewares = {}

    return {
        use = function(fn)
            middlewares[#middlewares + 1] = fn
        end,
        execute = function(context)
            local idx = 0
            local function next()
                idx = idx + 1
                if middlewares[idx] then
                    middlewares[idx](context, next)
                end
            end
            next()
            return context
        end
    }
end

local chain = createMiddlewareChain()
chain.use(function(ctx, next)
    ctx.log[#ctx.log + 1] = "A:before"
    next()
    ctx.log[#ctx.log + 1] = "A:after"
end)
chain.use(function(ctx, next)
    ctx.log[#ctx.log + 1] = "B:before"
    next()
    ctx.log[#ctx.log + 1] = "B:after"
end)
chain.use(function(ctx, next)
    ctx.log[#ctx.log + 1] = "C"
end)
local ctx = chain.execute({log = {}})
results[#results + 1] = "middleware=" .. table.concat(ctx.log, ">")

-- Test 3: Reactive value with computed
local function createReactive(initial)
    local value = initial
    local watchers = {}

    return {
        get = function() return value end,
        set = function(v)
            value = v
            for _, w in ipairs(watchers) do w(value) end
        end,
        watch = function(fn)
            watchers[#watchers + 1] = fn
            fn(value)  -- immediate call
        end
    }
end

local function computed(deps, fn)
    local result = createReactive(nil)
    local function update()
        local args = {}
        for i, d in ipairs(deps) do
            args[i] = d.get()
        end
        result.set(fn(table.unpack(args)))
    end
    for _, d in ipairs(deps) do
        d.watch(update)
    end
    return result
end

local a = createReactive(2)
local b = createReactive(3)
local sum = computed({a, b}, function(x, y) return x + y end)
local reactive_log = {sum.get()}
a.set(5)
reactive_log[#reactive_log + 1] = sum.get()
results[#results + 1] = "reactive=" .. table.concat(reactive_log, ">")

-- Test 4: Plugin system
local function createPluginSystem()
    local plugins = {}
    local hooks = {}

    return {
        register = function(plugin)
            plugins[#plugins + 1] = plugin
            if plugin.install then
                plugin.install(hooks)
            end
        end,
        hook = function(name, ...)
            if hooks[name] then
                return hooks[name](...)
            end
        end,
        addHook = function(name, fn)
            hooks[name] = fn
        end
    }
end

local sys = createPluginSystem()
sys.register({
    install = function(hooks)
        hooks.transform = function(x) return x * 2 end
    end
})
local plugin_result = sys.hook("transform", 21)
results[#results + 1] = "plugin=" .. plugin_result

-- Test 5: Task scheduler with dependencies
local function createTaskScheduler()
    local tasks = {}
    local completed = {}
    local execution_order = {}

    return {
        addTask = function(name, deps, fn)
            tasks[name] = {deps = deps, fn = fn}
        end,
        run = function()
            local function canRun(name)
                for _, dep in ipairs(tasks[name].deps) do
                    if not completed[dep] then return false end
                end
                return true
            end

            local remaining = {}
            for name in pairs(tasks) do
                remaining[name] = true
            end

            while next(remaining) do
                for name in pairs(remaining) do
                    if canRun(name) then
                        tasks[name].fn()
                        execution_order[#execution_order + 1] = name
                        completed[name] = true
                        remaining[name] = nil
                    end
                end
            end
            return execution_order
        end
    }
end

local sched = createTaskScheduler()
sched.addTask("C", {"A", "B"}, function() end)
sched.addTask("A", {}, function() end)
sched.addTask("B", {"A"}, function() end)
local task_order = sched.run()
results[#results + 1] = "tasks=" .. table.concat(task_order, ">")

-- Test 6: Command pattern with macro
local function createMacroRecorder()
    local recording = false
    local macro = {}
    local value = 0

    local commands = {
        add = function(n)
            value = value + n
            if recording then
                macro[#macro + 1] = {cmd = "add", arg = n}
            end
        end,
        mul = function(n)
            value = value * n
            if recording then
                macro[#macro + 1] = {cmd = "mul", arg = n}
            end
        end
    }

    return {
        startRecording = function() recording = true; macro = {} end,
        stopRecording = function() recording = false end,
        playMacro = function()
            for _, m in ipairs(macro) do
                commands[m.cmd](m.arg)
            end
        end,
        execute = function(cmd, arg)
            commands[cmd](arg)
        end,
        getValue = function() return value end
    }
end

local recorder = createMacroRecorder()
recorder.startRecording()
recorder.execute("add", 5)
recorder.execute("mul", 2)
recorder.stopRecording()
recorder.playMacro()  -- replay: add 5, mul 2
results[#results + 1] = "macro=" .. recorder.getValue()

print(table.concat(results, ","))
-- Expected: calc=c:10,c:30,u:10,middleware=A:before>B:before>C>B:after>A:after,reactive=5>8,plugin=42,tasks=A>B>C,macro=30
