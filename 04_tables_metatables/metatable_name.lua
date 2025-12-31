-- Test: __name metamethod (Lua 5.3+)
local results = {}

-- Test 1: __name affects error messages
local t1 = setmetatable({}, {__name = "MyType"})
local ok, err = pcall(function()
    return t1 + 1  -- Should error since no __add
end)
if err then
    -- Check if error message contains "MyType"
    results[#results + 1] = "name_in_err=" .. (string.find(err, "MyType") and "yes" or "no")
else
    results[#results + 1] = "name_in_err=no_error"
end

-- Test 2: type() still returns "table"
results[#results + 1] = "type=" .. type(t1)

-- Test 3: __name with __tostring
local t3 = setmetatable({}, {
    __name = "Custom",
    __tostring = function() return "custom_obj" end
})
results[#results + 1] = "tostring=" .. tostring(t3)

-- Test 4: Default name for tables without __name
local t4 = setmetatable({}, {})
local ok4, err4 = pcall(function()
    return t4 + 1
end)
-- Error should mention "table"
if err4 then
    results[#results + 1] = "default_name=" .. (string.find(err4, "table") and "yes" or "no")
end

print(table.concat(results, ","))
-- Expected varies by Lua version
