-- Test: Table operations (insert, remove, etc)
local results = {}

-- Test 1: table.insert at end
local t1 = {1, 2, 3}
table.insert(t1, 4)
results[#results + 1] = "insert_end=" .. table.concat(t1, ";")

-- Test 2: table.insert at position
local t2 = {1, 2, 3}
table.insert(t2, 2, 99)
results[#results + 1] = "insert_pos=" .. table.concat(t2, ";")

-- Test 3: table.remove from end
local t3 = {1, 2, 3}
local removed = table.remove(t3)
results[#results + 1] = "remove_end=" .. removed .. ":" .. table.concat(t3, ";")

-- Test 4: table.remove from position
local t4 = {1, 2, 3, 4}
local removed2 = table.remove(t4, 2)
results[#results + 1] = "remove_pos=" .. removed2 .. ":" .. table.concat(t4, ";")

-- Test 5: table.sort
local t5 = {5, 2, 8, 1, 9}
table.sort(t5)
results[#results + 1] = "sort=" .. table.concat(t5, ";")

-- Test 6: table.sort with comparator
local t6 = {5, 2, 8, 1, 9}
table.sort(t6, function(a, b) return a > b end)
results[#results + 1] = "sort_desc=" .. table.concat(t6, ";")

-- Test 7: table.concat with separator
local t7 = {"a", "b", "c"}
results[#results + 1] = "concat=" .. table.concat(t7, "-")

-- Test 8: table.concat with range
local t8 = {1, 2, 3, 4, 5}
results[#results + 1] = "concat_range=" .. table.concat(t8, ",", 2, 4)

print(table.concat(results, ","))
-- Expected: insert_end=1;2;3;4,insert_pos=1;99;2;3,remove_end=3:1;2,remove_pos=2:1;3;4,sort=1;2;5;8;9,sort_desc=9;8;5;2;1,concat=a-b-c,concat_range=2,3,4
