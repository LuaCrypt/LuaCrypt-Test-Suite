-- Test: Table literal construction
local results = {}

-- Test 1: Empty table
local t1 = {}
results[#results + 1] = "empty=" .. type(t1) .. ":" .. #t1

-- Test 2: Array-style
local t2 = {1, 2, 3, 4, 5}
results[#results + 1] = "array=" .. #t2 .. ":" .. t2[3]

-- Test 3: Hash-style
local t3 = {a = 1, b = 2, c = 3}
results[#results + 1] = "hash=" .. t3.a .. ";" .. t3.b .. ";" .. t3.c

-- Test 4: Mixed array and hash
local t4 = {10, 20, x = 100, 30, y = 200}
results[#results + 1] = "mixed=" .. #t4 .. "_" .. t4[1] .. ";" .. t4[3] .. ";" .. t4.x

-- Test 5: Computed keys
local key = "dynamic"
local t5 = {[key] = 42, ["with space"] = 99, [1+1] = "two"}
results[#results + 1] = "computed=" .. t5.dynamic .. ";" .. t5["with space"] .. ";" .. t5[2]

-- Test 6: Trailing comma allowed
local t6 = {1, 2, 3,}
results[#results + 1] = "trailing=" .. #t6

print(table.concat(results, ","))
-- Expected: empty=table:0,array=5:3,hash=1;2;3,mixed=3_10;30;100,computed=42;99;two,trailing=3
