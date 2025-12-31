-- Test: Table length operator (#)
local results = {}

-- Test 1: Simple array length
local t1 = {1, 2, 3, 4, 5}
results[#results + 1] = "simple=" .. #t1

-- Test 2: Empty table
local t2 = {}
results[#results + 1] = "empty=" .. #t2

-- Test 3: Hash table (length is 0)
local t3 = {a = 1, b = 2, c = 3}
results[#results + 1] = "hash=" .. #t3

-- Test 4: Mixed table (only array part counts)
local t4 = {10, 20, 30, x = 100}
results[#results + 1] = "mixed=" .. #t4

-- Test 5: Table with nil at end
local t5 = {1, 2, nil}
results[#results + 1] = "nil_end=" .. #t5  -- Usually 2

-- Test 6: Growing table
local t6 = {}
for i = 1, 10 do
    t6[i] = i
end
results[#results + 1] = "grown=" .. #t6

-- Test 7: Shrinking by nil
local t7 = {1, 2, 3, 4, 5}
t7[5] = nil
t7[4] = nil
results[#results + 1] = "shrunk=" .. #t7

-- Test 8: Using # for appending
local t8 = {1, 2, 3}
t8[#t8 + 1] = 4
t8[#t8 + 1] = 5
results[#results + 1] = "append=" .. #t8

print(table.concat(results, ","))
-- Expected: simple=5,empty=0,hash=0,mixed=3,nil_end=2,grown=10,shrunk=3,append=5
