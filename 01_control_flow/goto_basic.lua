-- Test: Basic goto statements (Lua 5.2+)
-- Note: goto is not available in Lua 5.1

local results = {}

-- Test 1: Simple forward jump
local x = 0
goto skip
x = 100  -- Skipped
::skip::
x = x + 1
results[#results + 1] = "forward=" .. x

-- Test 2: Backward jump (simple loop)
local count = 0
::loop_start::
count = count + 1
if count < 5 then
    goto loop_start
end
results[#results + 1] = "backward=" .. count

-- Test 3: Jump over code block
local y = 0
if true then
    y = 1
    goto after_block
    y = 100  -- Skipped
end
::after_block::
y = y + 10
results[#results + 1] = "over_block=" .. y

-- Test 4: Multiple labels
local path = ""
goto first
::second::
path = path .. "2"
goto done
::first::
path = path .. "1"
goto second
::done::
results[#results + 1] = "multi_label=" .. path

-- Test 5: Goto in loop
local sum = 0
for i = 1, 10 do
    if i == 5 then
        goto continue
    end
    sum = sum + i
    ::continue::
end
results[#results + 1] = "loop_continue=" .. sum  -- 1+2+3+4+6+7+8+9+10=50

-- Test 6: Nested goto targets
local nested_val = 0
do
    goto inner
    nested_val = 100
    ::inner::
    nested_val = nested_val + 1
end
results[#results + 1] = "nested=" .. nested_val

print(table.concat(results, ","))
-- Expected: forward=1,backward=5,over_block=11,multi_label=12,loop_continue=50,nested=1
