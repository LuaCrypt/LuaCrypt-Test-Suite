-- Test: Varargs in main chunk (...)
-- The main chunk receives command-line args as ...

local results = {}

-- Test 1: Access main chunk varargs (may be empty in test)
local args = {...}
results[#results + 1] = "main_args=" .. #args

-- Test 2: Can still define varargs functions
local function varfunc(...)
    return select("#", ...)
end
results[#results + 1] = "nested_varargs=" .. varfunc(1, 2, 3)

-- Test 3: Forward main args to function
local function processArgs(...)
    local n = select("#", ...)
    if n == 0 then return "no_args" end
    return "has_args"
end
results[#results + 1] = "process=" .. processArgs(...)

-- Test 4: Pack main args
local packed = {...}
results[#results + 1] = "packed_type=" .. type(packed)

-- Test 5: Main args in closure
local function getMainArgCount()
    return #args  -- Captured from outer scope
end
results[#results + 1] = "closure_count=" .. getMainArgCount()

-- Test 6: Combine main args with local
local function combine(extra, ...)
    local main = {...}
    return extra .. ":" .. #main
end
results[#results + 1] = "combine=" .. combine("prefix", ...)

print(table.concat(results, ","))
-- Expected (no args): main_args=0,nested_varargs=3,process=no_args,packed_type=table,closure_count=0,combine=prefix:0
