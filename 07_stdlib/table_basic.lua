-- Test: Table library functions
local results = {}

-- Test 1: concat
local t1 = {"a", "b", "c"}
results[#results + 1] = "concat=" .. table.concat(t1, ";")
results[#results + 1] = "concat_range=" .. table.concat(t1, ",", 2, 3)

-- Test 2: insert
local t2 = {1, 2, 3}
table.insert(t2, 4)
results[#results + 1] = "insert_end=" .. t2[4]
table.insert(t2, 1, 0)
results[#results + 1] = "insert_pos=" .. t2[1]

-- Test 3: remove
local t3 = {1, 2, 3, 4, 5}
local removed = table.remove(t3)
results[#results + 1] = "remove_end=" .. removed .. ":#" .. #t3
removed = table.remove(t3, 1)
results[#results + 1] = "remove_pos=" .. removed

-- Test 4: sort
local t4 = {3, 1, 4, 1, 5, 9}
table.sort(t4)
results[#results + 1] = "sort=" .. table.concat(t4, ";")

-- Test 5: sort with comparator
local t5 = {3, 1, 4, 1, 5, 9}
table.sort(t5, function(a, b) return a > b end)
results[#results + 1] = "sort_desc=" .. table.concat(t5, ";")

-- Test 6: sort strings
local t6 = {"banana", "apple", "cherry"}
table.sort(t6)
results[#results + 1] = "sort_str=" .. t6[1]

-- Test 7: pack/unpack (Lua 5.2+)
if table.pack then
    local packed = table.pack(1, 2, 3)
    results[#results + 1] = "pack_n=" .. packed.n
end
local unpack = table.unpack or unpack
local a, b, c = unpack({10, 20, 30})
results[#results + 1] = "unpack=" .. a .. ";" .. b .. ";" .. c

-- Test 8: move (Lua 5.3+)
if table.move then
    local t8 = {1, 2, 3, 4, 5}
    table.move(t8, 1, 3, 2)
    results[#results + 1] = "move=" .. table.concat(t8, ";", 1, 4)
end

print(table.concat(results, ","))
-- Expected: concat=a;b;c,concat_range=b,c,insert_end=4,insert_pos=0,remove_end=5:#4,remove_pos=1,sort=1;1;3;4;5;9,sort_desc=9;5;4;3;1;1,sort_str=apple,pack_n=3,unpack=10;20;30,move=1;1;2;3
