-- Test: Nested numeric for loops
local results = {}

-- Test 1: Simple 2D iteration
local count = 0
for i = 1, 3 do
    for j = 1, 4 do
        count = count + 1
    end
end
results[#results + 1] = "2d=" .. count  -- 3*4=12

-- Test 2: Inner depends on outer
local pairs_list = {}
for i = 1, 3 do
    for j = 1, i do
        pairs_list[#pairs_list + 1] = i .. ":" .. j
    end
end
results[#results + 1] = "depend=" .. #pairs_list  -- 1+2+3=6

-- Test 3: Triple nested
local d3 = 0
for i = 1, 2 do
    for j = 1, 2 do
        for k = 1, 2 do
            d3 = d3 + 1
        end
    end
end
results[#results + 1] = "3d=" .. d3  -- 2*2*2=8

-- Test 4: Same variable name in different scopes (shadowing)
local outer_sum = 0
local inner_sum = 0
for i = 1, 3 do
    outer_sum = outer_sum + i
    for i = 10, 12 do  -- Shadows outer i
        inner_sum = inner_sum + i
    end
end
results[#results + 1] = "shadow_out=" .. outer_sum .. "_in=" .. inner_sum

-- Test 5: Break in inner loop
local break_count = 0
for i = 1, 3 do
    for j = 1, 10 do
        break_count = break_count + 1
        if j == 2 then break end
    end
end
results[#results + 1] = "inner_break=" .. break_count  -- 3*2=6

-- Test 6: Matrix-style access
local matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
}
local total = 0
for i = 1, 3 do
    for j = 1, 3 do
        total = total + matrix[i][j]
    end
end
results[#results + 1] = "matrix=" .. total  -- 45

print(table.concat(results, ","))
-- Expected: 2d=12,depend=6,3d=8,shadow_out=6_in=99,inner_break=6,matrix=45
