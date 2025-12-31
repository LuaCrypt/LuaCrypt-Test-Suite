-- Test: Event ordering and callback sequencing
local results = {}

-- Test 1: Sequential event firing
local event_log = {}
local function emit(event)
    event_log[#event_log + 1] = event
end
emit("start")
emit("middle")
emit("end")
results[#results + 1] = "seq=" .. table.concat(event_log, ">")

-- Test 2: Handler execution order
local handlers = {}
local handler_order = {}
local function on(event, handler)
    handlers[event] = handlers[event] or {}
    handlers[event][#handlers[event] + 1] = handler
end
local function fire(event, data)
    if handlers[event] then
        for _, h in ipairs(handlers[event]) do
            h(data)
        end
    end
end
on("test", function(d) handler_order[#handler_order + 1] = "h1:" .. d end)
on("test", function(d) handler_order[#handler_order + 1] = "h2:" .. d end)
on("test", function(d) handler_order[#handler_order + 1] = "h3:" .. d end)
fire("test", "data")
results[#results + 1] = "order=" .. table.concat(handler_order, ",")

-- Test 3: Nested event emission
local nested_log = {}
local nested_handlers = {}
local function nested_on(event, handler)
    nested_handlers[event] = handler
end
local function nested_fire(event)
    nested_log[#nested_log + 1] = event .. "_start"
    if nested_handlers[event] then
        nested_handlers[event]()
    end
    nested_log[#nested_log + 1] = event .. "_end"
end
nested_on("outer", function()
    nested_fire("inner")
end)
nested_on("inner", function()
    nested_log[#nested_log + 1] = "inner_body"
end)
nested_fire("outer")
results[#results + 1] = "nested=" .. table.concat(nested_log, ">")

-- Test 4: Event with return value
local function create_pipeline()
    local filters = {}
    return {
        add = function(fn)
            filters[#filters + 1] = fn
        end,
        process = function(val)
            for _, f in ipairs(filters) do
                val = f(val)
            end
            return val
        end
    }
end
local pipe = create_pipeline()
pipe.add(function(x) return x * 2 end)
pipe.add(function(x) return x + 1 end)
pipe.add(function(x) return x * 3 end)
results[#results + 1] = "pipeline=" .. pipe.process(5)

-- Test 5: Priority-based ordering
local priority_log = {}
local prio_handlers = {}
local function prio_on(event, priority, handler)
    prio_handlers[event] = prio_handlers[event] or {}
    prio_handlers[event][#prio_handlers[event] + 1] = {p = priority, h = handler}
    table.sort(prio_handlers[event], function(a, b) return a.p > b.p end)
end
local function prio_fire(event)
    if prio_handlers[event] then
        for _, ph in ipairs(prio_handlers[event]) do
            ph.h()
        end
    end
end
prio_on("test", 1, function() priority_log[#priority_log + 1] = "low" end)
prio_on("test", 3, function() priority_log[#priority_log + 1] = "high" end)
prio_on("test", 2, function() priority_log[#priority_log + 1] = "med" end)
prio_fire("test")
results[#results + 1] = "priority=" .. table.concat(priority_log, ">")

-- Test 6: Once handlers
local once_count = 0
local once_handlers = {}
local function once(event, handler)
    once_handlers[event] = function(...)
        once_handlers[event] = nil
        return handler(...)
    end
end
local function fire_once(event)
    if once_handlers[event] then
        once_handlers[event]()
    end
end
once("single", function() once_count = once_count + 1 end)
fire_once("single")
fire_once("single")
fire_once("single")
results[#results + 1] = "once=" .. once_count

-- Test 7: Event bubbling simulation
local bubble_log = {}
local function create_element(name, parent)
    return {
        name = name,
        parent = parent,
        handle = function(event)
            bubble_log[#bubble_log + 1] = name
            if parent then
                parent.handle(event)
            end
        end
    }
end
local root = create_element("root", nil)
local child = create_element("child", root)
local grandchild = create_element("grandchild", child)
grandchild.handle("click")
results[#results + 1] = "bubble=" .. table.concat(bubble_log, ">")

-- Test 8: Async simulation with coroutines
local async_log = {}
local tasks = {}
local function async(fn)
    tasks[#tasks + 1] = coroutine.create(fn)
end
local function await()
    coroutine.yield()
end
local function run_tasks()
    while #tasks > 0 do
        local current = table.remove(tasks, 1)
        if coroutine.status(current) ~= "dead" then
            coroutine.resume(current)
            if coroutine.status(current) ~= "dead" then
                tasks[#tasks + 1] = current
            end
        end
    end
end
async(function()
    async_log[#async_log + 1] = "A1"
    await()
    async_log[#async_log + 1] = "A2"
end)
async(function()
    async_log[#async_log + 1] = "B1"
    await()
    async_log[#async_log + 1] = "B2"
end)
run_tasks()
results[#results + 1] = "async=" .. table.concat(async_log, ">")

print(table.concat(results, ","))
-- Expected: seq=start>middle>end,order=h1:data,h2:data,h3:data,nested=outer_start>inner_start>inner_body>inner_end>outer_end,pipeline=33,priority=high>med>low,once=1,bubble=grandchild>child>root,async=A1>B1>A2>B2
