-- Test: Metatable semantics edge cases
local results = {}

-- Test 1: __index chain depth
local mt3 = {__index = {deep = "found"}}
local mt2 = {__index = setmetatable({}, mt3)}
local mt1 = {__index = setmetatable({}, mt2)}
local t = setmetatable({}, mt1)
results[#results + 1] = "chain=" .. t.deep

-- Test 2: __index function with different return counts
local mt_ret = {
    __index = function(t, k)
        if k == "one" then return 1 end
        if k == "multi" then return 1, 2, 3 end
    end
}
local t2 = setmetatable({}, mt_ret)
local a, b = t2.one, t2.multi
results[#results + 1] = "idx_ret=" .. a .. (b or "nil")

-- Test 3: __newindex doesn't trigger for existing keys
local newindex_calls = 0
local mt3 = {
    __newindex = function(t, k, v)
        newindex_calls = newindex_calls + 1
        rawset(t, k, v)
    end
}
local t3 = setmetatable({existing = 1}, mt3)
t3.existing = 2
t3.new = 3
results[#results + 1] = "newindex=" .. newindex_calls

-- Test 4: Metamethod selection order
local mt4a = {
    __add = function() return "a" end
}
local mt4b = {
    __add = function() return "b" end
}
local ta = setmetatable({}, mt4a)
local tb = setmetatable({}, mt4b)
results[#results + 1] = "order=" .. (ta + tb)

-- Test 5: __len for tables (5.2+)
local mt5 = {__len = function() return 99 end}
local t5 = setmetatable({1, 2, 3}, mt5)
results[#results + 1] = "len=" .. #t5

-- Test 6: __pairs/__ipairs (5.2+)
local custom_pairs_count = 0
local mt6 = {
    __pairs = function(t)
        custom_pairs_count = custom_pairs_count + 1
        return pairs({custom = true})
    end
}
local t6 = setmetatable({original = true}, mt6)
for k, v in pairs(t6) do end
results[#results + 1] = "pairs_mt=" .. custom_pairs_count

-- Test 7: rawget/rawset bypass
local mt7 = {
    __index = function() return "meta" end,
    __newindex = function() error("blocked") end
}
local t7 = setmetatable({}, mt7)
rawset(t7, "key", "raw")
results[#results + 1] = "raw=" .. rawget(t7, "key")

-- Test 8: __call on table
local mt8 = {
    __call = function(t, ...)
        return select('#', ...)
    end
}
local t8 = setmetatable({}, mt8)
results[#results + 1] = "call=" .. t8(1, 2, 3)

-- Test 9: __concat
local mt9 = {
    __concat = function(a, b)
        return tostring(a) .. "+" .. tostring(b)
    end,
    __tostring = function() return "obj" end
}
local t9 = setmetatable({}, mt9)
results[#results + 1] = "concat=" .. (t9 .. "str")

-- Test 10: Comparison metamethods
local mt10 = {
    __lt = function(a, b) return a.val < b.val end,
    __le = function(a, b) return a.val <= b.val end,
    __eq = function(a, b) return a.val == b.val end
}
local t10a = setmetatable({val = 1}, mt10)
local t10b = setmetatable({val = 2}, mt10)
local t10c = setmetatable({val = 1}, mt10)
results[#results + 1] = "cmp=" .. tostring(t10a < t10b) .. tostring(t10a == t10c)

-- Test 11: __gc timing
local gc_order = {}
for i = 1, 3 do
    local idx = i
    setmetatable({}, {__gc = function() gc_order[#gc_order + 1] = idx end})
end
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "gc_order=" .. #gc_order

-- Test 12: __mode weak table variations
local weak_kv = setmetatable({}, {__mode = "kv"})
local weak_k = setmetatable({}, {__mode = "k"})
local weak_v = setmetatable({}, {__mode = "v"})
local key, val = {}, {}
weak_kv[key] = val
weak_k[key] = val
weak_v[key] = val
key = nil
val = nil
collectgarbage("collect")
collectgarbage("collect")
local kv_empty = next(weak_kv) == nil
local k_empty = next(weak_k) == nil
local v_empty = next(weak_v) == nil
results[#results + 1] = "weak=" .. (kv_empty and "kv" or "") .. (k_empty and "k" or "") .. (v_empty and "v" or "")

print(table.concat(results, ","))
-- Expected varies by Lua version
