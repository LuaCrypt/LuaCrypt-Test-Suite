-- Test: LuaJIT-specific features
local results = {}

-- Test 1: Check if LuaJIT
local is_luajit = jit ~= nil
results[#results + 1] = "luajit=" .. (is_luajit and "yes" or "no")

if not is_luajit then
    print(table.concat(results, ","))
    return
end

-- Test 2: JIT version
results[#results + 1] = "version=" .. (jit.version and "has" or "nil")

-- Test 3: JIT status
local status = jit.status()
results[#results + 1] = "status=" .. (status and "on" or "off")

-- Test 4: FFI availability
if jit.ffi or pcall(require, "ffi") then
    results[#results + 1] = "ffi=available"
else
    results[#results + 1] = "ffi=missing"
end

-- Test 5: bit library (always available in LuaJIT)
if bit then
    results[#results + 1] = "bit=" .. bit.band(0xFF, 0x0F)
else
    results[#results + 1] = "bit=nil"
end

-- Test 6: table.new (LuaJIT extension)
if table.new then
    local t = table.new(100, 10)
    results[#results + 1] = "table.new=exists"
else
    results[#results + 1] = "table.new=nil"
end

-- Test 7: table.clear (LuaJIT extension)
if table.clear then
    local t = {1, 2, 3}
    table.clear(t)
    results[#results + 1] = "table.clear=" .. #t
else
    results[#results + 1] = "table.clear=nil"
end

-- Test 8: jit.opt module
if jit.opt then
    results[#results + 1] = "jit.opt=exists"
else
    results[#results + 1] = "jit.opt=nil"
end

-- Test 9: JIT compilation (simple hot loop)
jit.on()
local sum = 0
for i = 1, 1000 do
    sum = sum + i
end
results[#results + 1] = "hotloop=" .. sum

-- Test 10: Trace abort handling
local function trace_test()
    local t = {}
    for i = 1, 100 do
        t[i] = i * 2
    end
    return t[50]
end
results[#results + 1] = "trace=" .. trace_test()

-- Test 11: NYI (Not Yet Implemented) features still work
local function nyi_test()
    -- pairs with metamethod is NYI but should work
    local mt = {__pairs = function(t) return pairs({a = 1}) end}
    local obj = setmetatable({}, mt)
    for k, v in pairs(obj) do
        return k
    end
end
local ok, res = pcall(nyi_test)
results[#results + 1] = "nyi=" .. (ok and "works" or "error")

-- Test 12: Tail call optimization
local function tail_sum(n, acc)
    if n <= 0 then return acc end
    return tail_sum(n - 1, acc + n)
end
results[#results + 1] = "tailcall=" .. tail_sum(100, 0)

print(table.concat(results, ","))
-- Expected (on LuaJIT): luajit=yes,version=has,status=on,ffi=available,bit=15,table.new=exists,table.clear=0,jit.opt=exists,hotloop=500500,trace=100,nyi=works,tailcall=5050
