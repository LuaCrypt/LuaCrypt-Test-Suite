-- Test: Nested while loops
local results = {}

-- Test 1: Simple nested
local outer = 0
local total = 0
while outer < 3 do
    outer = outer + 1
    local inner = 0
    while inner < 4 do
        inner = inner + 1
        total = total + 1
    end
end
results[#results + 1] = "total=" .. total

-- Test 2: Inner depends on outer
local sum = 0
local i = 1
while i <= 4 do
    local j = 1
    while j <= i do
        sum = sum + 1
        j = j + 1
    end
    i = i + 1
end
results[#results + 1] = "triangle=" .. sum  -- 1+2+3+4=10

-- Test 3: Three levels deep
local depth1 = 0
local depth3_count = 0
while depth1 < 2 do
    depth1 = depth1 + 1
    local depth2 = 0
    while depth2 < 2 do
        depth2 = depth2 + 1
        local depth3 = 0
        while depth3 < 2 do
            depth3 = depth3 + 1
            depth3_count = depth3_count + 1
        end
    end
end
results[#results + 1] = "depth3=" .. depth3_count  -- 2*2*2=8

-- Test 4: Outer modifies inner condition variable
local x = 0
local y_total = 0
while x < 3 do
    x = x + 1
    local y = x  -- Start y at current x
    while y < 5 do
        y = y + 1
        y_total = y_total + 1
    end
end
-- x=1: y goes 1->5 (4 iterations)
-- x=2: y goes 2->5 (3 iterations)
-- x=3: y goes 3->5 (2 iterations)
results[#results + 1] = "ydep=" .. y_total  -- 4+3+2=9

print(table.concat(results, ","))
-- Expected: total=12,triangle=10,depth3=8,ydep=9
