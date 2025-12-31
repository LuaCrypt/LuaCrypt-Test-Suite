-- Test: Nested function calls and stack
local results = {}

local function pair()
    return 10, 20
end

local function triple()
    return 1, 2, 3
end

-- Test 1: Nested call uses only first return
local function outer(x)
    return x * 2
end
results[#results + 1] = "nested=" .. outer(pair())

-- Test 2: Nested calls passing through
local function passThrough(...)
    return ...
end
local function wrapper(...)
    return passThrough(passThrough(...))
end
local a, b, c = wrapper(triple())
results[#results + 1] = "pass=" .. a .. ";" .. b .. ";" .. c

-- Test 3: Return of nested call
local function returnNested()
    return passThrough(triple())
end
local x, y, z = returnNested()
results[#results + 1] = "ret_nested=" .. x .. ";" .. y .. ";" .. z

-- Test 4: Deeply nested
local function deep()
    return passThrough(passThrough(passThrough(triple())))
end
local d1, d2, d3 = deep()
results[#results + 1] = "deep=" .. d1 .. ";" .. d2 .. ";" .. d3

-- Test 5: Mixed nesting
local function add(a, b)
    return (a or 0) + (b or 0)
end
results[#results + 1] = "mixed=" .. add(add(pair()), add(triple()))

-- Test 6: Call as table key/value
local t = {}
t[pair()] = triple()  -- t[10] = 1
results[#results + 1] = "tbl_kv=" .. t[10]

print(table.concat(results, ","))
-- Expected: nested=20,pass=1;2;3,ret_nested=1;2;3,deep=1;2;3,mixed=33,tbl_kv=1
