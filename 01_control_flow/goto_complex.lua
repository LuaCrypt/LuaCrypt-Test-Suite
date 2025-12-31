-- Test: Complex goto patterns
local results = {}

-- Test 1: State machine simulation
local state = "start"
local output = ""
::state_start::
if state == "start" then
    output = output .. "S"
    state = "process"
    goto state_process
end
::state_process::
if state == "process" then
    output = output .. "P"
    state = "done"
    goto state_done
end
::state_done::
if state == "done" then
    output = output .. "D"
end
results[#results + 1] = "fsm=" .. output

-- Test 2: Error handling pattern
local function process(data)
    local result = ""

    if data < 0 then
        result = "error:negative"
        goto cleanup
    end

    if data > 100 then
        result = "error:overflow"
        goto cleanup
    end

    result = "ok:" .. data

    ::cleanup::
    -- Cleanup code would go here
    return result .. "_cleaned"
end
results[#results + 1] = "err1=" .. process(-5)
results[#results + 1] = "err2=" .. process(150)
results[#results + 1] = "ok=" .. process(50)

-- Test 3: Computed goto pattern (using table)
local jump_table = {
    [1] = function() return "action1" end,
    [2] = function() return "action2" end,
    [3] = function() return "action3" end
}
local action_results = {}
for i = 1, 3 do
    action_results[#action_results + 1] = jump_table[i]()
end
results[#results + 1] = "computed=" .. table.concat(action_results, ";")

-- Test 4: Skip initialization
local val4
goto skip_init
val4 = 999  -- Skipped
::skip_init::
val4 = val4 or 0
val4 = val4 + 1
results[#results + 1] = "skip_init=" .. val4

-- Test 5: Multiple conditions leading to same target
local x = 7
local outcome = ""
if x < 0 then goto handle end
if x > 10 then goto handle end
if x == 7 then goto handle end
outcome = "normal"
goto done5
::handle::
outcome = "handled"
::done5::
results[#results + 1] = "multi_cond=" .. outcome

print(table.concat(results, ","))
-- Expected: fsm=SPD,err1=error:negative_cleaned,err2=error:overflow_cleaned,ok=ok:50_cleaned,computed=action1;action2;action3,skip_init=1,multi_cond=handled
