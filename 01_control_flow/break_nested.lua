-- Test: Break in nested loops (only breaks innermost)
local results = {}

-- Test 1: Break in nested while
local outer = 0
local total_inner = 0
while outer < 5 do
    outer = outer + 1
    local inner = 0
    while true do
        inner = inner + 1
        total_inner = total_inner + 1
        if inner >= 3 then
            break  -- Only breaks inner loop
        end
    end
end
results[#results + 1] = "while=" .. outer .. ":" .. total_inner

-- Test 2: Break in nested for
local outer2 = 0
local inner2_total = 0
for i = 1, 4 do
    outer2 = outer2 + 1
    for j = 1, 100 do
        inner2_total = inner2_total + 1
        if j >= 2 then break end
    end
end
results[#results + 1] = "for=" .. outer2 .. ":" .. inner2_total

-- Test 3: Break in 3 levels deep (only innermost)
local d1, d2, d3 = 0, 0, 0
for i = 1, 3 do
    d1 = d1 + 1
    for j = 1, 3 do
        d2 = d2 + 1
        for k = 1, 100 do
            d3 = d3 + 1
            if k >= 2 then break end
        end
    end
end
results[#results + 1] = "d3=" .. d1 .. ":" .. d2 .. ":" .. d3

-- Test 4: Mixed loop types
local mixed_outer = 0
local mixed_inner = 0
for i = 1, 3 do
    mixed_outer = mixed_outer + 1
    local j = 0
    repeat
        j = j + 1
        mixed_inner = mixed_inner + 1
        if j >= 2 then break end
    until false
end
results[#results + 1] = "mixed=" .. mixed_outer .. ":" .. mixed_inner

print(table.concat(results, ","))
-- Expected: while=5:15,for=4:8,d3=3:9:18,mixed=3:6
