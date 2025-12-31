-- Test: Goto scope rules
local results = {}

-- Test 1: Cannot jump into local scope (this pattern is valid - jumping out)
local val1 = 0
do
    val1 = 10
    goto out1
    val1 = 100  -- Skipped
end
::out1::
results[#results + 1] = "jump_out=" .. val1

-- Test 2: Label visibility in same scope
local val2 = 0
::start2::
val2 = val2 + 1
if val2 < 3 then
    goto start2
end
results[#results + 1] = "same_scope=" .. val2

-- Test 3: Goto within if block
local val3 = 0
if true then
    val3 = 1
    goto label3
    val3 = 100  -- Skipped
    ::label3::
    val3 = val3 + 10
end
results[#results + 1] = "if_block=" .. val3

-- Test 4: Labels in different branches (valid - only one executes)
local val4 = 0
local cond = true
if cond then
    goto branch_a
    ::branch_a::
    val4 = 1
else
    val4 = 2
end
results[#results + 1] = "branch=" .. val4

-- Test 5: Nested do blocks
local val5 = 0
do
    do
        val5 = 1
        goto inner_done
        val5 = 100
        ::inner_done::
    end
    val5 = val5 + 10
end
results[#results + 1] = "nested_do=" .. val5

-- Test 6: Label after loop
local val6 = 0
for i = 1, 5 do
    val6 = val6 + i
    if val6 > 10 then
        goto after_loop
    end
end
::after_loop::
val6 = val6 + 100
results[#results + 1] = "after_loop=" .. val6

print(table.concat(results, ","))
-- Expected: jump_out=10,same_scope=3,if_block=11,branch=1,nested_do=11,after_loop=115
