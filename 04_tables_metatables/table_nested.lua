-- Test: Nested table structures
local results = {}

-- Test 1: Simple nesting
local t1 = {inner = {x = 10, y = 20}}
results[#results + 1] = "simple=" .. t1.inner.x .. ";" .. t1.inner.y

-- Test 2: Array of tables
local t2 = {{a = 1}, {a = 2}, {a = 3}}
results[#results + 1] = "array_of=" .. t2[1].a .. ";" .. t2[2].a .. ";" .. t2[3].a

-- Test 3: Deep nesting
local t3 = {
    level1 = {
        level2 = {
            level3 = {
                value = "deep"
            }
        }
    }
}
results[#results + 1] = "deep=" .. t3.level1.level2.level3.value

-- Test 4: Mixed nested
local t4 = {
    {name = "first", data = {1, 2, 3}},
    {name = "second", data = {4, 5, 6}}
}
results[#results + 1] = "mixed_nested=" .. t4[1].name .. ":" .. t4[1].data[2]

-- Test 5: Self-referencing (after creation)
local t5 = {value = 100}
t5.self = t5
results[#results + 1] = "self_ref=" .. t5.self.self.value

-- Test 6: Array of arrays (matrix)
local matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
}
results[#results + 1] = "matrix=" .. matrix[2][2]

print(table.concat(results, ","))
-- Expected: simple=10;20,array_of=1;2;3,deep=deep,mixed_nested=first:2,self_ref=100,matrix=5
