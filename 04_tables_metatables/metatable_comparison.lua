-- Test: Comparison metamethods (__eq, __lt, __le)
local results = {}

local function makePair(a, b)
    return setmetatable({a = a, b = b}, {
        __eq = function(x, y)
            return x.a == y.a and x.b == y.b
        end,
        __lt = function(x, y)
            if x.a == y.a then
                return x.b < y.b
            end
            return x.a < y.a
        end,
        __le = function(x, y)
            return x == y or x < y
        end
    })
end

-- Test 1: __eq
local p1 = makePair(1, 2)
local p2 = makePair(1, 2)
local p3 = makePair(1, 3)
results[#results + 1] = "eq=" .. tostring(p1 == p2) .. ";" .. tostring(p1 == p3)

-- Test 2: __lt
results[#results + 1] = "lt=" .. tostring(p1 < p3) .. ";" .. tostring(p3 < p1)

-- Test 3: __le
results[#results + 1] = "le=" .. tostring(p1 <= p2) .. ";" .. tostring(p1 <= p3)

-- Test 4: Greater than (derived from __lt)
results[#results + 1] = "gt=" .. tostring(p3 > p1)

-- Test 5: Greater or equal (derived from __le)
results[#results + 1] = "ge=" .. tostring(p2 >= p1)

-- Test 6: __eq with same table (no metamethod needed)
results[#results + 1] = "same=" .. tostring(p1 == p1)

-- Test 7: __eq with different types (returns false without calling)
results[#results + 1] = "diff_type=" .. tostring(p1 == "string")

print(table.concat(results, ","))
-- Expected: eq=true;false,lt=true;false,le=true;true,gt=true,ge=true,same=true,diff_type=false
