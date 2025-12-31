-- Test: Basic error() function
local results = {}

-- Test 1: Simple error (caught by pcall)
local ok1, err1 = pcall(function()
    error("simple error")
end)
results[#results + 1] = "simple=" .. tostring(ok1)

-- Test 2: Error with level 0 (no location)
local ok2, err2 = pcall(function()
    error("no location", 0)
end)
results[#results + 1] = "level0=" .. (string.find(err2, ":") and "has_loc" or "no_loc")

-- Test 3: Error with level 1 (default)
local ok3, err3 = pcall(function()
    error("level 1", 1)
end)
results[#results + 1] = "level1=" .. (string.find(err3, ":") and "has_loc" or "no_loc")

-- Test 4: Error with table message
local ok4, err4 = pcall(function()
    error({code = 42, msg = "structured"})
end)
results[#results + 1] = "table_err=" .. type(err4)

-- Test 5: Error with nil (becomes "nil" string)
local ok5, err5 = pcall(function()
    error(nil)
end)
results[#results + 1] = "nil_err=" .. tostring(ok5)

-- Test 6: Nested function error
local function inner()
    error("from inner")
end
local function outer()
    inner()
end
local ok6, err6 = pcall(outer)
results[#results + 1] = "nested=" .. (string.find(err6, "inner") and "found" or "not_found")

print(table.concat(results, ","))
-- Expected: simple=false,level0=no_loc,level1=has_loc,table_err=table,nil_err=false,nested=found
