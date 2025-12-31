-- Test: Luau table extensions
local results = {}

-- Test 1: table.create (Luau)
if table.create then
    local t = table.create(10, 0)
    results[#results + 1] = "create=" .. #t
else
    results[#results + 1] = "create=nil"
end

-- Test 2: table.find (Luau)
if table.find then
    local t = {"a", "b", "c", "d"}
    local idx = table.find(t, "c")
    results[#results + 1] = "find=" .. (idx or "nil")
else
    results[#results + 1] = "find=nil"
end

-- Test 3: table.clear (also in LuaJIT)
if table.clear then
    local t = {1, 2, 3, a = 1}
    table.clear(t)
    local count = 0
    for _ in pairs(t) do count = count + 1 end
    results[#results + 1] = "clear=" .. count
else
    results[#results + 1] = "clear=nil"
end

-- Test 4: table.move
if table.move then
    local t = {1, 2, 3, 4, 5}
    table.move(t, 1, 3, 4)  -- copy [1,2,3] to positions [4,5,6]
    results[#results + 1] = "move=" .. (t[4] == 1 and t[5] == 2 and "works" or "fail")
else
    results[#results + 1] = "move=nil"
end

-- Test 5: Frozen table behavior
if table.freeze then
    local t = {x = 1, y = 2}
    local mt = {__index = {z = 3}}
    setmetatable(t, mt)
    table.freeze(t)
    -- Reading should work
    results[#results + 1] = "frozen_read=" .. t.x
    -- Metatable lookup should work
    results[#results + 1] = "frozen_mt=" .. t.z
else
    results[#results + 1] = "frozen_read=nil"
    results[#results + 1] = "frozen_mt=nil"
end

-- Test 6: Deep freeze pattern
if table.freeze then
    local function deep_freeze(t)
        table.freeze(t)
        for k, v in pairs(t) do
            if type(v) == "table" then
                deep_freeze(v)
            end
        end
        return t
    end
    local nested = {a = {b = {c = 1}}}
    deep_freeze(nested)
    local ok = pcall(function() nested.a.b.c = 2 end)
    results[#results + 1] = "deep_freeze=" .. (ok and "mutable" or "frozen")
else
    results[#results + 1] = "deep_freeze=nil"
end

-- Test 7: table.clone shallow copy behavior
if table.clone then
    local inner = {x = 1}
    local t = {inner = inner}
    local clone = table.clone(t)
    results[#results + 1] = "clone_shallow=" .. (clone.inner == inner and "same" or "different")
else
    results[#results + 1] = "clone_shallow=nil"
end

-- Test 8: Clone preserves metatable
if table.clone then
    local mt = {__index = {default = 99}}
    local t = setmetatable({a = 1}, mt)
    local clone = table.clone(t)
    results[#results + 1] = "clone_mt=" .. (clone.default == 99 and "preserved" or "lost")
else
    results[#results + 1] = "clone_mt=nil"
end

-- Test 9: table.getn (deprecated but may exist)
if table.getn then
    local t = {1, 2, 3}
    results[#results + 1] = "getn=" .. table.getn(t)
else
    results[#results + 1] = "getn=nil"
end

-- Test 10: table.maxn (deprecated)
if table.maxn then
    local t = {}
    t[10] = true
    results[#results + 1] = "maxn=" .. table.maxn(t)
else
    results[#results + 1] = "maxn=nil"
end

print(table.concat(results, ","))
-- Expected varies by runtime
