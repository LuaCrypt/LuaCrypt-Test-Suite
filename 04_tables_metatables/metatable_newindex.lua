-- Test: __newindex metamethod
local results = {}

-- Test 1: __newindex as table (redirect)
local storage = {}
local mt1 = {__newindex = storage}
local t1 = setmetatable({}, mt1)
t1.x = 100
results[#results + 1] = "redirect=" .. tostring(t1.x) .. ":" .. storage.x

-- Test 2: __newindex as function
local log = {}
local mt2 = {
    __newindex = function(t, k, v)
        log[#log + 1] = k .. "=" .. tostring(v)
        rawset(t, k, v)  -- Actually store it
    end
}
local t2 = setmetatable({}, mt2)
t2.a = 1
t2.b = 2
results[#results + 1] = "func_log=" .. table.concat(log, ";")
results[#results + 1] = "stored=" .. t2.a .. ";" .. t2.b

-- Test 3: __newindex not called for existing keys
local ni_called = false
local mt3 = {
    __newindex = function(t, k, v)
        ni_called = true
        rawset(t, k, v)
    end
}
local t3 = setmetatable({existing = 1}, mt3)
t3.existing = 2  -- Should NOT call __newindex
results[#results + 1] = "existing=" .. tostring(ni_called) .. ":" .. t3.existing

-- Test 4: Validation in __newindex
local mt4 = {
    __newindex = function(t, k, v)
        if type(v) ~= "number" then
            error("only numbers allowed")
        end
        rawset(t, k, v)
    end
}
local t4 = setmetatable({}, mt4)
t4.num = 42
local ok = pcall(function() t4.str = "bad" end)
results[#results + 1] = "validate=" .. t4.num .. ":" .. tostring(ok)

-- Test 5: Read-only table pattern
local mt5 = {
    __newindex = function()
        error("read-only")
    end
}
local t5 = setmetatable({readonly = true}, mt5)
local ok5 = pcall(function() t5.new = "value" end)
results[#results + 1] = "readonly=" .. tostring(ok5)

print(table.concat(results, ","))
-- Expected: redirect=nil:100,func_log=a=1;b=2,stored=1;2,existing=false:2,validate=42:false,readonly=false
