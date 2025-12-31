-- Test: Varargs captured in closures
local results = {}

-- Test 1: Cannot directly capture ... in closure (need to unpack first)
local function makeVarargGetter(...)
    local args = {...}
    return function()
        return table.concat(args, ";")
    end
end
local getter = makeVarargGetter(1, 2, 3)
results[#results + 1] = "closure=" .. getter()

-- Test 2: Closure with count
local function makeCounter(...)
    local count = select("#", ...)
    return function()
        return count
    end
end
local counter = makeCounter(1, 2, 3, 4, 5)
results[#results + 1] = "count_closure=" .. counter()

-- Test 3: Multiple closures from varargs
local function makeAccessors(...)
    local args = {...}
    local n = select("#", ...)
    return function(i)
        return args[i]
    end, function()
        return n
    end
end
local get, len = makeAccessors("a", "b", "c")
results[#results + 1] = "accessor=" .. get(2) .. "_len=" .. len()

-- Test 4: Closure modifying captured varargs table
local function makeModifier(...)
    local args = {...}
    return function(i, v)
        args[i] = v
    end, function()
        return table.concat(args, ";")
    end
end
local setAt, getAll = makeModifier(1, 2, 3)
setAt(2, 100)
results[#results + 1] = "modified=" .. getAll()

-- Test 5: Varargs in nested closure
local function outer(...)
    local outerArgs = {...}
    return function(...)
        local innerArgs = {...}
        return #outerArgs .. ":" .. #innerArgs
    end
end
local inner = outer(1, 2, 3)
results[#results + 1] = "nested=" .. inner(4, 5)

print(table.concat(results, ","))
-- Expected: closure=1;2;3,count_closure=5,accessor=b_len=3,modified=1;100;3,nested=3:2
