-- Test: Edge cases for goto
local results = {}

-- Test 1: Immediately adjacent label and goto
::adj_label::
goto adj_done
::adj_done::
results[#results + 1] = "adjacent=ok"

-- Test 2: Self-referencing goto (with counter to prevent infinite)
local self_count = 0
::self_ref::
self_count = self_count + 1
if self_count < 3 then
    goto self_ref
end
results[#results + 1] = "self=" .. self_count

-- Test 3: Goto in empty if body
local empty_val = 0
if true then
    goto empty_label
end
empty_val = 100  -- Skipped
::empty_label::
results[#results + 1] = "empty_if=" .. empty_val

-- Test 4: Alternating jumps
local alt_count = 0
local at_a = true
::alt_a::
alt_count = alt_count + 1
if alt_count < 6 then
    if at_a then
        at_a = false
        goto alt_b
    end
end
goto alt_done
::alt_b::
alt_count = alt_count + 1
at_a = true
if alt_count < 6 then
    goto alt_a
end
::alt_done::
results[#results + 1] = "alt=" .. alt_count

-- Test 5: Goto past multiple statements
local past_val = 0
goto past_target
past_val = past_val + 1
past_val = past_val + 2
past_val = past_val + 3
past_val = past_val + 4
::past_target::
past_val = past_val + 100
results[#results + 1] = "past=" .. past_val

-- Test 6: Label with unusual (but valid) names
local unusual = 0
::_label123::
unusual = 1
goto __done__
unusual = 100
::__done__::
results[#results + 1] = "unusual=" .. unusual

print(table.concat(results, ","))
-- Expected: adjacent=ok,self=3,empty_if=0,alt=6,past=100,unusual=1
