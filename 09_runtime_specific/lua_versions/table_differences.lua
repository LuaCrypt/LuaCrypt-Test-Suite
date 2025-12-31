-- Test: Table library differences across Lua versions
local results = {}

-- Test 1: table.pack (5.2+)
if table.pack then
    local t = table.pack(1, nil, 3)
    results[#results + 1] = "pack=" .. t.n
else
    results[#results + 1] = "pack=nil"
end

-- Test 2: table.unpack vs unpack
local unpack_fn = table.unpack or unpack
local a, b, c = unpack_fn({1, 2, 3})
results[#results + 1] = "unpack=" .. (a + b + c)

-- Test 3: table.move (5.3+)
if table.move then
    local t = {1, 2, 3, 0, 0}
    table.move(t, 1, 3, 4)
    results[#results + 1] = "move=" .. t[5]
else
    results[#results + 1] = "move=nil"
end

-- Test 4: table.maxn (removed in 5.2+)
if table.maxn then
    local t = {}
    t[100] = true
    results[#results + 1] = "maxn=" .. table.maxn(t)
else
    results[#results + 1] = "maxn=nil"
end

-- Test 5: # operator on sparse tables
local sparse = {}
sparse[1] = "a"
sparse[2] = "b"
sparse[100] = "c"
results[#results + 1] = "sparse_len=" .. #sparse

-- Test 6: table.insert at end
local t6 = {1, 2, 3}
table.insert(t6, 4)
results[#results + 1] = "insert_end=" .. t6[4]

-- Test 7: table.insert at start
local t7 = {2, 3, 4}
table.insert(t7, 1, 1)
results[#results + 1] = "insert_start=" .. t7[1]

-- Test 8: table.remove
local t8 = {1, 2, 3, 4}
local removed = table.remove(t8, 2)
results[#results + 1] = "remove=" .. removed .. ":" .. #t8

-- Test 9: table.sort stability
local t9 = {{k = "a", v = 1}, {k = "b", v = 2}, {k = "a", v = 3}}
table.sort(t9, function(x, y) return x.k < y.k end)
-- Check if same-key elements maintain relative order
results[#results + 1] = "sort=" .. t9[1].v .. ":" .. t9[2].v

-- Test 10: table.concat with non-string
local t10 = {1, 2, 3}
local concat = table.concat(t10, ",")
results[#results + 1] = "concat_num=" .. concat

-- Test 11: __len metamethod (5.2+)
local mt = {__len = function() return 99 end}
local t11 = setmetatable({1, 2, 3}, mt)
results[#results + 1] = "len_mt=" .. #t11

-- Test 12: rawlen (5.2+)
if rawlen then
    results[#results + 1] = "rawlen=" .. rawlen(t11)
else
    results[#results + 1] = "rawlen=nil"
end

-- Test 13: Next on empty table
local empty = {}
results[#results + 1] = "next_empty=" .. tostring(next(empty))

-- Test 14: pairs/ipairs return values
local pk, pv = pairs({a = 1})
results[#results + 1] = "pairs_type=" .. type(pk)

print(table.concat(results, ","))
-- Expected varies by Lua version
