-- Test: Table concat function
local results = {}

-- Test 1: Basic concat
local t1 = {"a", "b", "c"}
results[#results + 1] = "basic=" .. table.concat(t1)

-- Test 2: Concat with separator
local t2 = {"a", "b", "c"}
results[#results + 1] = "sep=" .. table.concat(t2, "-")

-- Test 3: Concat with range
local t3 = {"a", "b", "c", "d", "e"}
results[#results + 1] = "range=" .. table.concat(t3, ",", 2, 4)

-- Test 4: Numbers
local t4 = {1, 2, 3, 4, 5}
results[#results + 1] = "nums=" .. table.concat(t4, "+")

-- Test 5: Empty table
local t5 = {}
results[#results + 1] = "empty=" .. (table.concat(t5) == "" and "yes" or "no")

-- Test 6: Single element
local t6 = {"only"}
results[#results + 1] = "single=" .. table.concat(t6, ",")

-- Test 7: Empty separator
local t7 = {"a", "b", "c"}
results[#results + 1] = "nosep=" .. table.concat(t7, "")

-- Test 8: Multi-char separator
local t8 = {"a", "b", "c"}
results[#results + 1] = "multi=" .. table.concat(t8, "---")

-- Test 9: Mixed numbers and numeric strings
local t9 = {1, "2", 3, "4"}
results[#results + 1] = "mixed=" .. table.concat(t9, ":")

-- Test 10: Large table
local t10 = {}
for i = 1, 100 do
    t10[i] = i
end
results[#results + 1] = "large_len=" .. #table.concat(t10, ",")

-- Test 11: Start index only (to end)
local t11 = {"a", "b", "c", "d", "e"}
results[#results + 1] = "start=" .. table.concat(t11, ",", 3)

-- Test 12: Empty result range
local t12 = {"a", "b", "c"}
results[#results + 1] = "empty_range=" .. (table.concat(t12, ",", 2, 1) == "" and "yes" or "no")

print(table.concat(results, ","))
-- Expected: basic=abc,sep=a-b-c,range=b,c,d,nums=1+2+3+4+5,empty=yes,single=only,nosep=abc,multi=a---b---c,mixed=1:2:3:4,large_len=291,start=c,d,e,empty_range=yes
