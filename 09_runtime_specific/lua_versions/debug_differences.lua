-- Test: Debug library differences across Lua versions
local results = {}

-- Test 1: debug.setmetatable (behavior with primitives)
if debug.setmetatable then
    local old_str = debug.getmetatable("")
    debug.setmetatable("", nil)
    local no_mt = debug.getmetatable("")
    debug.setmetatable("", old_str)
    results[#results + 1] = "setmt_str=" .. (no_mt == nil and "removed" or "kept")
else
    results[#results + 1] = "setmt_str=nil"
end

-- Test 2: debug.upvalueid (5.2+)
if debug.upvalueid then
    local x = 1
    local function f() return x end
    local id = debug.upvalueid(f, 1)
    results[#results + 1] = "upvalueid=" .. (id and "exists" or "nil")
else
    results[#results + 1] = "upvalueid=nil"
end

-- Test 3: debug.upvaluejoin (5.2+)
if debug.upvaluejoin then
    local a, b = 1, 2
    local function fa() return a end
    local function fb() return b end
    debug.upvaluejoin(fb, 1, fa, 1)
    results[#results + 1] = "upvaluejoin=" .. fb()
else
    results[#results + 1] = "upvaluejoin=nil"
end

-- Test 4: debug.getinfo 'u' options
local function test_u(a, b, c, ...)
    return debug.getinfo(1, "u")
end
local info4 = test_u(1, 2, 3, 4, 5)
if info4.nparams then
    results[#results + 1] = "nparams=" .. info4.nparams
else
    results[#results + 1] = "nparams=nil"
end
if info4.isvararg ~= nil then
    results[#results + 1] = "isvararg=" .. tostring(info4.isvararg)
else
    results[#results + 1] = "isvararg=nil"
end

-- Test 5: debug.getinfo 't' option (tail call)
local function tail_test()
    return debug.getinfo(1, "t")
end
local function caller()
    return tail_test()
end
local info5 = caller()
if info5.istailcall ~= nil then
    results[#results + 1] = "istailcall=" .. tostring(info5.istailcall)
else
    results[#results + 1] = "istailcall=nil"
end

-- Test 6: debug.getinfo 'L' option (active lines)
local function multi_line()
    local x = 1
    local y = 2
    return x + y
end
local info6 = debug.getinfo(multi_line, "L")
if info6.activelines then
    local count = 0
    for _ in pairs(info6.activelines) do count = count + 1 end
    results[#results + 1] = "activelines=" .. count
else
    results[#results + 1] = "activelines=nil"
end

-- Test 7: debug.getlocal with negative index (varargs)
local function vararg_local(...)
    return debug.getlocal(1, -1)
end
local name7, val7 = vararg_local("first", "second")
if name7 then
    results[#results + 1] = "vararg_local=" .. (val7 == "first" and "first" or "other")
else
    results[#results + 1] = "vararg_local=nil"
end

-- Test 8: debug.getlocal on coroutine
local co8 = coroutine.create(function()
    local coro_local = 42
    coroutine.yield()
end)
coroutine.resume(co8)
local name8, val8 = debug.getlocal(co8, 1, 1)
results[#results + 1] = "coro_local=" .. (val8 == 42 and "42" or "other")

-- Test 9: debug.sethook with count
local count_hits = 0
debug.sethook(function() count_hits = count_hits + 1 end, "", 10)
for i = 1, 100 do
    local _ = i * i
end
debug.sethook()
results[#results + 1] = "hook_count=" .. (count_hits > 0 and "works" or "none")

-- Test 10: debug.getinfo on C function
local info10 = debug.getinfo(print)
results[#results + 1] = "c_func=" .. info10.what

-- Test 11: debug.traceback with level
local function deep()
    return debug.traceback("msg", 2)
end
local function middle()
    return deep()
end
local tb11 = middle()
results[#results + 1] = "tb_level=" .. (tb11:find("middle") and "found" or "notfound")

print(table.concat(results, ","))
-- Expected varies by Lua version
