-- Test: Mixed control flow structures
local results = {}

-- Test 1: While inside for
local total = 0
for i = 1, 3 do
    local j = 0
    while j < i do
        j = j + 1
        total = total + 1
    end
end
results[#results + 1] = "for_while=" .. total  -- 1+2+3=6

-- Test 2: For inside while
local sum = 0
local outer = 0
while outer < 3 do
    outer = outer + 1
    for i = 1, outer do
        sum = sum + i
    end
end
results[#results + 1] = "while_for=" .. sum  -- 1+(1+2)+(1+2+3)=10

-- Test 3: Repeat inside for
local repeat_count = 0
for i = 1, 3 do
    local r = 0
    repeat
        r = r + 1
        repeat_count = repeat_count + 1
    until r >= i
end
results[#results + 1] = "for_repeat=" .. repeat_count  -- 1+2+3=6

-- Test 4: Complex nesting
local complex = 0
for a = 1, 2 do
    local b = 0
    while b < 2 do
        b = b + 1
        for c = 1, 2 do
            local d = 0
            repeat
                d = d + 1
                complex = complex + 1
            until d >= 2
        end
    end
end
results[#results + 1] = "complex=" .. complex  -- 2*2*2*2=16

-- Test 5: Break in mixed nesting
local break_count = 0
for i = 1, 5 do
    local j = 0
    while j < 5 do
        j = j + 1
        break_count = break_count + 1
        if j >= 2 then break end
    end
    if i >= 3 then break end
end
results[#results + 1] = "mixed_break=" .. break_count  -- 3*2=6

print(table.concat(results, ","))
-- Expected: for_while=6,while_for=10,for_repeat=6,complex=16,mixed_break=6
