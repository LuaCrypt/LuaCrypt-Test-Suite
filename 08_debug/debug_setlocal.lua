-- Test: debug.setlocal function
local results = {}

-- Test 1: Basic setlocal
local function test1()
    local x = 10
    debug.setlocal(1, 1, 20)
    return x
end
results[#results + 1] = "basic=" .. test1()

-- Test 2: Set multiple locals
local function test2()
    local a = 1
    local b = 2
    local c = 3
    debug.setlocal(1, 1, 10)
    debug.setlocal(1, 2, 20)
    debug.setlocal(1, 3, 30)
    return a + b + c
end
results[#results + 1] = "multi=" .. test2()

-- Test 3: Set local in calling function
local function inner3()
    debug.setlocal(2, 1, 100)
end
local function outer3()
    local val = 50
    inner3()
    return val
end
results[#results + 1] = "caller=" .. outer3()

-- Test 4: Return old name
local function test4()
    local myvar = 42
    local oldname = debug.setlocal(1, 1, 99)
    return oldname, myvar
end
local name4, val4 = test4()
results[#results + 1] = "name=" .. (name4 and "found" or "nil")
results[#results + 1] = "newval=" .. val4

-- Test 5: Set to nil
local function test5()
    local x = 42
    debug.setlocal(1, 1, nil)
    return x == nil and "nil" or "notnil"
end
results[#results + 1] = "setnil=" .. test5()

-- Test 6: Set parameter
local function test6(a)
    debug.setlocal(1, 1, a * 2)
    return a
end
results[#results + 1] = "param=" .. test6(5)

-- Test 7: Invalid index
local function test7()
    local x = 1
    return debug.setlocal(1, 100, 999)
end
results[#results + 1] = "invalid=" .. tostring(test7())

-- Test 8: Set different types
local function test8()
    local x = 1
    debug.setlocal(1, 1, "string")
    local y = x
    debug.setlocal(1, 1, {1, 2, 3})
    local z = x
    return type(y), type(z)
end
local t1, t2 = test8()
results[#results + 1] = "types=" .. t1 .. ":" .. t2

-- Test 9: Set in loop
local function test9()
    local sum = 0
    for i = 1, 5 do
        sum = sum + i
        if i == 3 then
            debug.setlocal(1, 1, 100)  -- set sum to 100
        end
    end
    return sum
end
results[#results + 1] = "loop=" .. test9()

print(table.concat(results, ","))
-- Expected: basic=20,multi=60,caller=100,name=found,newval=99,setnil=nil,param=10,invalid=nil,types=string:table,loop=109
