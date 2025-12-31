-- Test: debug.getupvalue function
local results = {}

-- Test 1: Basic upvalue
local x = 10
local function test1()
    return x
end
local name1, val1 = debug.getupvalue(test1, 1)
results[#results + 1] = "basic=" .. name1 .. ":" .. val1

-- Test 2: Multiple upvalues
local a, b, c = 1, 2, 3
local function test2()
    return a + b + c
end
local sum = 0
for i = 1, 3 do
    local name, val = debug.getupvalue(test2, i)
    if val then sum = sum + val end
end
results[#results + 1] = "multi=" .. sum

-- Test 3: Nested closure upvalues
local outer = 100
local function make_closure()
    local inner = 50
    return function()
        return outer + inner
    end
end
local closure = make_closure()
local n3a, v3a = debug.getupvalue(closure, 1)
local n3b, v3b = debug.getupvalue(closure, 2)
results[#results + 1] = "nested=" .. (v3a + v3b)

-- Test 4: No upvalues
local function no_upvals()
    return 42
end
local n4, v4 = debug.getupvalue(no_upvals, 1)
results[#results + 1] = "none=" .. tostring(n4)

-- Test 5: _ENV as upvalue (Lua 5.2+)
local function uses_global()
    return print
end
local found_env = false
local i = 1
while true do
    local name, val = debug.getupvalue(uses_global, i)
    if not name then break end
    if name == "_ENV" then found_env = true end
    i = i + 1
end
results[#results + 1] = "env=" .. (found_env and "yes" or "no")

-- Test 6: Upvalue vs local distinction
local uv = "upvalue"
local function test6()
    local lv = "local"
    return uv .. lv
end
local n6, v6 = debug.getupvalue(test6, 1)
results[#results + 1] = "upval=" .. v6

-- Test 7: Modified upvalue
local counter = 0
local function increment()
    counter = counter + 1
    return counter
end
increment()
increment()
local n7, v7 = debug.getupvalue(increment, 1)
results[#results + 1] = "modified=" .. v7

-- Test 8: Function as upvalue
local fn = function() return 42 end
local function uses_fn()
    return fn()
end
local n8, v8 = debug.getupvalue(uses_fn, 1)
results[#results + 1] = "funcup=" .. type(v8)

-- Test 9: Table upvalue
local tbl = {1, 2, 3}
local function uses_tbl()
    return tbl[1]
end
local n9, v9 = debug.getupvalue(uses_tbl, 1)
results[#results + 1] = "tblup=" .. #v9

print(table.concat(results, ","))
-- Expected: basic=x:10,multi=6,nested=150,none=nil,env=yes,upval=upvalue,modified=2,funcup=function,tblup=3
