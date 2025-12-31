-- Test: __tostring metamethod
local results = {}

-- Test 1: Basic __tostring
local t1 = setmetatable({x = 10, y = 20}, {
    __tostring = function(t)
        return "Point(" .. t.x .. "," .. t.y .. ")"
    end
})
results[#results + 1] = "basic=" .. tostring(t1)

-- Test 2: __tostring with format
local t2 = setmetatable({name = "test", value = 42}, {
    __tostring = function(t)
        return string.format("%s=%d", t.name, t.value)
    end
})
results[#results + 1] = "format=" .. tostring(t2)

-- Test 3: No __tostring (default behavior)
local t3 = {a = 1}
local str3 = tostring(t3)
results[#results + 1] = "default=" .. (string.match(str3, "^table:") and "table_addr" or "other")

-- Test 4: __tostring returning non-string (error)
local t4 = setmetatable({}, {
    __tostring = function() return 123 end
})
local ok = pcall(function() return tostring(t4) end)
-- Behavior varies: Lua 5.2+ requires string return

-- Test 5: Recursive structure
local t5 = setmetatable({children = {}}, {
    __tostring = function(t)
        return "Node[" .. #t.children .. "]"
    end
})
t5.children[1] = t5  -- Self-reference
results[#results + 1] = "recursive=" .. tostring(t5)

-- Test 6: In concatenation
local t6 = setmetatable({v = "hello"}, {
    __tostring = function(t) return t.v end
})
results[#results + 1] = "concat=" .. ("Value: " .. tostring(t6))

print(table.concat(results, ","))
-- Expected: basic=Point(10,20),format=test=42,default=table_addr,recursive=Node[1],concat=Value: hello
