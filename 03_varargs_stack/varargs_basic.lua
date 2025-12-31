-- Test: Basic varargs behavior
local results = {}

-- Test 1: Simple varargs
local function simple(...)
    local args = {...}
    return #args
end
results[#results + 1] = "count=" .. simple(1, 2, 3, 4, 5)

-- Test 2: Varargs to table
local function toTable(...)
    return {...}
end
local t = toTable("a", "b", "c")
results[#results + 1] = "table=" .. table.concat(t, ";")

-- Test 3: No arguments
results[#results + 1] = "empty=" .. simple()

-- Test 4: Single argument
results[#results + 1] = "single=" .. simple("only")

-- Test 5: Mixed types
local function mixedTypes(...)
    local types = {}
    for i, v in ipairs({...}) do
        types[i] = type(v)
    end
    return table.concat(types, ";")
end
results[#results + 1] = "mixed=" .. mixedTypes(1, "str", true, {}, function() end)

-- Test 6: Return varargs directly
local function passThrough(...)
    return ...
end
local a, b, c = passThrough(10, 20, 30)
results[#results + 1] = "pass=" .. a .. ";" .. b .. ";" .. c

print(table.concat(results, ","))
-- Expected: count=5,table=a;b;c,empty=0,single=1,mixed=number;string;boolean;table;function,pass=10;20;30
