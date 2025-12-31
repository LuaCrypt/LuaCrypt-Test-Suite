-- Test: Debug with garbage collection interaction
local results = {}

-- Test 1: Weak reference in debug context
local weak_table = setmetatable({}, {__mode = "v"})
local function create_and_track()
    local obj = {value = 42}
    weak_table.tracked = obj
    return function()
        return obj.value
    end
end
local closure = create_and_track()
results[#results + 1] = "before_gc=" .. (weak_table.tracked and "exists" or "nil")

-- Test 2: GC doesn't collect closure upvalues
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "after_gc=" .. (weak_table.tracked and "exists" or "nil")

-- Test 3: Closure keeps upvalue alive
results[#results + 1] = "upval_alive=" .. closure()

-- Test 4: Release reference and GC
closure = nil
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "released=" .. (weak_table.tracked and "still" or "collected")

-- Test 5: debug.getlocal doesn't prevent GC
local function gc_locals()
    local temp = {data = "temporary"}
    weak_table.temp = temp
    -- temp goes out of scope after return
    return debug.getinfo(1, "n")
end
gc_locals()
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "local_gc=" .. (weak_table.temp and "kept" or "collected")

-- Test 6: Coroutine and GC
local co_obj = {coro_data = 123}
weak_table.coro_obj = co_obj
local co = coroutine.create(function()
    local ref = co_obj
    coroutine.yield(ref.coro_data)
    return ref.coro_data
end)
coroutine.resume(co)
co_obj = nil
collectgarbage("collect")
results[#results + 1] = "coro_keeps=" .. (weak_table.coro_obj and "alive" or "collected")

-- Finish coroutine to release reference
coroutine.resume(co)
co = nil
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "coro_done=" .. (weak_table.coro_obj and "kept" or "collected")

-- Test 7: Hook function GC
local hook_called = false
local hook_fn = function()
    hook_called = true
end
debug.sethook(hook_fn, "c")
hook_fn = nil
collectgarbage("collect")
local function trigger_hook() end
trigger_hook()
debug.sethook()
results[#results + 1] = "hook_gc=" .. (hook_called and "called" or "not_called")

-- Test 8: Registry reference prevents GC
local reg = debug.getregistry()
local reg_obj = {reg_data = 999}
weak_table.reg_obj = reg_obj
reg["__gc_test"] = reg_obj
reg_obj = nil
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "reg_keeps=" .. (weak_table.reg_obj and "alive" or "collected")
reg["__gc_test"] = nil
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "reg_release=" .. (weak_table.reg_obj and "kept" or "collected")

print(table.concat(results, ","))
-- Expected: before_gc=exists,after_gc=exists,upval_alive=42,released=collected,local_gc=collected,coro_keeps=alive,coro_done=collected,hook_gc=called,reg_keeps=alive,reg_release=collected
