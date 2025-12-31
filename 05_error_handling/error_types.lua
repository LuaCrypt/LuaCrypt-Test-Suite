-- Test: Different types of errors
local results = {}

-- Test 1: Nil index error
local ok1, err1 = pcall(function()
    local t = nil
    return t.field
end)
results[#results + 1] = "nil_idx=" .. tostring(ok1)

-- Test 2: Arithmetic on nil
local ok2, err2 = pcall(function()
    local x = nil
    return x + 1
end)
results[#results + 1] = "nil_arith=" .. tostring(ok2)

-- Test 3: Call non-function
local ok3, err3 = pcall(function()
    local x = 5
    return x()
end)
results[#results + 1] = "call_num=" .. tostring(ok3)

-- Test 4: Stack overflow (limited iterations)
local count = 0
local function recurse()
    count = count + 1
    if count > 10000 then return end  -- Safety limit for test
    return recurse()
end
local ok4, err4 = pcall(recurse)
results[#results + 1] = "recurse=" .. (count > 100 and "deep" or "shallow")

-- Test 5: String to number in arithmetic
local ok5, result5 = pcall(function()
    return "10" + 5  -- Lua coerces this
end)
results[#results + 1] = "str_coerce=" .. tostring(ok5)

-- Test 6: Invalid string to number
local ok6, err6 = pcall(function()
    return "hello" + 5
end)
results[#results + 1] = "bad_coerce=" .. tostring(ok6)

-- Test 7: Table concat without tostring
local ok7, err7 = pcall(function()
    return "prefix" .. {}
end)
results[#results + 1] = "tbl_concat=" .. tostring(ok7)

print(table.concat(results, ","))
-- Expected: nil_idx=false,nil_arith=false,call_num=false,recurse=deep,str_coerce=true,bad_coerce=false,tbl_concat=false
