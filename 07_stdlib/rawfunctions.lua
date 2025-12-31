-- Test: Raw table access functions
local results = {}

-- Test 1: rawget bypasses __index
local mt1 = {__index = function(t, k) return "default" end}
local t1 = setmetatable({a = 1}, mt1)
results[#results + 1] = "rawget=" .. tostring(rawget(t1, "b"))
results[#results + 1] = "normal=" .. t1.b

-- Test 2: rawset bypasses __newindex
local logged = false
local mt2 = {__newindex = function(t, k, v) logged = true; rawset(t, k, v) end}
local t2 = setmetatable({}, mt2)
rawset(t2, "x", 10)
results[#results + 1] = "rawset_log=" .. tostring(logged)
t2.y = 20
results[#results + 1] = "normal_log=" .. tostring(logged)

-- Test 3: rawequal
local t3a = {}
local t3b = t3a
local t3c = {}
results[#results + 1] = "eq_same=" .. tostring(rawequal(t3a, t3b))
results[#results + 1] = "eq_diff=" .. tostring(rawequal(t3a, t3c))

-- Test 4: rawequal with __eq
local mt4 = {__eq = function(a, b) return true end}
local t4a = setmetatable({}, mt4)
local t4b = setmetatable({}, mt4)
results[#results + 1] = "eq_meta=" .. tostring(t4a == t4b)
results[#results + 1] = "eq_raw=" .. tostring(rawequal(t4a, t4b))

-- Test 5: rawlen (Lua 5.2+)
if rawlen then
    local mt5 = {__len = function() return 999 end}
    local t5 = setmetatable({1, 2, 3}, mt5)
    results[#results + 1] = "len_meta=" .. #t5
    results[#results + 1] = "len_raw=" .. rawlen(t5)
end

-- Test 6: rawget on nil key
local t6 = {a = 1}
results[#results + 1] = "nil_key=" .. tostring(rawget(t6, nil))

-- Test 7: rawset nil value (delete)
local t7 = {a = 1, b = 2}
rawset(t7, "a", nil)
results[#results + 1] = "delete=" .. tostring(rawget(t7, "a"))

-- Test 8: rawget/rawset with unusual keys
local key8 = {}
local t8 = {}
rawset(t8, key8, "table_key")
results[#results + 1] = "tbl_key=" .. rawget(t8, key8)

-- Test 9: rawequal primitives
results[#results + 1] = "eq_num=" .. tostring(rawequal(42, 42))
results[#results + 1] = "eq_str=" .. tostring(rawequal("a", "a"))
results[#results + 1] = "eq_nil=" .. tostring(rawequal(nil, nil))

-- Test 10: Combination test
local mt10 = {
    __index = function() return "idx" end,
    __newindex = function() error("no write!") end
}
local t10 = setmetatable({existing = "yes"}, mt10)
results[#results + 1] = "combo_get=" .. tostring(rawget(t10, "missing"))
rawset(t10, "new", "value")
results[#results + 1] = "combo_set=" .. rawget(t10, "new")

print(table.concat(results, ","))
-- Expected: rawget=nil,normal=default,rawset_log=false,normal_log=true,eq_same=true,eq_diff=false,eq_meta=true,eq_raw=false,len_meta=999,len_raw=3,nil_key=nil,delete=nil,tbl_key=table_key,eq_num=true,eq_str=true,eq_nil=true,combo_get=nil,combo_set=value
