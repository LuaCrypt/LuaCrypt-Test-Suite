-- Test: Features that work across all Lua versions
local results = {}

-- Test 1: Basic types
results[#results + 1] = "nil=" .. type(nil)
results[#results + 1] = "bool=" .. type(true)
results[#results + 1] = "num=" .. type(42)
results[#results + 1] = "str=" .. type("hello")
results[#results + 1] = "tbl=" .. type({})
results[#results + 1] = "func=" .. type(function() end)

-- Test 2: Control structures
local x = 0
for i = 1, 10 do x = x + i end
results[#results + 1] = "forloop=" .. x

-- Test 3: Functions
local function add(a, b) return a + b end
results[#results + 1] = "func_call=" .. add(2, 3)

-- Test 4: Tables
local t = {a = 1, b = 2, [1] = "x", [2] = "y"}
results[#results + 1] = "table=" .. t.a .. t[1]

-- Test 5: Metatables
local mt = {__index = {default = 99}}
local obj = setmetatable({}, mt)
results[#results + 1] = "metatable=" .. obj.default

-- Test 6: Closures
local function make_adder(n)
    return function(x) return x + n end
end
local add5 = make_adder(5)
results[#results + 1] = "closure=" .. add5(10)

-- Test 7: Varargs
local function sum(...)
    local total = 0
    for i = 1, select('#', ...) do
        total = total + select(i, ...)
    end
    return total
end
results[#results + 1] = "varargs=" .. sum(1, 2, 3, 4, 5)

-- Test 8: String operations
local s = "Hello World"
results[#results + 1] = "string=" .. s:sub(1, 5):lower()

-- Test 9: Math operations
results[#results + 1] = "math=" .. math.floor(math.sqrt(16))

-- Test 10: pcall/error
local ok, err = pcall(function() error("test") end)
results[#results + 1] = "pcall=" .. (ok and "ok" or "caught")

-- Test 11: Coroutines
local co = coroutine.create(function()
    coroutine.yield(1)
    coroutine.yield(2)
    return 3
end)
local vals = {}
while coroutine.status(co) ~= "dead" do
    local _, v = coroutine.resume(co)
    vals[#vals + 1] = v
end
results[#results + 1] = "coro=" .. table.concat(vals, "+")

-- Test 12: Multiple returns
local function multi() return 1, 2, 3 end
local a, b, c = multi()
results[#results + 1] = "multi=" .. (a + b + c)

-- Test 13: Table as key
local tkey = {}
local tval = {[tkey] = "found"}
results[#results + 1] = "tblkey=" .. tval[tkey]

-- Test 14: Function as value
local function fn() return 42 end
local container = {func = fn}
results[#results + 1] = "funcval=" .. container.func()

-- Test 15: Boolean logic
local bool_test = (true and "yes" or "no")
results[#results + 1] = "boollogic=" .. bool_test

print(table.concat(results, ","))
-- Expected: nil=nil,bool=boolean,num=number,str=string,tbl=table,func=function,forloop=55,func_call=5,table=1x,metatable=99,closure=15,varargs=15,string=hello,math=4,pcall=caught,coro=1+2+3,multi=6,tblkey=found,funcval=42,boollogic=yes
