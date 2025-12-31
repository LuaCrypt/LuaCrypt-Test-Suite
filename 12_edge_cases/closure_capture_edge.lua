-- Edge cases for closure and upvalue capture
-- Tests: capture timing, mutation visibility, nested closures, loop captures

local results = {}

-- Test 1: Basic upvalue capture
local x = 10
local function get_x()
    return x
end
results[#results + 1] = get_x()  -- 10

-- Test 2: Upvalue mutation visibility
x = 20
results[#results + 1] = get_x()  -- 20

-- Test 3: Closure modifying upvalue
local function set_x(val)
    x = val
end
set_x(30)
results[#results + 1] = x  -- 30

-- Test 4: Multiple closures sharing upvalue
local counter = 0
local function inc() counter = counter + 1 end
local function dec() counter = counter - 1 end
local function get() return counter end

inc()
inc()
dec()
results[#results + 1] = get()  -- 1

-- Test 5: Nested closure chain
local function outer()
    local a = 1
    return function()
        local b = 2
        return function()
            local c = 3
            return function()
                return a + b + c
            end
        end
    end
end

results[#results + 1] = outer()()()()  -- 6

-- Test 6: Loop variable capture (classic gotcha - each iteration gets same var)
local funcs = {}
for i = 1, 3 do
    funcs[i] = function() return i end
end
-- In Lua, loop variable is shared unless explicitly captured
results[#results + 1] = funcs[1]() + funcs[2]() + funcs[3]()  -- 12 (4+4+4) after loop

-- Test 7: Loop variable capture with local copy
local funcs2 = {}
for i = 1, 3 do
    local captured = i
    funcs2[i] = function() return captured end
end
results[#results + 1] = funcs2[1]() + funcs2[2]() + funcs2[3]()  -- 6 (1+2+3)

-- Test 8: While loop capture
local funcs3 = {}
local j = 0
while j < 3 do
    j = j + 1
    local captured = j
    funcs3[j] = function() return captured end
end
results[#results + 1] = funcs3[1]() + funcs3[2]() + funcs3[3]()  -- 6

-- Test 9: Closure in table
local tbl = {
    val = 100,
    get = function(self)
        return function()
            return self.val
        end
    end
}

local getter = tbl:get()
tbl.val = 200
results[#results + 1] = getter()  -- 200 (self.val changed)

-- Test 10: Recursive closure
local function make_counter(start)
    local count = start
    local function counter(action)
        if action == "inc" then
            count = count + 1
            return counter
        elseif action == "get" then
            return count
        end
        return counter
    end
    return counter
end

local c = make_counter(0)
c("inc")("inc")("inc")
results[#results + 1] = c("get")  -- 3

-- Test 11: Upvalue in conditional
local flag = false
local function check()
    if flag then
        return "yes"
    else
        return "no"
    end
end

results[#results + 1] = check()  -- no
flag = true
results[#results + 1] = check()  -- yes

-- Test 12: Shadowed variable capture
local shadow = "outer"
local function get_shadow()
    return shadow
end

local function set_shadow_local()
    local shadow = "inner"  -- shadows outer
    return shadow
end

results[#results + 1] = get_shadow()      -- outer
results[#results + 1] = set_shadow_local()  -- inner
results[#results + 1] = shadow            -- outer (unchanged)

-- Test 13: Closure factory pattern
local function make_adder(n)
    return function(x)
        return x + n
    end
end

local add5 = make_adder(5)
local add10 = make_adder(10)
results[#results + 1] = add5(3)   -- 8
results[#results + 1] = add10(3)  -- 13

-- Test 14: Memoization pattern
local function memoize(fn)
    local cache = {}
    return function(x)
        if cache[x] == nil then
            cache[x] = fn(x)
        end
        return cache[x]
    end
end

local call_count = 0
local expensive = memoize(function(x)
    call_count = call_count + 1
    return x * 2
end)

expensive(5)
expensive(5)
expensive(10)
results[#results + 1] = call_count  -- 2 (not 3)

-- Test 15: Coroutine upvalue capture
local co_val = 0
local co = coroutine.create(function()
    while true do
        co_val = co_val + 1
        coroutine.yield(co_val)
    end
end)

coroutine.resume(co)
coroutine.resume(co)
coroutine.resume(co)
results[#results + 1] = co_val  -- 3

print(table.concat(results, ","))
-- Expected: 10,20,30,1,6,12,6,6,200,3,no,yes,outer,inner,outer,8,13,2,3
