-- Test: Callback function identity preservation
local results = {}

-- Test 1: Function reference equality
local function my_callback()
    return 42
end
local stored_callback = my_callback
results[#results + 1] = "ref_eq=" .. tostring(my_callback == stored_callback)

-- Test 2: Callback in table
local registry = {}
local function register(name, fn)
    registry[name] = fn
end
local function trigger(name, ...)
    if registry[name] then
        return registry[name](...)
    end
end
local callback = function(x) return x * 2 end
register("double", callback)
results[#results + 1] = "tbl_store=" .. trigger("double", 5)
results[#results + 1] = "tbl_identity=" .. tostring(registry["double"] == callback)

-- Test 3: Callback as return value
local function get_handler()
    return function(x) return x + 1 end
end
local h1 = get_handler()
local h2 = get_handler()
results[#results + 1] = "return_diff=" .. tostring(h1 ~= h2)
results[#results + 1] = "return_works=" .. h1(10) .. ":" .. h2(10)

-- Test 4: Callback in closure
local function create_caller(fn)
    return function(...)
        return fn(...)
    end
end
local adder = function(a, b) return a + b end
local caller = create_caller(adder)
results[#results + 1] = "closure_call=" .. caller(3, 4)

-- Test 5: Callback chain
local function chain(fns)
    return function(x)
        local result = x
        for _, fn in ipairs(fns) do
            result = fn(result)
        end
        return result
    end
end
local double = function(x) return x * 2 end
local add_one = function(x) return x + 1 end
local chained = chain({double, add_one, double})
results[#results + 1] = "chain=" .. chained(5)

-- Test 6: Self-referential callback
local self_ref
self_ref = function(n)
    if n <= 0 then return 0 end
    return n + self_ref(n - 1)
end
results[#results + 1] = "self_ref=" .. self_ref(10)

-- Test 7: Callback replacement
local handler = function() return "old" end
local function call_handler()
    return handler()
end
results[#results + 1] = "before=" .. call_handler()
handler = function() return "new" end
results[#results + 1] = "after=" .. call_handler()

-- Test 8: Multiple callbacks
local listeners = {}
local function add_listener(fn)
    listeners[#listeners + 1] = fn
end
local function fire_all(val)
    local results = {}
    for i, fn in ipairs(listeners) do
        results[i] = fn(val)
    end
    return results
end
add_listener(function(x) return x + 1 end)
add_listener(function(x) return x * 2 end)
add_listener(function(x) return x ^ 2 end)
local fired = fire_all(3)
results[#results + 1] = "multi=" .. table.concat(fired, ":")

-- Test 9: Callback with upvalue
local counter = 0
local counting_callback = function()
    counter = counter + 1
    return counter
end
counting_callback()
counting_callback()
counting_callback()
results[#results + 1] = "upval=" .. counter

-- Test 10: Callback comparison after storage
local callbacks = {}
local c1 = function() return 1 end
local c2 = function() return 2 end
callbacks[c1] = true
callbacks[c2] = true
results[#results + 1] = "lookup=" .. tostring(callbacks[c1]) .. ":" .. tostring(callbacks[c2])

print(table.concat(results, ","))
-- Expected: ref_eq=true,tbl_store=10,tbl_identity=true,return_diff=true,return_works=11:11,closure_call=7,chain=22,self_ref=55,before=old,after=new,multi=4:6:9,upval=3,lookup=true:true
