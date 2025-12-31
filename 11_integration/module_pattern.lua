-- Test: Module pattern implementation
local results = {}

-- Test 1: Basic module pattern
local function create_module()
    local private_data = 0

    local function private_helper()
        return private_data * 2
    end

    return {
        get = function()
            return private_data
        end,
        set = function(val)
            private_data = val
        end,
        double = function()
            return private_helper()
        end
    }
end
local mod = create_module()
mod.set(21)
results[#results + 1] = "module=" .. mod.get() .. ":" .. mod.double()

-- Test 2: Singleton pattern
local Singleton = (function()
    local instance = nil
    local value = 0

    local function create()
        return {
            get = function() return value end,
            set = function(v) value = v end
        }
    end

    return {
        getInstance = function()
            if not instance then
                instance = create()
            end
            return instance
        end
    }
end)()
local s1 = Singleton.getInstance()
local s2 = Singleton.getInstance()
s1.set(42)
results[#results + 1] = "singleton=" .. tostring(s1 == s2) .. ":" .. s2.get()

-- Test 3: Factory pattern
local function AnimalFactory()
    local function createDog(name)
        return {
            type = "dog",
            name = name,
            speak = function() return "woof" end
        }
    end

    local function createCat(name)
        return {
            type = "cat",
            name = name,
            speak = function() return "meow" end
        }
    end

    return {
        create = function(animal_type, name)
            if animal_type == "dog" then
                return createDog(name)
            elseif animal_type == "cat" then
                return createCat(name)
            end
        end
    }
end
local factory = AnimalFactory()
local dog = factory.create("dog", "Rex")
local cat = factory.create("cat", "Whiskers")
results[#results + 1] = "factory=" .. dog.speak() .. ":" .. cat.speak()

-- Test 4: Observer pattern
local function createObservable()
    local observers = {}
    local value = nil

    return {
        subscribe = function(fn)
            observers[#observers + 1] = fn
        end,
        setValue = function(v)
            value = v
            for _, obs in ipairs(observers) do
                obs(value)
            end
        end,
        getValue = function()
            return value
        end
    }
end
local observable = createObservable()
local obs_log = {}
observable.subscribe(function(v) obs_log[#obs_log + 1] = "A:" .. v end)
observable.subscribe(function(v) obs_log[#obs_log + 1] = "B:" .. v end)
observable.setValue(10)
results[#results + 1] = "observer=" .. table.concat(obs_log, ",")

-- Test 5: Decorator pattern
local function baseComponent()
    return {
        operation = function() return "base" end
    }
end
local function decoratorA(component)
    local orig = component.operation
    component.operation = function()
        return orig() .. "+A"
    end
    return component
end
local function decoratorB(component)
    local orig = component.operation
    component.operation = function()
        return orig() .. "+B"
    end
    return component
end
local decorated = decoratorB(decoratorA(baseComponent()))
results[#results + 1] = "decorator=" .. decorated.operation()

-- Test 6: Command pattern
local function createCommandManager()
    local history = {}

    return {
        execute = function(cmd)
            cmd.execute()
            history[#history + 1] = cmd
        end,
        undo = function()
            if #history > 0 then
                local cmd = table.remove(history)
                cmd.undo()
            end
        end,
        history_size = function()
            return #history
        end
    }
end
local value = 0
local manager = createCommandManager()
local addCmd = {
    execute = function() value = value + 10 end,
    undo = function() value = value - 10 end
}
manager.execute(addCmd)
manager.execute(addCmd)
local after_exec = value
manager.undo()
local after_undo = value
results[#results + 1] = "command=" .. after_exec .. ":" .. after_undo

-- Test 7: State pattern
local function createStateMachine()
    local state = "idle"
    local transitions = {
        idle = {start = "running"},
        running = {pause = "paused", stop = "idle"},
        paused = {resume = "running", stop = "idle"}
    }

    return {
        getState = function() return state end,
        transition = function(action)
            if transitions[state] and transitions[state][action] then
                state = transitions[state][action]
                return true
            end
            return false
        end
    }
end
local sm = createStateMachine()
local states = {sm.getState()}
sm.transition("start")
states[#states + 1] = sm.getState()
sm.transition("pause")
states[#states + 1] = sm.getState()
sm.transition("resume")
states[#states + 1] = sm.getState()
results[#results + 1] = "state=" .. table.concat(states, ">")

-- Test 8: Mixin pattern
local function mixin(target, source)
    for k, v in pairs(source) do
        if target[k] == nil then
            target[k] = v
        end
    end
    return target
end
local Walkable = {
    walk = function(self) return self.name .. " walks" end
}
local Talkable = {
    talk = function(self) return self.name .. " talks" end
}
local person = mixin(mixin({name = "Bob"}, Walkable), Talkable)
results[#results + 1] = "mixin=" .. person:walk() .. "," .. person:talk()

print(table.concat(results, ","))
-- Expected: module=21:42,singleton=true:42,factory=woof:meow,observer=A:10,B:10,decorator=base+A+B,command=20:10,state=idle>running>paused>running,mixin=Bob walks,Bob talks
