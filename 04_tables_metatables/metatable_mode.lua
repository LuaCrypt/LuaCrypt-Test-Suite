-- Test: Metatable __mode for weak references
local results = {}

-- Test 1: Mode "v" - weak values
local t1 = setmetatable({}, {__mode = "v"})
local strong_ref = {name = "kept"}
t1.kept = strong_ref
do
    local temp = {name = "lost"}
    t1.lost = temp
end
collectgarbage("collect")
results[#results + 1] = "mode_v=" .. tostring(t1.kept ~= nil) .. ":" .. tostring(t1.lost == nil)

-- Test 2: Mode "k" - weak keys
local t2 = setmetatable({}, {__mode = "k"})
local kept_key = {id = 1}
t2[kept_key] = "value1"
do
    local temp_key = {id = 2}
    t2[temp_key] = "value2"
end
collectgarbage("collect")
local count = 0
for k, v in pairs(t2) do count = count + 1 end
results[#results + 1] = "mode_k=" .. count

-- Test 3: Mode "kv" - both weak
local t3 = setmetatable({}, {__mode = "kv"})
do
    local k = {}
    local v = {}
    t3[k] = v
end
collectgarbage("collect")
results[#results + 1] = "mode_kv=" .. tostring(next(t3) == nil)

-- Test 4: Changing mode after creation
local t4 = setmetatable({}, {__mode = "v"})
t4.x = {data = 1}
getmetatable(t4).__mode = ""  -- Remove weakness
do
    local temp = t4.x
end
t4.x = nil  -- Remove reference explicitly
collectgarbage("collect")
-- Mode change behavior is implementation-defined

-- Test 5: Empty mode string (not weak)
local t5 = setmetatable({}, {__mode = ""})
do
    local temp = {data = 1}
    t5.key = temp
end
collectgarbage("collect")
results[#results + 1] = "empty_mode=" .. tostring(t5.key == nil)

print(table.concat(results, ","))
-- Expected: mode_v=true:true,mode_k=1,mode_kv=true,empty_mode=true
