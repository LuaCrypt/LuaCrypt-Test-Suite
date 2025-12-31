-- Test: Table copying patterns
local results = {}

-- Test 1: Shallow copy
local function shallowCopy(t)
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = v
    end
    return copy
end
local orig1 = {a = 1, b = 2, c = {nested = true}}
local copy1 = shallowCopy(orig1)
copy1.a = 100
results[#results + 1] = "shallow=" .. orig1.a .. ":" .. copy1.a

-- Test 2: Shallow copy shares nested tables
copy1.c.nested = false
results[#results + 1] = "shared_nested=" .. tostring(orig1.c.nested)

-- Test 3: Deep copy
local function deepCopy(t)
    if type(t) ~= "table" then return t end
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = deepCopy(v)
    end
    return copy
end
local orig3 = {a = 1, inner = {x = 10}}
local copy3 = deepCopy(orig3)
copy3.inner.x = 999
results[#results + 1] = "deep=" .. orig3.inner.x .. ":" .. copy3.inner.x

-- Test 4: Copy preserving metatable
local function copyWithMeta(t)
    local copy = {}
    for k, v in pairs(t) do
        copy[k] = v
    end
    return setmetatable(copy, getmetatable(t))
end
local mt = {__index = {default = 42}}
local orig4 = setmetatable({a = 1}, mt)
local copy4 = copyWithMeta(orig4)
results[#results + 1] = "meta_copy=" .. copy4.default

-- Test 5: Array-only copy
local function arrayCopy(t)
    local copy = {}
    for i = 1, #t do
        copy[i] = t[i]
    end
    return copy
end
local arr = {1, 2, 3, 4, 5}
local arrCopy = arrayCopy(arr)
arrCopy[1] = 100
results[#results + 1] = "array_copy=" .. arr[1] .. ":" .. arrCopy[1]

print(table.concat(results, ","))
-- Expected: shallow=1:100,shared_nested=false,deep=10:999,meta_copy=42,array_copy=1:100
