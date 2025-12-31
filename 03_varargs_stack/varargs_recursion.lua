-- Test: Varargs in recursive functions
local results = {}

-- Test 1: Simple recursive with varargs
local function sumRecursive(...)
    local n = select("#", ...)
    if n == 0 then return 0 end
    local first = select(1, ...)
    return first + sumRecursive(select(2, ...))
end
results[#results + 1] = "sum=" .. sumRecursive(1, 2, 3, 4, 5)

-- Test 2: Tail recursive with varargs
local function countDownVararg(acc, ...)
    local n = select("#", ...)
    if n == 0 then return acc end
    local first = select(1, ...)
    return countDownVararg(acc + first, select(2, ...))
end
results[#results + 1] = "tail=" .. countDownVararg(0, 10, 20, 30)

-- Test 3: Process each vararg recursively
local function processEach(processor, ...)
    local n = select("#", ...)
    if n == 0 then return "" end
    local first = processor(select(1, ...))
    local rest = processEach(processor, select(2, ...))
    if rest == "" then return first end
    return first .. ";" .. rest
end
results[#results + 1] = "process=" .. processEach(function(x) return x * 2 end, 1, 2, 3)

-- Test 4: Build result recursively
local function buildList(...)
    local n = select("#", ...)
    if n == 0 then return {} end
    local first = select(1, ...)
    local result = buildList(select(2, ...))
    table.insert(result, 1, first)
    return result
end
local built = buildList(1, 2, 3)
results[#results + 1] = "build=" .. table.concat(built, ";")

-- Test 5: Find in varargs
local function findValue(target, ...)
    local n = select("#", ...)
    if n == 0 then return -1 end
    if select(1, ...) == target then return 1 end
    local found = findValue(target, select(2, ...))
    if found == -1 then return -1 end
    return found + 1
end
results[#results + 1] = "find=" .. findValue(30, 10, 20, 30, 40)

print(table.concat(results, ","))
-- Expected: sum=15,tail=60,process=2;4;6,build=1;2;3,find=3
