-- Test: Mixed fixed arguments and varargs
local results = {}

-- Test 1: Fixed + varargs
local function mixed(a, b, ...)
    return a .. "+" .. b .. ":" .. select("#", ...)
end
results[#results + 1] = "mixed=" .. mixed(1, 2, 3, 4, 5)

-- Test 2: Fixed args filled, varargs empty
results[#results + 1] = "no_extra=" .. mixed(1, 2)

-- Test 3: Not enough for fixed (varargs empty, fixed gets nil)
local function safeFixed(a, b, ...)
    a = a or "nil"
    b = b or "nil"
    return tostring(a) .. "," .. tostring(b) .. ":" .. select("#", ...)
end
results[#results + 1] = "partial=" .. safeFixed(1)

-- Test 4: Multiple fixed before varargs
local function manyFixed(a, b, c, d, e, ...)
    local sum = (a or 0) + (b or 0) + (c or 0) + (d or 0) + (e or 0)
    return sum .. ":" .. select("#", ...)
end
results[#results + 1] = "many=" .. manyFixed(1, 2, 3, 4, 5, 6, 7)

-- Test 5: Fixed args with explicit nil in varargs
local function handleNil(first, ...)
    local count = select("#", ...)
    local collected = {}
    for i = 1, count do
        collected[i] = tostring((select(i, ...)))
    end
    return first .. ":" .. table.concat(collected, ";")
end
results[#results + 1] = "explicit_nil=" .. handleNil("start", 1, nil, 3)

-- Test 6: Default values pattern with varargs
local function withDefaults(name, ...)
    name = name or "default"
    local options = {...}
    return name .. ":" .. #options
end
results[#results + 1] = "defaults=" .. withDefaults() .. "_" .. withDefaults("custom", 1, 2)

print(table.concat(results, ","))
-- Expected: mixed=1+2:3,no_extra=1+2:0,partial=1,nil:0,many=15:2,explicit_nil=start:1;nil;3,defaults=default:0_custom:2
