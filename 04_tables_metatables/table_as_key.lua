-- Test: Tables as keys
local results = {}

-- Test 1: Table key identity
local t1 = {}
local key1 = {}
local key2 = {}
t1[key1] = "value1"
t1[key2] = "value2"
results[#results + 1] = "identity=" .. t1[key1] .. ";" .. t1[key2]

-- Test 2: Same content, different tables
local keyA = {x = 1}
local keyB = {x = 1}
local t2 = {}
t2[keyA] = "A"
t2[keyB] = "B"
results[#results + 1] = "same_content=" .. t2[keyA] .. ";" .. t2[keyB]

-- Test 3: Table key lookup
local t3 = {}
local lookup = {}
t3[lookup] = 100
results[#results + 1] = "lookup=" .. t3[lookup]

-- Test 4: Counting with table keys
local t4 = {}
local keys = {}
for i = 1, 5 do
    keys[i] = {}
    t4[keys[i]] = i
end
local sum = 0
for k, v in pairs(t4) do
    sum = sum + v
end
results[#results + 1] = "count=" .. sum

-- Test 5: Function as key
local t5 = {}
local fn = function() return 1 end
t5[fn] = "function_value"
results[#results + 1] = "func_key=" .. t5[fn]

-- Test 6: Mixed keys
local t6 = {}
local tblKey = {}
t6[1] = "numeric"
t6["str"] = "string"
t6[tblKey] = "table"
t6[true] = "boolean"
local count = 0
for k, v in pairs(t6) do
    count = count + 1
end
results[#results + 1] = "mixed_keys=" .. count

print(table.concat(results, ","))
-- Expected: identity=value1;value2,same_content=A;B,lookup=100,count=15,func_key=function_value,mixed_keys=4
