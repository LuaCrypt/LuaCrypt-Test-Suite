-- Test: Passing varargs to function calls
local results = {}

-- Test 1: Direct pass to another function
local function receiver(a, b, c)
    return (a or 0) + (b or 0) + (c or 0)
end
local function sender(...)
    return receiver(...)
end
results[#results + 1] = "direct=" .. sender(10, 20, 30)

-- Test 2: Varargs with fixed args
local function mixedReceiver(x, y, ...)
    return x .. "," .. y .. ":" .. select("#", ...)
end
local function mixedSender(...)
    return mixedReceiver(...)
end
results[#results + 1] = "mixed=" .. mixedSender(1, 2, 3, 4, 5)

-- Test 3: Extra args ignored
results[#results + 1] = "extra=" .. receiver(1, 2, 3, 4, 5, 6)

-- Test 4: Missing args become nil
local function showNil(a, b, c)
    return tostring(a) .. "," .. tostring(b) .. "," .. tostring(c)
end
local function shortSend(...)
    return showNil(...)
end
results[#results + 1] = "missing=" .. shortSend(1)

-- Test 5: Varargs to method call
local obj = {
    sum = function(self, a, b, c)
        return (a or 0) + (b or 0) + (c or 0)
    end
}
local function callMethod(...)
    return obj:sum(...)
end
results[#results + 1] = "method=" .. callMethod(10, 20, 30)

-- Test 6: Varargs in nested call
local function nested(...)
    return receiver(receiver(...), receiver(...))
end
results[#results + 1] = "nested=" .. nested(1, 2, 3)

print(table.concat(results, ","))
-- Expected: direct=60,mixed=1,2:3,extra=6,missing=1,nil,nil,method=60,nested=12
