-- Test: Operator metamethods (__add, __sub, __mul, etc)
local results = {}

-- Create a vector class
local function makeVec(x, y)
    return setmetatable({x = x, y = y}, {
        __add = function(a, b)
            return makeVec(a.x + b.x, a.y + b.y)
        end,
        __sub = function(a, b)
            return makeVec(a.x - b.x, a.y - b.y)
        end,
        __mul = function(a, b)
            if type(a) == "number" then
                return makeVec(a * b.x, a * b.y)
            elseif type(b) == "number" then
                return makeVec(a.x * b, a.y * b)
            end
            return a.x * b.x + a.y * b.y  -- Dot product
        end,
        __div = function(a, b)
            return makeVec(a.x / b, a.y / b)
        end,
        __unm = function(a)
            return makeVec(-a.x, -a.y)
        end,
        __tostring = function(a)
            return "(" .. a.x .. "," .. a.y .. ")"
        end
    })
end

-- Test 1: __add
local v1 = makeVec(1, 2)
local v2 = makeVec(3, 4)
local v3 = v1 + v2
results[#results + 1] = "add=" .. v3.x .. ";" .. v3.y

-- Test 2: __sub
local v4 = v2 - v1
results[#results + 1] = "sub=" .. v4.x .. ";" .. v4.y

-- Test 3: __mul (with number)
local v5 = v1 * 3
results[#results + 1] = "mul=" .. v5.x .. ";" .. v5.y

-- Test 4: __div
local v6 = makeVec(10, 20) / 2
results[#results + 1] = "div=" .. v6.x .. ";" .. v6.y

-- Test 5: __unm (unary minus)
local v7 = -v1
results[#results + 1] = "unm=" .. v7.x .. ";" .. v7.y

-- Test 6: __tostring
results[#results + 1] = "tostr=" .. tostring(v1)

print(table.concat(results, ","))
-- Expected: add=4;6,sub=2;2,mul=3;6,div=5;10,unm=-1;-2,tostr=(1,2)
