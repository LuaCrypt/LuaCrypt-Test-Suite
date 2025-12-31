-- Test: rawget and rawset (bypass metatables)
local results = {}

-- Test 1: rawget bypasses __index
local mt1 = {
    __index = function()
        return "from_meta"
    end
}
local t1 = setmetatable({existing = "real"}, mt1)
results[#results + 1] = "index=" .. t1.missing  -- Uses __index
results[#results + 1] = "rawget=" .. tostring(rawget(t1, "missing"))  -- nil
results[#results + 1] = "rawget_exist=" .. rawget(t1, "existing")

-- Test 2: rawset bypasses __newindex
local log = {}
local mt2 = {
    __newindex = function(t, k, v)
        log[#log + 1] = k
        rawset(t, k, v * 2)
    end
}
local t2 = setmetatable({}, mt2)
t2.normal = 10  -- Goes through __newindex
rawset(t2, "raw", 10)  -- Bypasses __newindex
results[#results + 1] = "vals=" .. t2.normal .. ";" .. t2.raw
results[#results + 1] = "log=" .. table.concat(log, ";")

-- Test 3: rawget on table without metatable
local t3 = {a = 1, b = 2}
results[#results + 1] = "plain=" .. rawget(t3, "a") .. ";" .. tostring(rawget(t3, "c"))

-- Test 4: rawset on existing key (still bypasses __newindex for existing)
local ni_called = false
local mt4 = {
    __newindex = function()
        ni_called = true
    end
}
local t4 = setmetatable({x = 1}, mt4)
rawset(t4, "x", 100)
results[#results + 1] = "existing_raw=" .. t4.x .. ":" .. tostring(ni_called)

-- Test 5: Chain of rawget/rawset
local t5 = setmetatable({}, {__index = {chain = "meta"}})
rawset(t5, "chain", rawget(t5, "chain") or "default")
results[#results + 1] = "chain_raw=" .. t5.chain

print(table.concat(results, ","))
-- Expected: index=from_meta,rawget=nil,rawget_exist=real,vals=20;10,log=normal,plain=1;nil,existing_raw=100:false,chain_raw=default
