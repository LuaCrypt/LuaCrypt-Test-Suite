-- Test: Varargs forwarding through function chains
local results = {}

-- Test 1: Simple forward
local function inner(...)
    local t = {...}
    return table.concat(t, ";")
end
local function outer(...)
    return inner(...)
end
results[#results + 1] = "simple=" .. outer(1, 2, 3)

-- Test 2: Two-level forward
local function level3(...)
    return select("#", ...)
end
local function level2(...)
    return level3(...)
end
local function level1(...)
    return level2(...)
end
results[#results + 1] = "chain=" .. level1(1, 2, 3, 4, 5)

-- Test 3: Forward with modification
local function addAndForward(first, ...)
    return first + 100, ...
end
local a, b, c = addAndForward(1, 2, 3)
results[#results + 1] = "modify=" .. a .. ";" .. b .. ";" .. c

-- Test 4: Forward only varargs (not fixed params)
local function takeFirst(first, ...)
    return ...
end
local x, y = takeFirst(100, 200, 300)
results[#results + 1] = "skip_first=" .. x .. ";" .. y

-- Test 5: Nested forward
local function nest(...)
    return (function(...)
        return (function(...)
            return ...
        end)(...)
    end)(...)
end
local r1, r2, r3 = nest("a", "b", "c")
results[#results + 1] = "nested=" .. r1 .. ";" .. r2 .. ";" .. r3

-- Test 6: Forward and collect
local function forwardAndCount(...)
    local count = select("#", ...)
    return count, ...
end
local n, v1, v2 = forwardAndCount(10, 20)
results[#results + 1] = "count_and_fwd=" .. n .. ":" .. v1 .. ";" .. v2

print(table.concat(results, ","))
-- Expected: simple=1;2;3,chain=5,modify=101;2;3,skip_first=200;300,nested=a;b;c,count_and_fwd=2:10;20
