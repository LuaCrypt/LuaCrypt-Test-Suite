-- Test: select() with varargs
local results = {}

-- Test 1: select("#", ...) - count
local function countArgs(...)
    return select("#", ...)
end
results[#results + 1] = "count0=" .. countArgs()
results[#results + 1] = "count3=" .. countArgs(1, 2, 3)
results[#results + 1] = "count5=" .. countArgs("a", "b", "c", "d", "e")

-- Test 2: select(n, ...) - get from index
local function getFrom(n, ...)
    return select(n, ...)
end
local a, b, c = getFrom(2, 10, 20, 30, 40, 50)
results[#results + 1] = "from2=" .. a .. ";" .. b .. ";" .. c

-- Test 3: select with negative index
local function getLast(...)
    return select(-1, ...)  -- Last element
end
results[#results + 1] = "last=" .. getLast(1, 2, 3, 4, 5)

-- Test 4: select(-2) - last two
local function getLastTwo(...)
    local a, b = select(-2, ...)
    return a, b
end
local x, y = getLastTwo(10, 20, 30, 40, 50)
results[#results + 1] = "last2=" .. x .. ";" .. y

-- Test 5: Using select in loop
local function sumAll(...)
    local sum = 0
    for i = 1, select("#", ...) do
        sum = sum + select(i, ...)
    end
    return sum
end
results[#results + 1] = "sum=" .. sumAll(1, 2, 3, 4, 5)

-- Test 6: select with nil values (important!)
local function countWithNils(...)
    return select("#", ...)
end
results[#results + 1] = "nils=" .. countWithNils(1, nil, 3, nil, 5)

print(table.concat(results, ","))
-- Expected: count0=0,count3=3,count5=5,from2=20;30;40,last=5,last2=40;50,sum=15,nils=5
