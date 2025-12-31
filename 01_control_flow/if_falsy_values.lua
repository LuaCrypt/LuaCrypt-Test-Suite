-- Test: Falsy/truthy value handling in conditions
local results = {}

-- In Lua, only nil and false are falsy

-- Test 1: nil is falsy
local v = nil
if v then
    results[#results + 1] = "nil_truthy"
else
    results[#results + 1] = "nil_falsy"
end

-- Test 2: false is falsy
v = false
if v then
    results[#results + 1] = "false_truthy"
else
    results[#results + 1] = "false_falsy"
end

-- Test 3: 0 is truthy (unlike C/JS)
v = 0
if v then
    results[#results + 1] = "zero_truthy"
else
    results[#results + 1] = "zero_falsy"
end

-- Test 4: Empty string is truthy
v = ""
if v then
    results[#results + 1] = "empty_str_truthy"
else
    results[#results + 1] = "empty_str_falsy"
end

-- Test 5: Empty table is truthy
v = {}
if v then
    results[#results + 1] = "empty_tbl_truthy"
else
    results[#results + 1] = "empty_tbl_falsy"
end

-- Test 6: Function is truthy
v = function() end
if v then
    results[#results + 1] = "func_truthy"
else
    results[#results + 1] = "func_falsy"
end

print(table.concat(results, ","))
-- Expected: nil_falsy,false_falsy,zero_truthy,empty_str_truthy,empty_tbl_truthy,func_truthy
