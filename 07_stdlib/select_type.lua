-- Test: select and type functions
local results = {}

-- Test 1: select count
results[#results + 1] = "count=" .. select("#", 1, 2, 3, 4, 5)

-- Test 2: select positive index
local a, b = select(2, "a", "b", "c", "d")
results[#results + 1] = "pos=" .. a .. ":" .. b

-- Test 3: select negative index
local x = select(-2, "a", "b", "c", "d")
results[#results + 1] = "neg=" .. x

-- Test 4: select with nil
results[#results + 1] = "nil_count=" .. select("#", nil, nil, nil)

-- Test 5: select 1 returns all
local r5a, r5b, r5c = select(1, "x", "y", "z")
results[#results + 1] = "all=" .. r5a .. r5b .. r5c

-- Test 6: type of values
results[#results + 1] = "t_nil=" .. type(nil)
results[#results + 1] = "t_bool=" .. type(true)
results[#results + 1] = "t_num=" .. type(42)
results[#results + 1] = "t_str=" .. type("hello")
results[#results + 1] = "t_tbl=" .. type({})
results[#results + 1] = "t_func=" .. type(function() end)

-- Test 7: type of special values
results[#results + 1] = "t_inf=" .. type(math.huge)
results[#results + 1] = "t_nan=" .. type(0/0)

-- Test 8: select edge - index 1 with no args
results[#results + 1] = "empty=" .. select("#")

-- Test 9: Combined select usage
local function vararg_info(...)
    return select("#", ...), (select(1, ...) or "none")
end
local c9, f9 = vararg_info("a", "b", "c")
results[#results + 1] = "combo=" .. c9 .. ":" .. f9

-- Test 10: select in loop
local sum = 0
local function add_all(...)
    for i = 1, select("#", ...) do
        sum = sum + select(i, ...)
    end
end
add_all(1, 2, 3, 4, 5)
results[#results + 1] = "loop=" .. sum

-- Test 11: type thread
local co = coroutine.create(function() end)
results[#results + 1] = "t_thread=" .. type(co)

-- Test 12: Checking type comparisons
local is_string = type("hello") == "string"
local is_number = type(42) == "number"
results[#results + 1] = "cmp=" .. tostring(is_string and is_number)

print(table.concat(results, ","))
-- Expected: count=5,pos=b:c,neg=c,nil_count=3,all=xyz,t_nil=nil,t_bool=boolean,t_num=number,t_str=string,t_tbl=table,t_func=function,t_inf=number,t_nan=number,empty=0,combo=3:a,loop=15,t_thread=thread,cmp=true
