-- Test: debug.setupvalue function
local results = {}

-- Test 1: Basic setupvalue
local x = 10
local function test1()
    return x
end
debug.setupvalue(test1, 1, 20)
results[#results + 1] = "basic=" .. test1()

-- Test 2: Original variable changed
local y = 5
local function uses_y()
    return y
end
debug.setupvalue(uses_y, 1, 50)
results[#results + 1] = "original=" .. y

-- Test 3: Multiple upvalues
local a, b = 1, 2
local function sum_ab()
    return a + b
end
debug.setupvalue(sum_ab, 1, 10)
debug.setupvalue(sum_ab, 2, 20)
results[#results + 1] = "multi=" .. sum_ab()

-- Test 4: Return old name
local z = 100
local function uses_z()
    return z
end
local oldname = debug.setupvalue(uses_z, 1, 200)
results[#results + 1] = "name=" .. (oldname and "found" or "nil")

-- Test 5: Invalid index
local w = 1
local function uses_w()
    return w
end
local invalid = debug.setupvalue(uses_w, 100, 999)
results[#results + 1] = "invalid=" .. tostring(invalid)

-- Test 6: Set to different type
local num = 42
local function uses_num()
    return num
end
debug.setupvalue(uses_num, 1, "string")
results[#results + 1] = "type=" .. type(uses_num())

-- Test 7: Shared upvalue
local shared = 0
local function inc() shared = shared + 1; return shared end
local function get() return shared end
debug.setupvalue(inc, 1, 100)
results[#results + 1] = "shared=" .. get()

-- Test 8: Set table upvalue
local tbl = {1, 2, 3}
local function sum_tbl()
    local s = 0
    for i = 1, #tbl do s = s + tbl[i] end
    return s
end
debug.setupvalue(sum_tbl, 1, {10, 20, 30})
results[#results + 1] = "tbl=" .. sum_tbl()

-- Test 9: Set function upvalue
local fn = function() return 1 end
local function call_fn()
    return fn()
end
debug.setupvalue(call_fn, 1, function() return 99 end)
results[#results + 1] = "func=" .. call_fn()

-- Test 10: Closure factory
local function make_counter(start)
    local count = start
    return function()
        count = count + 1
        return count
    end
end
local counter1 = make_counter(0)
local counter2 = make_counter(100)
debug.setupvalue(counter1, 1, 50)
results[#results + 1] = "closure=" .. counter1()

print(table.concat(results, ","))
-- Expected: basic=20,original=50,multi=30,name=found,invalid=nil,type=string,shared=100,tbl=60,func=99,closure=51
