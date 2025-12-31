-- Test: Edge cases in numeric for loops
local results = {}

-- Test 1: Large range
local count = 0
for i = 1, 1000 do
    count = count + 1
end
results[#results + 1] = "large=" .. count

-- Test 2: Negative range
local sum = 0
for i = -5, -1 do
    sum = sum + i
end
results[#results + 1] = "neg_range=" .. sum  -- -5-4-3-2-1=-15

-- Test 3: Crossing zero
local cross = {}
for i = -2, 2 do
    cross[#cross + 1] = i
end
results[#results + 1] = "cross=" .. table.concat(cross, ";")

-- Test 4: Fractional step (Lua allows this)
local frac = {}
for i = 0, 1, 0.25 do
    frac[#frac + 1] = i
end
results[#results + 1] = "frac=" .. table.concat(frac, ";")

-- Test 5: Very small step
local tiny_count = 0
for i = 0, 0.1, 0.01 do
    tiny_count = tiny_count + 1
end
results[#results + 1] = "tiny=" .. tiny_count

-- Test 6: Loop variable is local and cannot be modified persistently
local last_val = 0
for i = 1, 5 do
    last_val = i
    i = 100  -- This does NOT affect the loop
end
results[#results + 1] = "immutable=" .. last_val

print(table.concat(results, ","))
-- Expected: large=1000,neg_range=-15,cross=-2;-1;0;1;2,frac=0;0.25;0.5;0.75;1,tiny=11,immutable=5
