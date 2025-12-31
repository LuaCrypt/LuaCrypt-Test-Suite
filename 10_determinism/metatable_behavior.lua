-- Test: Metatable behavior determinism
local results = {}

-- Test 1: __index table
local mt1 = {__index = {x = 10, y = 20}}
local t1 = setmetatable({z = 30}, mt1)
results[#results + 1] = "index_tbl=" .. t1.x .. ":" .. t1.y .. ":" .. t1.z

-- Test 2: __index function
local mt2 = {
    __index = function(t, k)
        return "default_" .. k
    end
}
local t2 = setmetatable({existing = "yes"}, mt2)
results[#results + 1] = "index_fn=" .. t2.existing .. ":" .. t2.missing

-- Test 3: __newindex
local storage = {}
local mt3 = {
    __newindex = function(t, k, v)
        storage[k] = v
    end
}
local t3 = setmetatable({}, mt3)
t3.a = 1
t3.b = 2
results[#results + 1] = "newindex=" .. storage.a .. ":" .. storage.b

-- Test 4: Arithmetic metamethods
local function make_vec(x, y)
    return setmetatable({x = x, y = y}, {
        __add = function(a, b) return make_vec(a.x + b.x, a.y + b.y) end,
        __sub = function(a, b) return make_vec(a.x - b.x, a.y - b.y) end,
        __mul = function(a, b)
            if type(b) == "number" then
                return make_vec(a.x * b, a.y * b)
            end
            return a.x * b.x + a.y * b.y
        end
    })
end
local v1 = make_vec(1, 2)
local v2 = make_vec(3, 4)
local v3 = v1 + v2
local v4 = v2 - v1
local v5 = v1 * 2
local dot = v1 * v2
results[#results + 1] = "vec_add=" .. v3.x .. ":" .. v3.y
results[#results + 1] = "vec_sub=" .. v4.x .. ":" .. v4.y
results[#results + 1] = "vec_mul=" .. v5.x .. ":" .. v5.y
results[#results + 1] = "vec_dot=" .. dot

-- Test 5: __concat
local mt5 = {
    __concat = function(a, b)
        return {val = tostring(a.val) .. tostring(b.val)}
    end,
}
local c1 = setmetatable({val = "hello"}, mt5)
local c2 = setmetatable({val = "world"}, mt5)
local c3 = c1 .. c2
results[#results + 1] = "concat=" .. c3.val

-- Test 6: __len
local mt6 = {__len = function(t) return 42 end}
local t6 = setmetatable({1, 2, 3}, mt6)
results[#results + 1] = "len=" .. #t6

-- Test 7: __call
local mt7 = {
    __call = function(t, ...)
        return select('#', ...)
    end
}
local t7 = setmetatable({}, mt7)
results[#results + 1] = "call=" .. t7(1, 2, 3, 4)

-- Test 8: __tostring
local mt8 = {
    __tostring = function(t)
        return "Custom[" .. t.val .. "]"
    end
}
local t8 = setmetatable({val = 42}, mt8)
results[#results + 1] = "tostring=" .. tostring(t8)

-- Test 9: Comparison metamethods
local mt9 = {
    __lt = function(a, b) return a.val < b.val end,
    __le = function(a, b) return a.val <= b.val end,
    __eq = function(a, b) return a.val == b.val end
}
local a9 = setmetatable({val = 1}, mt9)
local b9 = setmetatable({val = 2}, mt9)
local c9 = setmetatable({val = 1}, mt9)
results[#results + 1] = "cmp=" .. tostring(a9 < b9) .. tostring(a9 <= b9) .. tostring(a9 == c9)

-- Test 10: Chained metatables
local base = {base_method = function() return "base" end}
local derived = setmetatable({derived_method = function() return "derived" end}, {__index = base})
local obj = setmetatable({}, {__index = derived})
results[#results + 1] = "chain=" .. obj.base_method() .. ":" .. obj.derived_method()

print(table.concat(results, ","))
-- Expected: deterministic across runs
