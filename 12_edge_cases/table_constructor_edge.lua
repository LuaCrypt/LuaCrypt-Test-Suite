-- Edge cases for table constructors
-- Tests: SETLIST, varargs in tables, mixed array/hash, complex expressions

local results = {}
local unpack = unpack or table.unpack

-- Test 1: Basic array constructor
local t1 = {1, 2, 3}
results[#results + 1] = t1[1] + t1[2] + t1[3]  -- 6

-- Test 2: Mixed array and hash
local t2 = {10, 20, x = 30, 40}
results[#results + 1] = t2[1]   -- 10
results[#results + 1] = t2[2]   -- 20
results[#results + 1] = t2.x    -- 30
results[#results + 1] = t2[3]   -- 40

-- Test 3: Varargs at end of constructor
local function make_array(...)
    return {1, 2, ...}
end

local t3 = make_array(3, 4, 5)
results[#results + 1] = #t3  -- 5

-- Test 4: Varargs with nil values
local function vararg_nil(...)
    return {...}
end

local t4 = vararg_nil(1, nil, 3)
results[#results + 1] = (t4[1] or "nil")  -- 1
results[#results + 1] = (t4[2] == nil and "nil" or t4[2])  -- nil
results[#results + 1] = (t4[3] or "nil")  -- 3

-- Test 5: Function call at end expands
local function three()
    return "a", "b", "c"
end

local t5 = {"x", three()}
results[#results + 1] = #t5        -- 4
results[#results + 1] = t5[4]      -- c

-- Test 6: Parenthesized function call doesn't expand
local t6 = {"x", (three())}
results[#results + 1] = #t6  -- 2

-- Test 7: Nested table constructors
local t7 = {{1, 2}, {3, 4}}
results[#results + 1] = t7[1][1] + t7[2][2]  -- 5

-- Test 8: Computed keys
local key = "dynamic"
local t8 = {[key] = 100, ["literal"] = 200}
results[#results + 1] = t8.dynamic   -- 100
results[#results + 1] = t8.literal   -- 200

-- Test 9: Expression as key
local t9 = {[1 + 1] = "two", [3 * 1] = "three"}
results[#results + 1] = t9[2]  -- two
results[#results + 1] = t9[3]  -- three

-- Test 10: Large array (triggers SETLIST batching)
local t10 = {}
for i = 1, 100 do t10[i] = i end
local sum10 = 0
for i = 1, 100 do sum10 = sum10 + t10[i] end
results[#results + 1] = sum10  -- 5050

-- Test 11: Empty table
local t11 = {}
results[#results + 1] = (next(t11) == nil and "empty" or "not_empty")  -- empty

-- Test 12: Table with only hash part
local t12 = {a = 1, b = 2, c = 3}
results[#results + 1] = (t12[1] == nil and "nil" or t12[1])  -- nil

-- Test 13: Semicolon separator
local t13 = {1; 2; 3}
results[#results + 1] = t13[2]  -- 2

-- Test 14: Mixed separators
local t14 = {1, 2; 3, 4}
results[#results + 1] = t14[3]  -- 3

-- Test 15: Trailing comma
local t15 = {1, 2, 3,}
results[#results + 1] = #t15  -- 3

-- Test 16: Method in table
local t16 = {
    value = 10,
    get = function(self) return self.value end
}
results[#results + 1] = t16:get()  -- 10

-- Test 17: Self-referential (partial)
local t17 = {x = 5}
t17.y = t17.x + 1
results[#results + 1] = t17.y  -- 6

-- Test 18: Unpack in constructor
local source = {10, 20, 30}
local t18 = {unpack(source)}
results[#results + 1] = t18[2]  -- 20

-- Test 19: Boolean keys
local t19 = {[true] = "yes", [false] = "no"}
results[#results + 1] = t19[true]   -- yes
results[#results + 1] = t19[false]  -- no

-- Test 20: Nil value in hash (should not create entry)
local t20 = {a = nil, b = 2}
results[#results + 1] = (t20.a == nil and "nil" or "exists")  -- nil
results[#results + 1] = t20.b  -- 2

print(table.concat(results, ","))
-- Expected: 6,10,20,30,40,5,1,nil,3,4,c,2,5,100,200,two,three,5050,empty,nil,2,3,3,10,6,20,yes,no,nil,2
