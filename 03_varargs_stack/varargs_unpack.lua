-- Test: table.unpack / unpack with varargs
local results = {}

-- Use the right unpack function
local unpack = table.unpack or unpack

-- Test 1: Basic unpack
local t = {1, 2, 3, 4, 5}
local a, b, c = unpack(t)
results[#results + 1] = "basic=" .. a .. ";" .. b .. ";" .. c

-- Test 2: Unpack with range
local x, y = unpack(t, 2, 4)
results[#results + 1] = "range=" .. x .. ";" .. y

-- Test 3: Unpack to varargs function
local function sum(...)
    local total = 0
    for i = 1, select("#", ...) do
        total = total + select(i, ...)
    end
    return total
end
results[#results + 1] = "to_vararg=" .. sum(unpack(t))

-- Test 4: Pack then unpack
local function roundTrip(...)
    local packed = {...}
    return unpack(packed)
end
local r1, r2, r3 = roundTrip(10, 20, 30)
results[#results + 1] = "roundtrip=" .. r1 .. ";" .. r2 .. ";" .. r3

-- Test 5: Unpack in table constructor
local source = {1, 2, 3}
local combined = {unpack(source)}  -- Note: only works as last element
results[#results + 1] = "construct=" .. #combined

-- Test 6: Unpack single element
local single = {42}
local v = unpack(single)
results[#results + 1] = "single=" .. v

-- Test 7: Unpack empty
local empty = {}
local e = unpack(empty)
results[#results + 1] = "empty=" .. tostring(e)

print(table.concat(results, ","))
-- Expected: basic=1;2;3,range=2;3,to_vararg=15,roundtrip=10;20;30,construct=3,single=42,empty=nil
