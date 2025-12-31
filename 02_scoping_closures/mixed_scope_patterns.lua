-- Test: Mixed scoping patterns
local results = {}

-- Test 1: Local in condition
local x = 10
if true then
    local x = 20
    if true then
        local x = 30
        results[#results + 1] = "cond_inner=" .. x
    end
    results[#results + 1] = "cond_mid=" .. x
end
results[#results + 1] = "cond_outer=" .. x

-- Test 2: Closure capturing loop control variable
local funcs = {}
for i = 1, 3 do
    local j = i  -- Make copy
    funcs[i] = function()
        return j
    end
end
for i = 1, 3 do
    results[#results + 1] = "cap" .. i .. "=" .. funcs[i]()
end

-- Test 3: Recursive with accumulator closure
local function makeRecSum()
    local total = 0
    local function rec(n)
        if n <= 0 then
            return total
        end
        total = total + n
        return rec(n - 1)
    end
    return rec
end
local recSum = makeRecSum()
results[#results + 1] = "rec_sum=" .. recSum(5)

-- Test 4: Multiple return with closures
local function multiClosures()
    local x = 1
    local y = 2
    return function() x = x + 1; return x end,
           function() y = y + 1; return y end
end
local fx, fy = multiClosures()
results[#results + 1] = "multi=" .. fx() .. ";" .. fy() .. ";" .. fx()

-- Test 5: Closure modifies outer's local
local function outer()
    local value = 0
    local function modifier()
        value = 100
    end
    modifier()
    return value
end
results[#results + 1] = "mod_outer=" .. outer()

print(table.concat(results, ","))
-- Expected: cond_inner=30,cond_mid=20,cond_outer=10,cap1=1,cap2=2,cap3=3,rec_sum=15,multi=2;3;3,mod_outer=100
