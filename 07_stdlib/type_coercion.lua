-- Test: Type coercion behavior
local results = {}

-- Test 1: Number to string
local n1 = 42
results[#results + 1] = "num_str=" .. tostring(n1)

-- Test 2: String to number
local s2 = "123"
results[#results + 1] = "str_num=" .. (tonumber(s2) + 0)

-- Test 3: String with number ops
local s3 = "10"
results[#results + 1] = "str_add=" .. (s3 + 5)
results[#results + 1] = "str_mul=" .. (s3 * 2)

-- Test 4: Number concatenation
local n4 = 42
results[#results + 1] = "num_concat=" .. (n4 .. "!")

-- Test 5: tonumber with base
results[#results + 1] = "hex=" .. tonumber("ff", 16)
results[#results + 1] = "bin=" .. tonumber("1010", 2)
results[#results + 1] = "oct=" .. tonumber("77", 8)

-- Test 6: Invalid conversions
results[#results + 1] = "invalid=" .. tostring(tonumber("abc"))

-- Test 7: Float string
results[#results + 1] = "float=" .. tonumber("3.14")

-- Test 8: Scientific notation
results[#results + 1] = "sci=" .. tonumber("1e3")

-- Test 9: Whitespace handling
results[#results + 1] = "ws=" .. tonumber("  42  ")

-- Test 10: Negative numbers
results[#results + 1] = "neg=" .. tonumber("-123")

-- Test 11: Boolean coercion
results[#results + 1] = "bool_t=" .. tostring(true)
results[#results + 1] = "bool_f=" .. tostring(false)

-- Test 12: Nil coercion
results[#results + 1] = "nil=" .. tostring(nil)

-- Test 13: Table tostring
local t13 = {}
results[#results + 1] = "tbl=" .. (tostring(t13):sub(1,5) == "table" and "table" or "other")

-- Test 14: Function tostring
local f14 = function() end
results[#results + 1] = "func=" .. (tostring(f14):sub(1,8) == "function" and "function" or "other")

-- Test 15: Mixed arithmetic
local result15 = "5" + "3"
results[#results + 1] = "mixed=" .. result15

print(table.concat(results, ","))
-- Expected: num_str=42,str_num=123,str_add=15,str_mul=20,num_concat=42!,hex=255,bin=10,oct=63,invalid=nil,float=3.14,sci=1000,ws=42,neg=-123,bool_t=true,bool_f=false,nil=nil,tbl=table,func=function,mixed=8
