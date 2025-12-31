-- Test: Weak tables
local results = {}

-- Test 1: Weak values
local weak_v = setmetatable({}, {__mode = "v"})
do
    local temp = {name = "temp"}
    weak_v.key = temp
    results[#results + 1] = "before_gc=" .. tostring(weak_v.key ~= nil)
end
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "after_gc_v=" .. tostring(weak_v.key == nil)

-- Test 2: Weak keys
local weak_k = setmetatable({}, {__mode = "k"})
do
    local temp = {}
    weak_k[temp] = "value"
    results[#results + 1] = "weak_k_before=" .. tostring(next(weak_k) ~= nil)
end
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "weak_k_after=" .. tostring(next(weak_k) == nil)

-- Test 3: Both weak (kv)
local weak_kv = setmetatable({}, {__mode = "kv"})
do
    local k = {}
    local v = {}
    weak_kv[k] = v
end
collectgarbage("collect")
collectgarbage("collect")
results[#results + 1] = "weak_kv=" .. tostring(next(weak_kv) == nil)

-- Test 4: String keys are not weak
local weak_v2 = setmetatable({}, {__mode = "v"})
weak_v2["string_key"] = {data = 1}
collectgarbage("collect")
-- String key keeps entry, but value might be collected
results[#results + 1] = "string_key=" .. tostring(weak_v2["string_key"] == nil)

-- Test 5: Number keys are not weak
local weak_v3 = setmetatable({}, {__mode = "v"})
do
    local temp = {x = 1}
    weak_v3[1] = temp
end
collectgarbage("collect")
results[#results + 1] = "num_key=" .. tostring(weak_v3[1] == nil)

print(table.concat(results, ","))
-- Expected: before_gc=true,after_gc_v=true,weak_k_before=true,weak_k_after=true,weak_kv=true,string_key=true,num_key=true
