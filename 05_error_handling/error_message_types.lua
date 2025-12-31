-- Test: Different error message types
local results = {}

-- Test 1: String message
local ok1, err1 = pcall(function()
    error("string message")
end)
results[#results + 1] = "string=" .. type(err1)

-- Test 2: Number message
local ok2, err2 = pcall(function()
    error(42)
end)
results[#results + 1] = "number=" .. type(err2)

-- Test 3: Table message (preserved)
local ok3, err3 = pcall(function()
    error({code = 500, msg = "internal error"})
end)
results[#results + 1] = "table=" .. type(err3)
if type(err3) == "table" then
    results[#results + 1] = "table_code=" .. err3.code
end

-- Test 4: Boolean message
local ok4, err4 = pcall(function()
    error(true)
end)
results[#results + 1] = "bool=" .. type(err4)

-- Test 5: Nil message (becomes "nil")
local ok5, err5 = pcall(function()
    error(nil)
end)
results[#results + 1] = "nil_msg=" .. type(err5)

-- Test 6: Function as message
local ok6, err6 = pcall(function()
    error(function() return "fn" end)
end)
results[#results + 1] = "func=" .. type(err6)

-- Test 7: Rethrow table error
local ok7, err7 = pcall(function()
    local ok, e = pcall(function()
        error({type = "custom"})
    end)
    if not ok then
        error(e)  -- Rethrow
    end
end)
results[#results + 1] = "rethrow=" .. (type(err7) == "table" and err7.type or "not_table")

print(table.concat(results, ","))
-- Expected: string=string,number=number,table=table,table_code=500,bool=boolean,nil_msg=string,func=function,rethrow=custom
