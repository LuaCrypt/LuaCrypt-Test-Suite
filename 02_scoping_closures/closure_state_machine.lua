-- Test: State machines using closures
local results = {}

-- Test 1: Simple on/off state
local function createSwitch()
    local on = false
    return {
        toggle = function()
            on = not on
            return on
        end,
        isOn = function()
            return on
        end
    }
end
local switch = createSwitch()
results[#results + 1] = "switch=" .. tostring(switch.isOn())
switch.toggle()
results[#results + 1] = "toggled=" .. tostring(switch.isOn())

-- Test 2: Multi-state machine
local function createTrafficLight()
    local states = {"red", "green", "yellow"}
    local current = 1
    return {
        next = function()
            current = (current % 3) + 1
            return states[current]
        end,
        current = function()
            return states[current]
        end
    }
end
local light = createTrafficLight()
local sequence = {light.current()}
for i = 1, 3 do
    sequence[#sequence + 1] = light.next()
end
results[#results + 1] = "light=" .. table.concat(sequence, "->")

-- Test 3: Stack using closures
local function createStack()
    local items = {}
    return {
        push = function(item)
            items[#items + 1] = item
        end,
        pop = function()
            if #items == 0 then return nil end
            local item = items[#items]
            items[#items] = nil
            return item
        end,
        peek = function()
            return items[#items]
        end,
        size = function()
            return #items
        end
    }
end
local stack = createStack()
stack.push(1)
stack.push(2)
stack.push(3)
results[#results + 1] = "stack_pop=" .. stack.pop() .. ";" .. stack.pop()
results[#results + 1] = "stack_size=" .. stack.size()

-- Test 4: Event emitter pattern
local function createEmitter()
    local listeners = {}
    return {
        on = function(event, fn)
            listeners[event] = listeners[event] or {}
            listeners[event][#listeners[event] + 1] = fn
        end,
        emit = function(event, data)
            if listeners[event] then
                for _, fn in ipairs(listeners[event]) do
                    fn(data)
                end
            end
        end
    }
end
local emitter = createEmitter()
local received = {}
emitter.on("test", function(d) received[#received + 1] = d end)
emitter.on("test", function(d) received[#received + 1] = d * 2 end)
emitter.emit("test", 5)
results[#results + 1] = "emitter=" .. table.concat(received, ";")

print(table.concat(results, ","))
-- Expected: switch=false,toggled=true,light=red->green->yellow->red,stack_pop=3;2,stack_size=1,emitter=5;10
