-- Test: Deterministic behavior with fixed seed
local results = {}

-- Test 1: Same seed produces same random sequence
math.randomseed(12345)
local seq1 = {}
for i = 1, 10 do
    seq1[i] = math.random(1000)
end

math.randomseed(12345)
local seq2 = {}
for i = 1, 10 do
    seq2[i] = math.random(1000)
end

local same = true
for i = 1, 10 do
    if seq1[i] ~= seq2[i] then same = false break end
end
results[#results + 1] = "same_seq=" .. tostring(same)

-- Test 2: Different seeds produce different sequences
math.randomseed(12345)
local a = math.random(1000)
math.randomseed(54321)
local b = math.random(1000)
results[#results + 1] = "diff_seed=" .. tostring(a ~= b)

-- Test 3: Random in consistent order
math.randomseed(99999)
local order = {}
for i = 1, 5 do
    order[#order + 1] = math.random(100)
end
results[#results + 1] = "order=" .. table.concat(order, ":")

-- Test 4: Random float consistency
math.randomseed(11111)
local floats = {}
for i = 1, 5 do
    floats[#floats + 1] = math.floor(math.random() * 1000)
end
results[#results + 1] = "floats=" .. table.concat(floats, ":")

-- Test 5: Random range consistency
math.randomseed(22222)
local ranges = {}
for i = 1, 5 do
    ranges[#ranges + 1] = math.random(10, 20)
end
results[#results + 1] = "ranges=" .. table.concat(ranges, ":")

-- Test 6: Hash consistency (table iteration order may vary, but hashes don't)
local function simple_hash(s)
    local h = 0
    for i = 1, #s do
        h = (h * 31 + s:byte(i)) % 1000000
    end
    return h
end
results[#results + 1] = "hash=" .. simple_hash("deterministic test string")

-- Test 7: Computation consistency
local function compute(n)
    local result = 0
    for i = 1, n do
        result = result + math.sin(i) * math.cos(i)
    end
    return math.floor(result * 1000)
end
results[#results + 1] = "compute=" .. compute(100)

-- Test 8: String operations consistency
local s = "hello world"
results[#results + 1] = "str_hash=" .. (s:byte(1) + s:byte(6) + #s)

-- Test 9: Table operations consistency
local t = {3, 1, 4, 1, 5, 9, 2, 6}
table.sort(t)
results[#results + 1] = "sort=" .. table.concat(t, "")

-- Test 10: Pattern matching consistency
local text = "abc123def456"
local nums = {}
for n in text:gmatch("%d+") do
    nums[#nums + 1] = n
end
results[#results + 1] = "pattern=" .. table.concat(nums, "+")

print(table.concat(results, ","))
-- Output should be identical across runs with same Lua version
