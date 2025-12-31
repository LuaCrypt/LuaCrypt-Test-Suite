-- Test: __concat metamethod
local results = {}

-- Test 1: Custom concatenation
local mt = {
    __concat = function(a, b)
        if type(a) == "table" then a = a.value end
        if type(b) == "table" then b = b.value end
        return tostring(a) .. tostring(b)
    end
}
local t1 = setmetatable({value = "hello"}, mt)
local t2 = setmetatable({value = "world"}, mt)
results[#results + 1] = "custom=" .. (t1 .. t2)

-- Test 2: Concat with string
local t3 = setmetatable({value = "prefix"}, mt)
results[#results + 1] = "with_str=" .. (t3 .. "_suffix")

-- Test 3: Chain concatenation
local t4 = setmetatable({value = "A"}, mt)
local t5 = setmetatable({value = "B"}, mt)
local t6 = setmetatable({value = "C"}, mt)
results[#results + 1] = "chain=" .. (t4 .. t5 .. t6)

-- Test 4: Return different type
local numConcat = {
    __concat = function(a, b)
        local va = type(a) == "table" and a.n or a
        local vb = type(b) == "table" and b.n or b
        return setmetatable({n = va + vb}, numConcat)
    end
}
local n1 = setmetatable({n = 10}, numConcat)
local n2 = setmetatable({n = 20}, numConcat)
local n3 = n1 .. n2
results[#results + 1] = "return_tbl=" .. n3.n

-- Test 5: Right-side concat
results[#results + 1] = "right=" .. ("pre_" .. t1)

print(table.concat(results, ","))
-- Expected: custom=helloworld,with_str=prefix_suffix,chain=ABC,return_tbl=30,right=pre_hello
