-- Test: Errors in metamethods
local results = {}

-- Test 1: Error in __index
local t1 = setmetatable({}, {
    __index = function()
        error("index error")
    end
})
local ok1, err1 = pcall(function()
    return t1.missing
end)
results[#results + 1] = "index=" .. tostring(ok1)

-- Test 2: Error in __newindex
local t2 = setmetatable({}, {
    __newindex = function()
        error("newindex error")
    end
})
local ok2, err2 = pcall(function()
    t2.new = "value"
end)
results[#results + 1] = "newindex=" .. tostring(ok2)

-- Test 3: Error in __add
local t3 = setmetatable({}, {
    __add = function()
        error("add error")
    end
})
local ok3, err3 = pcall(function()
    return t3 + 1
end)
results[#results + 1] = "add=" .. tostring(ok3)

-- Test 4: Error in __call
local t4 = setmetatable({}, {
    __call = function()
        error("call error")
    end
})
local ok4, err4 = pcall(function()
    return t4()
end)
results[#results + 1] = "call=" .. tostring(ok4)

-- Test 5: Error in __tostring
local t5 = setmetatable({}, {
    __tostring = function()
        error("tostring error")
    end
})
local ok5, err5 = pcall(function()
    return tostring(t5)
end)
results[#results + 1] = "tostring=" .. tostring(ok5)

-- Test 6: Error in __eq
local t6a = setmetatable({}, {
    __eq = function()
        error("eq error")
    end
})
local t6b = setmetatable({}, getmetatable(t6a))
local ok6, err6 = pcall(function()
    return t6a == t6b
end)
results[#results + 1] = "eq=" .. tostring(ok6)

print(table.concat(results, ","))
-- Expected: index=false,newindex=false,add=false,call=false,tostring=false,eq=false
