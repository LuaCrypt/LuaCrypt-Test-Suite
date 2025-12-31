-- Test: State machine implementations
local results = {}

-- Test 1: Simple state machine
local function createSimpleSM(initial)
    local state = initial
    local transitions = {}

    return {
        getState = function() return state end,
        addTransition = function(from, event, to)
            transitions[from] = transitions[from] or {}
            transitions[from][event] = to
        end,
        trigger = function(event)
            if transitions[state] and transitions[state][event] then
                state = transitions[state][event]
                return true
            end
            return false
        end
    }
end

local sm = createSimpleSM("off")
sm.addTransition("off", "turnOn", "on")
sm.addTransition("on", "turnOff", "off")
local trace1 = {sm.getState()}
sm.trigger("turnOn")
trace1[#trace1 + 1] = sm.getState()
sm.trigger("turnOff")
trace1[#trace1 + 1] = sm.getState()
results[#results + 1] = "simple=" .. table.concat(trace1, ">")

-- Test 2: State machine with actions
local function createActionSM(initial)
    local state = initial
    local transitions = {}
    local action_log = {}

    return {
        getState = function() return state end,
        getLog = function() return action_log end,
        addTransition = function(from, event, to, action)
            transitions[from] = transitions[from] or {}
            transitions[from][event] = {to = to, action = action}
        end,
        trigger = function(event, data)
            if transitions[state] and transitions[state][event] then
                local t = transitions[state][event]
                if t.action then
                    action_log[#action_log + 1] = t.action(data)
                end
                state = t.to
                return true
            end
            return false
        end
    }
end

local sm2 = createActionSM("idle")
sm2.addTransition("idle", "start", "running", function(d) return "started:" .. d end)
sm2.addTransition("running", "stop", "idle", function(d) return "stopped:" .. d end)
sm2.trigger("start", "A")
sm2.trigger("stop", "B")
results[#results + 1] = "actions=" .. table.concat(sm2.getLog(), ",")

-- Test 3: Hierarchical state machine
local function createHSM()
    local state = {main = "off", sub = nil}

    local function getFullState()
        if state.sub then
            return state.main .. "." .. state.sub
        end
        return state.main
    end

    local function transition(event)
        if state.main == "off" and event == "power" then
            state.main = "on"
            state.sub = "idle"
        elseif state.main == "on" then
            if event == "power" then
                state.main = "off"
                state.sub = nil
            elseif event == "play" and state.sub == "idle" then
                state.sub = "playing"
            elseif event == "pause" and state.sub == "playing" then
                state.sub = "paused"
            elseif event == "play" and state.sub == "paused" then
                state.sub = "playing"
            elseif event == "stop" then
                state.sub = "idle"
            end
        end
    end

    return {
        getState = getFullState,
        send = transition
    }
end

local hsm = createHSM()
local trace3 = {hsm.getState()}
hsm.send("power")
trace3[#trace3 + 1] = hsm.getState()
hsm.send("play")
trace3[#trace3 + 1] = hsm.getState()
hsm.send("pause")
trace3[#trace3 + 1] = hsm.getState()
results[#results + 1] = "hsm=" .. table.concat(trace3, ">")

-- Test 4: State machine with guards
local function createGuardedSM()
    local state = "locked"
    local pin = "1234"

    local function transition(event, data)
        if state == "locked" then
            if event == "enter" and data == pin then
                state = "unlocked"
                return true
            end
        elseif state == "unlocked" then
            if event == "lock" then
                state = "locked"
                return true
            end
        end
        return false
    end

    return {
        getState = function() return state end,
        send = transition
    }
end

local gsm = createGuardedSM()
local guard_results = {}
guard_results[1] = tostring(gsm.send("enter", "wrong"))
guard_results[2] = gsm.getState()
guard_results[3] = tostring(gsm.send("enter", "1234"))
guard_results[4] = gsm.getState()
results[#results + 1] = "guard=" .. table.concat(guard_results, ",")

-- Test 5: Parallel states simulation
local function createParallelSM()
    local states = {
        connection = "disconnected",
        auth = "logged_out"
    }

    return {
        getStates = function()
            return states.connection .. "/" .. states.auth
        end,
        send = function(event)
            if event == "connect" then states.connection = "connected" end
            if event == "disconnect" then
                states.connection = "disconnected"
                states.auth = "logged_out"
            end
            if event == "login" and states.connection == "connected" then
                states.auth = "logged_in"
            end
            if event == "logout" then states.auth = "logged_out" end
        end
    }
end

local psm = createParallelSM()
local trace5 = {psm.getStates()}
psm.send("connect")
trace5[#trace5 + 1] = psm.getStates()
psm.send("login")
trace5[#trace5 + 1] = psm.getStates()
results[#results + 1] = "parallel=" .. table.concat(trace5, ">")

-- Test 6: State machine with history
local function createHistorySM()
    local state = "A"
    local history = nil

    return {
        getState = function() return state end,
        send = function(event)
            if event == "toB" and state == "A" then
                history = state
                state = "B"
            elseif event == "toC" and state == "B" then
                state = "C"
            elseif event == "back" and history then
                state = history
                history = nil
            end
        end
    }
end

local hism = createHistorySM()
local trace6 = {hism.getState()}
hism.send("toB")
trace6[#trace6 + 1] = hism.getState()
hism.send("toC")
trace6[#trace6 + 1] = hism.getState()
hism.send("back")
trace6[#trace6 + 1] = hism.getState()
results[#results + 1] = "history=" .. table.concat(trace6, ">")

print(table.concat(results, ","))
-- Expected: simple=off>on>off,actions=started:A,stopped:B,hsm=off>on.idle>on.playing>on.paused,guard=false,locked,true,unlocked,parallel=disconnected/logged_out>connected/logged_out>connected/logged_in,history=A>B>C>A
