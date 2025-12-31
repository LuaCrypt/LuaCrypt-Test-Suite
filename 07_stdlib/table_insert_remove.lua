-- Test: Table insert and remove
local results = {}

-- Test 1: Basic insert at end
local t1 = {1, 2, 3}
table.insert(t1, 4)
results[#results + 1] = "insert_end=" .. table.concat(t1, ":")

-- Test 2: Insert at position
local t2 = {1, 2, 4}
table.insert(t2, 3, 3)
results[#results + 1] = "insert_pos=" .. table.concat(t2, ":")

-- Test 3: Insert at beginning
local t3 = {2, 3, 4}
table.insert(t3, 1, 1)
results[#results + 1] = "insert_start=" .. table.concat(t3, ":")

-- Test 4: Remove from end
local t4 = {1, 2, 3, 4}
local removed4 = table.remove(t4)
results[#results + 1] = "remove_end=" .. removed4 .. ":" .. table.concat(t4, ":")

-- Test 5: Remove from position
local t5 = {1, 2, 3, 4}
local removed5 = table.remove(t5, 2)
results[#results + 1] = "remove_pos=" .. removed5 .. ":" .. table.concat(t5, ":")

-- Test 6: Remove from beginning
local t6 = {1, 2, 3, 4}
local removed6 = table.remove(t6, 1)
results[#results + 1] = "remove_start=" .. removed6 .. ":" .. table.concat(t6, ":")

-- Test 7: Multiple inserts
local t7 = {}
for i = 1, 5 do
    table.insert(t7, i)
end
results[#results + 1] = "multi_ins=" .. #t7

-- Test 8: Multiple removes
local t8 = {1, 2, 3, 4, 5}
local sum8 = 0
while #t8 > 0 do
    sum8 = sum8 + table.remove(t8)
end
results[#results + 1] = "multi_rem=" .. sum8

-- Test 9: Insert/remove interleaved
local t9 = {}
for i = 1, 10 do
    table.insert(t9, i)
    if i % 2 == 0 then
        table.remove(t9, 1)
    end
end
results[#results + 1] = "interleave=" .. #t9

-- Test 10: Remove from empty (edge)
local t10 = {}
local r10 = table.remove(t10)
results[#results + 1] = "empty_rem=" .. tostring(r10)

-- Test 11: Insert nil-ish value
local t11 = {1, 2, 3}
table.insert(t11, 2, 0)
results[#results + 1] = "zero_ins=" .. table.concat(t11, ":")

print(table.concat(results, ","))
-- Expected: insert_end=1:2:3:4,insert_pos=1:2:3:4,insert_start=1:2:3:4,remove_end=4:1:2:3,remove_pos=2:1:3:4,remove_start=1:2:3:4,multi_ins=5,multi_rem=15,interleave=5,empty_rem=nil,zero_ins=1:0:2:3
