-- Test: Error level parameter
local results = {}

-- Test 1: Level 0 - no location info
local ok1, err1 = pcall(function()
    error("msg", 0)
end)
results[#results + 1] = "l0=" .. (err1 == "msg" and "exact" or "modified")

-- Test 2: Level 1 - current function (default)
local function level1()
    error("msg", 1)
end
local ok2, err2 = pcall(level1)
results[#results + 1] = "l1=" .. (string.find(err2, "level1") and "found" or "not_found")

-- Test 3: Level 2 - caller
local function innerLevel2()
    error("msg", 2)
end
local function outerLevel2()
    innerLevel2()
end
local ok3, err3 = pcall(outerLevel2)
-- Error should point to outerLevel2, not innerLevel2
results[#results + 1] = "l2=" .. (string.find(err3, "outer") and "outer" or "other")

-- Test 4: Level 3 - caller's caller
local function deep3()
    error("msg", 3)
end
local function mid3()
    deep3()
end
local function top3()
    mid3()
end
local ok4, err4 = pcall(top3)
results[#results + 1] = "l3=" .. (string.find(err4, "top3") and "top" or "other")

-- Test 5: Level too high (falls back)
local function tooHigh()
    error("msg", 100)
end
local ok5, err5 = pcall(tooHigh)
results[#results + 1] = "high=" .. tostring(ok5)

print(table.concat(results, ","))
-- Expected: l0=exact,l1=found,l2=outer,l3=top,high=false
