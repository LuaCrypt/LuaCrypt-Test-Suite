-- Test: rawlen function
local results = {}

-- Test 1: rawlen on simple array
local t1 = {1, 2, 3, 4, 5}
results[#results + 1] = "simple=" .. rawlen(t1)

-- Test 2: rawlen bypasses __len
local t2 = setmetatable({1, 2, 3}, {
    __len = function() return 100 end
})
results[#results + 1] = "bypass=" .. rawlen(t2) .. ":" .. #t2

-- Test 3: rawlen on empty
local t3 = {}
results[#results + 1] = "empty=" .. rawlen(t3)

-- Test 4: rawlen on string
results[#results + 1] = "string=" .. rawlen("hello")

-- Test 5: rawlen on mixed table
local t5 = {10, 20, 30, x = 100}
results[#results + 1] = "mixed=" .. rawlen(t5)

-- Test 6: rawlen after modifications
local t6 = {1, 2, 3}
t6[4] = 4
t6[5] = 5
results[#results + 1] = "modified=" .. rawlen(t6)

print(table.concat(results, ","))
-- Expected: simple=5,bypass=3:100,empty=0,string=5,mixed=3,modified=5
