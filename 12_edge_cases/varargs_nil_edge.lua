-- Edge cases for varargs with nil values and table constructors
-- Tests fix for: SETLIST varargs nil handling

local results = {}
local unpack = unpack or table.unpack

-- Test 1: Varargs in table with nil in middle
local function make_table(...)
    return {...}
end

local t1 = make_table(1, nil, 3)
results[#results + 1] = (t1[1] or "nil")  -- 1
results[#results + 1] = (t1[2] == nil and "nil" or t1[2])  -- nil
results[#results + 1] = (t1[3] or "nil")  -- 3

-- Test 2: Varargs at end of table constructor
local function append_varargs(...)
    return {10, 20, ...}
end

local t2 = append_varargs(30, 40, 50)
results[#results + 1] = t2[1]  -- 10
results[#results + 1] = t2[2]  -- 20
results[#results + 1] = t2[3]  -- 30
results[#results + 1] = t2[4]  -- 40
results[#results + 1] = t2[5]  -- 50

-- Test 3: Empty varargs in table
local function empty_varargs(...)
    return {1, 2, ...}
end

local t3 = empty_varargs()
results[#results + 1] = #t3  -- 2

-- Test 4: Single nil vararg
local function single_nil(...)
    local t = {...}
    return select("#", ...)
end

results[#results + 1] = single_nil(nil)  -- 1

-- Test 5: Multiple nils in varargs
results[#results + 1] = single_nil(nil, nil, nil)  -- 3

-- Test 6: Mixed values with trailing nils
local function count_args(...)
    return select("#", ...)
end

results[#results + 1] = count_args(1, 2, nil)  -- 3
results[#results + 1] = count_args(1, nil, 3, nil)  -- 4

-- Test 7: Varargs forwarding
local function forward(...)
    return ...
end

local function receiver(...)
    local a, b, c = forward(...)
    return (a or "nil") .. "," .. (b or "nil") .. "," .. (c or "nil")
end

results[#results + 1] = receiver(1, nil, 3)  -- 1,nil,3

-- Test 8: Varargs in nested table
local function nested_table(...)
    return { inner = {...} }
end

local t4 = nested_table("a", "b", "c")
results[#results + 1] = t4.inner[2]  -- b

-- Test 9: Varargs with select
local function select_test(...)
    return select(2, ...)
end

local s1, s2 = select_test(10, 20, 30)
results[#results + 1] = s1  -- 20
results[#results + 1] = s2  -- 30

-- Test 10: Varargs table constructor with hash part
local function mixed_table(...)
    return { x = 100, ... }
end

local t5 = mixed_table("a", "b")
results[#results + 1] = t5.x   -- 100
results[#results + 1] = t5[1]  -- a
results[#results + 1] = t5[2]  -- b

-- Test 11: Varargs captured in closure
local function capture_varargs(...)
    local args = {...}
    return function(i)
        return args[i]
    end
end

local getter = capture_varargs(100, 200, 300)
results[#results + 1] = getter(2)  -- 200

-- Test 12: Varargs with explicit nil positions
local function explicit_nil_test(...)
    local t = {}
    for i = 1, select("#", ...) do
        local v = select(i, ...)
        t[i] = v == nil and "N" or v
    end
    return table.concat(t, ",")
end

results[#results + 1] = explicit_nil_test(1, nil, 2, nil, 3)  -- 1,N,2,N,3

-- Test 13: Returning varargs from nested calls
local function level2(...)
    return ...
end

local function level1(...)
    return level2(...)
end

local r1, r2, r3 = level1("x", "y", "z")
results[#results + 1] = r1 .. r2 .. r3  -- xyz

print(table.concat(results, ","))
-- Expected: 1,nil,3,10,20,30,40,50,2,1,3,3,4,1,nil,3,b,20,30,100,a,b,200,1,N,2,N,3,xyz
