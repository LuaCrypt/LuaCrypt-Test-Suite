-- Test: Closure identity and equality
local results = {}

-- Test 1: Same closure reference
local function makeFunc()
    return function() return 1 end
end
local f1 = makeFunc()
local f2 = f1  -- Same reference
results[#results + 1] = "same_ref=" .. tostring(f1 == f2)

-- Test 2: Different closures (same code, different instances)
local f3 = makeFunc()
local f4 = makeFunc()
results[#results + 1] = "diff_inst=" .. tostring(f3 == f4)

-- Test 3: Closure identity in table
local closures = {}
for i = 1, 3 do
    closures[i] = function() return i end
end
results[#results + 1] = "tbl_diff=" .. tostring(closures[1] == closures[2])

-- Test 4: Finding closure in table
local target = closures[2]
local found = false
for i, f in ipairs(closures) do
    if f == target then
        found = i
        break
    end
end
results[#results + 1] = "found=" .. tostring(found)

-- Test 5: Closure as table key
local funcKeys = {}
local key1 = function() end
local key2 = function() end
funcKeys[key1] = "value1"
funcKeys[key2] = "value2"
results[#results + 1] = "func_key=" .. funcKeys[key1]

-- Test 6: Same factory, independent closures
local function factory()
    local x = 0
    return function()
        x = x + 1
        return x
    end
end
local c1 = factory()
local c2 = factory()
c1(); c1(); c1()
c2()
results[#results + 1] = "independent=" .. tostring(c1 == c2) .. "_vals=" .. c1() .. ";" .. c2()

print(table.concat(results, ","))
-- Expected: same_ref=true,diff_inst=false,tbl_diff=false,found=2,func_key=value1,independent=false_vals=4;2
