-- Test: Table sorting functions
local results = {}

-- Test 1: Basic sort
local t1 = {5, 2, 8, 1, 9, 3}
table.sort(t1)
results[#results + 1] = "basic=" .. table.concat(t1, ":")

-- Test 2: Reverse sort
local t2 = {5, 2, 8, 1, 9, 3}
table.sort(t2, function(a, b) return a > b end)
results[#results + 1] = "reverse=" .. table.concat(t2, ":")

-- Test 3: String sort
local t3 = {"banana", "apple", "cherry", "date"}
table.sort(t3)
results[#results + 1] = "strings=" .. t3[1] .. ":" .. t3[4]

-- Test 4: Sort with custom comparator
local t4 = {{name = "bob", age = 30}, {name = "alice", age = 25}, {name = "charlie", age = 35}}
table.sort(t4, function(a, b) return a.age < b.age end)
results[#results + 1] = "custom=" .. t4[1].name

-- Test 5: Sort stability test (same values)
local t5 = {3, 1, 4, 1, 5, 9, 2, 6}
table.sort(t5)
local sorted_str = table.concat(t5, "")
results[#results + 1] = "stable=" .. sorted_str

-- Test 6: Empty table sort
local t6 = {}
table.sort(t6)
results[#results + 1] = "empty=" .. #t6

-- Test 7: Single element
local t7 = {42}
table.sort(t7)
results[#results + 1] = "single=" .. t7[1]

-- Test 8: Already sorted
local t8 = {1, 2, 3, 4, 5}
table.sort(t8)
results[#results + 1] = "presort=" .. table.concat(t8, ":")

-- Test 9: Reverse sorted input
local t9 = {5, 4, 3, 2, 1}
table.sort(t9)
results[#results + 1] = "revsort=" .. table.concat(t9, ":")

-- Test 10: Large sort
local t10 = {}
for i = 100, 1, -1 do
    t10[#t10 + 1] = i
end
table.sort(t10)
results[#results + 1] = "large=" .. t10[1] .. ":" .. t10[100]

print(table.concat(results, ","))
-- Expected: basic=1:2:3:5:8:9,reverse=9:8:5:3:2:1,strings=apple:date,custom=alice,stable=11234569,empty=0,single=42,presort=1:2:3:4:5,revsort=1:2:3:4:5,large=1:100
