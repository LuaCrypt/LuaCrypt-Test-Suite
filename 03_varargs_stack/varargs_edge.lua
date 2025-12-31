-- Test: Edge cases for varargs
local results = {}

-- Test 1: Very large number of varargs
local function countMany(...)
    return select("#", ...)
end
local many = {}
for i = 1, 100 do many[i] = i end
local unpack = table.unpack or unpack
results[#results + 1] = "many=" .. countMany(unpack(many))

-- Test 2: Varargs with all same type
local function allStrings(...)
    local t = {...}
    return table.concat(t, "-")
end
results[#results + 1] = "strings=" .. allStrings("a", "b", "c", "d")

-- Test 3: Varargs with function values
local function callAll(...)
    local result = 0
    for i = 1, select("#", ...) do
        local fn = select(i, ...)
        result = result + fn()
    end
    return result
end
results[#results + 1] = "funcs=" .. callAll(
    function() return 1 end,
    function() return 2 end,
    function() return 3 end
)

-- Test 4: Varargs in conditional
local function conditionalVarargs(cond, ...)
    if cond then
        return ...
    else
        return select("#", ...)
    end
end
local a, b = conditionalVarargs(true, 10, 20)
results[#results + 1] = "cond_true=" .. a .. ";" .. b
results[#results + 1] = "cond_false=" .. conditionalVarargs(false, 10, 20)

-- Test 5: Modify table created from varargs
local function modifyPackedArgs(...)
    local t = {...}
    t[1] = t[1] * 100
    return unpack(t)
end
local m1, m2, m3 = modifyPackedArgs(1, 2, 3)
results[#results + 1] = "modified=" .. m1 .. ";" .. m2 .. ";" .. m3

-- Test 6: Empty varargs in comparison
local function compareEmpty(...)
    local n = select("#", ...)
    return n == 0
end
results[#results + 1] = "empty_cmp=" .. tostring(compareEmpty())

print(table.concat(results, ","))
-- Expected: many=100,strings=a-b-c-d,funcs=6,cond_true=10;20,cond_false=2,modified=100;2;3,empty_cmp=true
