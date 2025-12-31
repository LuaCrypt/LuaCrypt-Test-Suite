-- Test: table.pack and table.unpack
local results = {}

-- Use correct function names based on version
local pack = table.pack or function(...)
    return {n = select("#", ...), ...}
end
local unpack = table.unpack or unpack

-- Test 1: Basic pack
local t1 = pack(1, 2, 3, 4, 5)
results[#results + 1] = "pack=" .. (t1.n or #t1) .. ":" .. t1[3]

-- Test 2: Pack with nils
local t2 = pack(1, nil, 3, nil, 5)
results[#results + 1] = "pack_nil=" .. (t2.n or #t2)

-- Test 3: Basic unpack
local t3 = {10, 20, 30}
local a, b, c = unpack(t3)
results[#results + 1] = "unpack=" .. a .. ";" .. b .. ";" .. c

-- Test 4: Unpack with range
local t4 = {1, 2, 3, 4, 5}
local x, y = unpack(t4, 2, 4)
results[#results + 1] = "unpack_range=" .. x .. ";" .. y

-- Test 5: Pack then unpack
local original = {100, 200, 300}
local packed = pack(unpack(original))
results[#results + 1] = "roundtrip=" .. packed[1] .. ";" .. packed[3]

-- Test 6: Unpack in function call
local function sum3(a, b, c)
    return a + b + c
end
local args = {10, 20, 30}
results[#results + 1] = "call=" .. sum3(unpack(args))

-- Test 7: Partial unpack
local t7 = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
local first3 = {unpack(t7, 1, 3)}
results[#results + 1] = "partial=" .. #first3

print(table.concat(results, ","))
-- Expected: pack=5:3,pack_nil=5,unpack=10;20;30,unpack_range=2;3,roundtrip=100;300,call=60,partial=3
