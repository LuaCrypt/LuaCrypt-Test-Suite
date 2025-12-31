-- Test: Dynamic code loading (load/loadstring)
local results = {}

-- Determine which function to use
local loadfn = load or loadstring

-- Test 1: Basic load
local fn1, err1 = loadfn("return 1 + 2")
if fn1 then
    results[#results + 1] = "basic=" .. fn1()
else
    results[#results + 1] = "basic=error"
end

-- Test 2: Load with error
local fn2, err2 = loadfn("return 1 +")
results[#results + 1] = "syntax=" .. (fn2 == nil and "nil" or "fn")

-- Test 3: Runtime error in loaded code
local fn3 = loadfn("return nil + 1")
if fn3 then
    local ok, err = pcall(fn3)
    results[#results + 1] = "runtime=" .. (ok and "ok" or "err")
end

-- Test 4: Multiple statements
local fn4 = loadfn("local x = 5; local y = 3; return x * y")
if fn4 then
    results[#results + 1] = "multi=" .. fn4()
end

-- Test 5: Access globals
_G.test_global = 42
local fn5 = loadfn("return test_global")
if fn5 then
    results[#results + 1] = "global=" .. fn5()
end
_G.test_global = nil

-- Test 6: Set globals
local fn6 = loadfn("test_set = 100")
if fn6 then
    fn6()
    results[#results + 1] = "setglobal=" .. tostring(test_set)
    _G.test_set = nil
end

-- Test 7: Function with parameters via return
local fn7 = loadfn("return function(a, b) return a + b end")
if fn7 then
    local adder = fn7()
    results[#results + 1] = "func=" .. adder(3, 4)
end

-- Test 8: Load with environment (Lua 5.2+ style)
if load then
    local env8 = {x = 10, y = 20}
    local fn8 = load("return x + y", "test", "t", env8)
    if fn8 then
        results[#results + 1] = "env=" .. fn8()
    end
end

-- Test 9: Empty string
local fn9 = loadfn("")
if fn9 then
    local result = fn9()
    results[#results + 1] = "empty=" .. tostring(result)
end

-- Test 10: String with return
local fn10 = loadfn("return 'hello'")
if fn10 then
    results[#results + 1] = "str=" .. fn10()
end

-- Test 11: Table construction
local fn11 = loadfn("return {1, 2, 3}")
if fn11 then
    local t = fn11()
    results[#results + 1] = "table=" .. #t
end

-- Test 12: Conditional
local fn12 = loadfn("local x = 5; if x > 3 then return 'big' else return 'small' end")
if fn12 then
    results[#results + 1] = "cond=" .. fn12()
end

print(table.concat(results, ","))
-- Expected: basic=3,syntax=nil,runtime=err,multi=15,global=42,setglobal=100,func=7,env=30,empty=nil,str=hello,table=3,cond=big
