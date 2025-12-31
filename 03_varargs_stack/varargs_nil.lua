-- Test: Nil handling in varargs
local results = {}

-- Test 1: Trailing nils counted by select
local function countWithSelect(...)
    return select("#", ...)
end
results[#results + 1] = "trailing=" .. countWithSelect(1, 2, nil, nil)

-- Test 2: Trailing nils lost in table constructor
local function countWithTable(...)
    local t = {...}
    return #t
end
results[#results + 1] = "table_trailing=" .. countWithTable(1, 2, nil, nil)

-- Test 3: Middle nils
results[#results + 1] = "middle_select=" .. countWithSelect(1, nil, 3)
results[#results + 1] = "middle_table=" .. countWithTable(1, nil, 3)

-- Test 4: All nils
results[#results + 1] = "all_nil=" .. countWithSelect(nil, nil, nil)

-- Test 5: Preserving nils with table.pack (if available)
local function packVarargs(...)
    local t = table.pack and table.pack(...) or {n = select("#", ...), ...}
    return t.n or #t
end
results[#results + 1] = "pack=" .. packVarargs(1, nil, 3, nil)

-- Test 6: Iterating with nils using select
local function iterateAll(...)
    local values = {}
    local n = select("#", ...)
    for i = 1, n do
        local v = select(i, ...)
        values[#values + 1] = tostring(v)
    end
    return table.concat(values, ";")
end
results[#results + 1] = "iterate=" .. iterateAll(1, nil, "three", nil)

print(table.concat(results, ","))
-- Expected: trailing=4,table_trailing=2,middle_select=3,middle_table=3,all_nil=3,pack=4,iterate=1;nil;three;nil
