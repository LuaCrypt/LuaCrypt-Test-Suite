-- Edge cases for goto statements and labels
-- Tests fixes for: continue as label name, complex goto patterns

local results = {}

-- Test 1: Basic goto forward
local x = 0
goto skip1
x = 100
::skip1::
x = x + 1
results[#results + 1] = x  -- 1

-- Test 2: Goto backward (loop simulation)
local counter = 0
::loop_start::
counter = counter + 1
if counter < 3 then
    goto loop_start
end
results[#results + 1] = counter  -- 3

-- Test 3: Label named 'continue' (edge case - keyword in some contexts)
local sum = 0
for i = 1, 5 do
    if i == 3 then
        goto continue
    end
    sum = sum + i
    ::continue::
end
results[#results + 1] = sum  -- 1+2+4+5 = 12

-- Test 4: Nested loops with goto
local outer_count = 0
for i = 1, 3 do
    for j = 1, 3 do
        if j == 2 then
            goto next_outer
        end
        outer_count = outer_count + 1
    end
    ::next_outer::
end
results[#results + 1] = outer_count  -- 3 (only j=1 counted each time)

-- Test 5: Goto skipping variable declarations
local y
goto skip_decl
do
    local temp = 999  -- This is skipped
end
::skip_decl::
y = 42
results[#results + 1] = y  -- 42

-- Test 6: Multiple labels in same scope
local val = 0
goto second
::first::
val = val + 1
goto done
::second::
val = val + 10
goto first
::done::
results[#results + 1] = val  -- 11

-- Test 7: Goto in if-else
local branch = 0
local condition = true
if condition then
    goto if_end
    branch = 1
else
    branch = 2
end
::if_end::
branch = 3
results[#results + 1] = branch  -- 3

-- Test 8: Goto with break interaction
local break_test = 0
for i = 1, 10 do
    if i == 5 then
        break_test = i
        goto after_loop
    end
end
::after_loop::
results[#results + 1] = break_test  -- 5

-- Test 9: Label at end of block
local end_test = 0
do
    end_test = 1
    goto block_end
    end_test = 2
    ::block_end::
end
results[#results + 1] = end_test  -- 1

-- Test 10: Goto in while loop
local while_val = 0
local while_i = 0
while while_i < 5 do
    while_i = while_i + 1
    if while_i == 3 then
        goto skip_add
    end
    while_val = while_val + while_i
    ::skip_add::
end
results[#results + 1] = while_val  -- 1+2+4+5 = 12

-- Test 11: Goto crossing function boundary (should NOT work - just test it doesn't crash)
-- This is actually a compile error, so we skip it

-- Test 12: Label visibility in nested blocks
local nested = 0
do
    do
        goto inner_label
    end
    nested = 100
    ::inner_label::
    nested = nested + 1
end
results[#results + 1] = nested  -- 1

-- Test 13: Goto in repeat-until
local repeat_val = 0
local repeat_i = 0
repeat
    repeat_i = repeat_i + 1
    if repeat_i % 2 == 0 then
        goto skip_repeat
    end
    repeat_val = repeat_val + repeat_i
    ::skip_repeat::
until repeat_i >= 6
results[#results + 1] = repeat_val  -- 1+3+5 = 9

-- Test 14: Complex control flow with multiple gotos
local complex = 0
local state = 1
::state_machine::
if state == 1 then
    complex = complex + 1
    state = 2
    goto state_machine
elseif state == 2 then
    complex = complex + 10
    state = 3
    goto state_machine
elseif state == 3 then
    complex = complex + 100
    -- done
end
results[#results + 1] = complex  -- 111

-- Test 15: Goto with numeric for loop
local numeric_sum = 0
for i = 1, 10 do
    if i > 5 then
        goto end_numeric
    end
    numeric_sum = numeric_sum + i
end
::end_numeric::
results[#results + 1] = numeric_sum  -- 1+2+3+4+5 = 15

print(table.concat(results, ","))
-- Expected: 1,3,12,3,42,11,3,5,1,12,1,9,111,15
