-- Test: Operator semantics differences
local results = {}

-- Test 1: Division of integers
local div = 7 / 3
results[#results + 1] = "div=" .. string.format("%.4f", div)

-- Test 2: Integer division operator (5.3+)
local idiv_ok = pcall(function()
    local code = "return 7 // 3"
    return load(code)()
end)
if idiv_ok then
    results[#results + 1] = "idiv=2"
else
    results[#results + 1] = "idiv=nil"
end

-- Test 3: Modulo with negative numbers
results[#results + 1] = "mod_neg=" .. (-5 % 3)

-- Test 4: Power operator
results[#results + 1] = "pow=" .. (2 ^ 10)

-- Test 5: String comparison
local str_cmp = "abc" < "abd"
results[#results + 1] = "str_lt=" .. tostring(str_cmp)

-- Test 6: String concatenation coercion
local concat = 1 .. 2 .. 3
results[#results + 1] = "concat_num=" .. concat

-- Test 7: Length operator on string
local str_len = #"hello"
results[#results + 1] = "str_len=" .. str_len

-- Test 8: Length operator on table
local tbl_len = #{1, 2, 3, nil, 5}
results[#results + 1] = "tbl_len=" .. tbl_len

-- Test 9: Equality of different types
local eq_diff = (1 == "1")
results[#results + 1] = "eq_diff=" .. tostring(eq_diff)

-- Test 10: NaN comparison
local nan = 0/0
results[#results + 1] = "nan_eq=" .. tostring(nan == nan)
results[#results + 1] = "nan_lt=" .. tostring(nan < nan)

-- Test 11: Infinity
local inf = math.huge
results[#results + 1] = "inf_eq=" .. tostring(inf == inf)
results[#results + 1] = "inf_gt=" .. tostring(inf > 1e308)

-- Test 12: Boolean operations (and/or return values)
local and_result = 1 and 2
local or_result = false or 3
results[#results + 1] = "and=" .. and_result
results[#results + 1] = "or=" .. or_result

-- Test 13: not operator
results[#results + 1] = "not_nil=" .. tostring(not nil)
results[#results + 1] = "not_0=" .. tostring(not 0)

-- Test 14: Unary minus
results[#results + 1] = "unary=" .. (-(-5))

-- Test 15: Comparison chain (not allowed in Lua)
local chain_ok = pcall(function()
    local code = "return 1 < 2 < 3"
    return load(code)
end)
results[#results + 1] = "chain=" .. (chain_ok and "syntax" or "error")

print(table.concat(results, ","))
-- Expected: div=2.3333,idiv=2,mod_neg=1,pow=1024,str_lt=true,concat_num=123,str_len=5,tbl_len=3,eq_diff=false,nan_eq=false,nan_lt=false,inf_eq=true,inf_gt=true,and=2,or=3,not_nil=true,not_0=false,unary=5,chain=syntax
