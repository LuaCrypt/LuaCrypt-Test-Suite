-- Test: Returning varargs
local results = {}

-- Test 1: Return all varargs
local function returnAll(...)
    return ...
end
local a, b, c = returnAll(1, 2, 3)
results[#results + 1] = "all=" .. a .. ";" .. b .. ";" .. c

-- Test 2: Return varargs with prepend
local function prepend(first, ...)
    return first, ...
end
local x, y, z = prepend(100, 200, 300)
results[#results + 1] = "prepend=" .. x .. ";" .. y .. ";" .. z

-- Test 3: Return varargs with append (only first of ... captured)
local function append(last, ...)
    return ..., last  -- WARNING: ... not at end, only first returned
end
local p, q = append("end", "a", "b", "c")
results[#results + 1] = "append=" .. p .. ";" .. q

-- Test 4: Return from multiple levels
local function level2(...)
    return ...
end
local function level1(...)
    return level2(...)
end
local r1, r2, r3 = level1(10, 20, 30)
results[#results + 1] = "levels=" .. r1 .. ";" .. r2 .. ";" .. r3

-- Test 5: Return with adjustment
local function adjust(...)
    local n = select("#", ...)
    if n > 2 then
        return select(1, ...), select(2, ...)  -- Only first two
    end
    return ...
end
local m, n, o = adjust(1, 2, 3, 4, 5)
results[#results + 1] = "adjust=" .. m .. ";" .. n .. ";" .. tostring(o)

-- Test 6: Return varargs from tail position
local function tailReturn(...)
    return (function(...) return ... end)(...)
end
local t1, t2, t3 = tailReturn("x", "y", "z")
results[#results + 1] = "tail=" .. t1 .. ";" .. t2 .. ";" .. t3

print(table.concat(results, ","))
-- Expected: all=1;2;3,prepend=100;200;300,append=a;end,levels=10;20;30,adjust=1;2;nil,tail=x;y;z
