-- Edge cases for complex expressions
-- Tests: operator precedence, short-circuit evaluation, chained operations

local results = {}

-- Test 1: Operator precedence
local a = 2 + 3 * 4
results[#results + 1] = a  -- 14

-- Test 2: Parentheses override precedence
local b = (2 + 3) * 4
results[#results + 1] = b  -- 20

-- Test 3: Power operator (right associative)
local c = 2 ^ 3 ^ 2
results[#results + 1] = c  -- 512 (2^9)

-- Test 4: Unary minus with power
local d = -2 ^ 2
results[#results + 1] = d  -- -4 (-(2^2))

-- Test 5: Concatenation precedence
local e = 1 + 2 .. 3 + 4
results[#results + 1] = e  -- "37"

-- Test 6: Short-circuit AND
local counter = 0
local function inc()
    counter = counter + 1
    return true
end

local f = false and inc()
results[#results + 1] = counter  -- 0 (inc not called)

-- Test 7: Short-circuit OR
counter = 0
local g = true or inc()
results[#results + 1] = counter  -- 0 (inc not called)

-- Test 8: AND returns first falsy or last value
local h = 1 and 2 and 3
results[#results + 1] = h  -- 3

local i = 1 and false and 3
results[#results + 1] = tostring(i)  -- false

-- Test 9: OR returns first truthy or last value
local j = false or nil or "x"
results[#results + 1] = j  -- x

local k = false or nil or false
results[#results + 1] = tostring(k)  -- false

-- Test 10: NOT operator
results[#results + 1] = tostring(not true)   -- false
results[#results + 1] = tostring(not false)  -- true
results[#results + 1] = tostring(not nil)    -- true
results[#results + 1] = tostring(not 0)      -- false (0 is truthy in Lua)

-- Test 11: Comparison chaining (left to right)
local l = 1 < 2
local m = (1 < 2) == true
results[#results + 1] = tostring(l)  -- true
results[#results + 1] = tostring(m)  -- true

-- Test 12: Length operator with expressions
local tbl = {1, 2, 3}
local n = #tbl + 1
results[#results + 1] = n  -- 4

-- Test 13: Nested function calls
local function double(x) return x * 2 end
local function add_one(x) return x + 1 end

local o = double(add_one(double(5)))  -- double(5)=10, add_one(10)=11, double(11)=22
results[#results + 1] = o  -- 22

-- Test 14: Method call chain
local obj = {
    val = 0,
    add = function(self, n)
        self.val = self.val + n
        return self
    end,
    mul = function(self, n)
        self.val = self.val * n
        return self
    end
}

obj:add(5):mul(2):add(3)
results[#results + 1] = obj.val  -- 13

-- Test 15: Index chain
local nested = {a = {b = {c = 42}}}
results[#results + 1] = nested.a.b.c  -- 42

-- Test 16: Mixed index styles
local mixed = {[1] = {x = 10}}
results[#results + 1] = mixed[1].x  -- 10

-- Test 17: Ternary pattern
local cond = true
local p = cond and "yes" or "no"
results[#results + 1] = p  -- yes

-- Test 18: Ternary with nil (trap case)
local q = true and nil or "default"
results[#results + 1] = q  -- default (nil is falsy, so OR kicks in)

-- Test 19: Complex boolean expression
local x, y, z = 1, 2, 3
local r = (x < y) and (y < z) and (x + y < z + 1)
results[#results + 1] = tostring(r)  -- true

-- Test 20: String comparison
local s = "apple" < "banana"
results[#results + 1] = tostring(s)  -- true

-- Test 21: Modulo with negative numbers
local mod1 = -7 % 3
local mod2 = 7 % -3
results[#results + 1] = mod1  -- 2 (Lua's modulo)

-- Test 22: Floor division (Lua 5.3+)
local div = 7 // 3
results[#results + 1] = div  -- 2

-- Test 23: Bitwise operations (Lua 5.3+)
local bw = 5 & 3
results[#results + 1] = bw  -- 1

local bw2 = 5 | 3
results[#results + 1] = bw2  -- 7

local bw3 = 5 ~ 3
results[#results + 1] = bw3  -- 6

-- Test 24: Shift operations
local sh1 = 1 << 4
results[#results + 1] = sh1  -- 16

local sh2 = 16 >> 2
results[#results + 1] = sh2  -- 4

-- Test 25: Bitwise NOT
local bnot = ~0
results[#results + 1] = bnot  -- -1

print(table.concat(results, ","))
-- Expected: 14,20,512,-4,37,0,0,3,false,x,false,false,true,true,false,true,true,4,22,13,42,10,yes,default,true,true,2,2,1,7,6,16,4,-1
