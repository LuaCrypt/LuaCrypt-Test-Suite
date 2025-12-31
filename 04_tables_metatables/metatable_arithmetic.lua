-- Test: All arithmetic metamethods
local results = {}

local function makeNum(n)
    return setmetatable({n = n}, {
        __add = function(a, b)
            local va = type(a) == "table" and a.n or a
            local vb = type(b) == "table" and b.n or b
            return makeNum(va + vb)
        end,
        __sub = function(a, b)
            local va = type(a) == "table" and a.n or a
            local vb = type(b) == "table" and b.n or b
            return makeNum(va - vb)
        end,
        __mul = function(a, b)
            local va = type(a) == "table" and a.n or a
            local vb = type(b) == "table" and b.n or b
            return makeNum(va * vb)
        end,
        __div = function(a, b)
            local va = type(a) == "table" and a.n or a
            local vb = type(b) == "table" and b.n or b
            return makeNum(va / vb)
        end,
        __mod = function(a, b)
            local va = type(a) == "table" and a.n or a
            local vb = type(b) == "table" and b.n or b
            return makeNum(va % vb)
        end,
        __pow = function(a, b)
            local va = type(a) == "table" and a.n or a
            local vb = type(b) == "table" and b.n or b
            return makeNum(va ^ vb)
        end,
        __unm = function(a)
            return makeNum(-a.n)
        end
    })
end

local n1 = makeNum(10)
local n2 = makeNum(3)

-- Test 1: Addition
results[#results + 1] = "add=" .. (n1 + n2).n

-- Test 2: Subtraction
results[#results + 1] = "sub=" .. (n1 - n2).n

-- Test 3: Multiplication
results[#results + 1] = "mul=" .. (n1 * n2).n

-- Test 4: Division
results[#results + 1] = "div=" .. (n1 / n2).n

-- Test 5: Modulo
results[#results + 1] = "mod=" .. (n1 % n2).n

-- Test 6: Power
results[#results + 1] = "pow=" .. (n2 ^ 2).n

-- Test 7: Unary minus
results[#results + 1] = "unm=" .. (-n1).n

-- Test 8: With regular number
results[#results + 1] = "with_num=" .. (n1 + 5).n

-- Test 9: Chained operations
local result = (n1 + n2) * makeNum(2)
results[#results + 1] = "chain=" .. result.n

print(table.concat(results, ","))
-- Expected: add=13,sub=7,mul=30,div=3.3333...,mod=1,pow=9,unm=-10,with_num=15,chain=26
