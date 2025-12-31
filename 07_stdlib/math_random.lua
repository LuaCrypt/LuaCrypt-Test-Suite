-- Test: Math random with determinism (seeded)
local results = {}

-- Seed for determinism
math.randomseed(12345)

-- Test 1: Random without args (0-1)
local r1 = math.random()
results[#results + 1] = "float=" .. (r1 >= 0 and r1 < 1 and "valid" or "invalid")

-- Test 2: Random with max
local r2 = math.random(10)
results[#results + 1] = "max=" .. (r2 >= 1 and r2 <= 10 and "valid" or "invalid")

-- Test 3: Random with range
local r3 = math.random(5, 15)
results[#results + 1] = "range=" .. (r3 >= 5 and r3 <= 15 and "valid" or "invalid")

-- Test 4: Multiple calls distribution
local counts = {0, 0, 0, 0, 0, 0}
for i = 1, 600 do
    local r = math.random(1, 6)
    counts[r] = counts[r] + 1
end
local all_hit = true
for i = 1, 6 do
    if counts[i] == 0 then all_hit = false end
end
results[#results + 1] = "dist=" .. (all_hit and "good" or "bad")

-- Test 5: Same seed produces same sequence
math.randomseed(99999)
local seq1 = {}
for i = 1, 5 do
    seq1[i] = math.random(100)
end
math.randomseed(99999)
local seq2 = {}
for i = 1, 5 do
    seq2[i] = math.random(100)
end
local same = true
for i = 1, 5 do
    if seq1[i] ~= seq2[i] then same = false end
end
results[#results + 1] = "seed=" .. (same and "same" or "diff")

-- Test 6: Negative range (Lua 5.3+)
local neg_ok = pcall(function()
    local r = math.random(-10, -5)
    return r >= -10 and r <= -5
end)
results[#results + 1] = "neg=" .. (neg_ok and "ok" or "skip")

-- Test 7: Large range
local r7 = math.random(1, 1000000)
results[#results + 1] = "large=" .. (r7 >= 1 and r7 <= 1000000 and "valid" or "invalid")

-- Test 8: Range of 1
local r8 = math.random(42, 42)
results[#results + 1] = "one=" .. r8

-- Test 9: Integer type check
local r9 = math.random(1, 100)
results[#results + 1] = "int=" .. (r9 == math.floor(r9) and "yes" or "no")

print(table.concat(results, ","))
-- Expected: float=valid,max=valid,range=valid,dist=good,seed=same,neg=ok,large=valid,one=42,int=yes
