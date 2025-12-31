-- Test: __pairs and __ipairs metamethods (Lua 5.2+)
local results = {}

-- Test 1: Custom __pairs
local t1 = setmetatable({real = "hidden"}, {
    __pairs = function(t)
        local data = {a = 1, b = 2, c = 3}
        return next, data
    end
})
local keys = {}
for k, v in pairs(t1) do
    keys[#keys + 1] = k
end
table.sort(keys)
results[#results + 1] = "pairs=" .. table.concat(keys, ";")

-- Test 2: Custom __ipairs (Lua 5.2 only, deprecated in 5.3)
-- Skip if not available
if false then  -- Usually not needed in modern Lua
    local t2 = setmetatable({}, {
        __ipairs = function(t)
            local data = {10, 20, 30}
            return function(a, i)
                i = i + 1
                if data[i] then return i, data[i] end
            end, data, 0
        end
    })
end

-- Test 3: Pairs with proxy table
local function createProxy(target)
    return setmetatable({}, {
        __pairs = function()
            return next, target
        end,
        __index = target,
        __newindex = target
    })
end
local real = {x = 10, y = 20}
local proxy = createProxy(real)
local sum = 0
for k, v in pairs(proxy) do
    sum = sum + v
end
results[#results + 1] = "proxy_pairs=" .. sum

-- Test 4: Default pairs (no metamethod)
local t4 = {a = 1, b = 2}
local count = 0
for k, v in pairs(t4) do
    count = count + 1
end
results[#results + 1] = "default=" .. count

-- Test 5: Pairs on empty custom
local t5 = setmetatable({}, {
    __pairs = function()
        return next, {}
    end
})
local empty_count = 0
for k, v in pairs(t5) do
    empty_count = empty_count + 1
end
results[#results + 1] = "empty_custom=" .. empty_count

print(table.concat(results, ","))
-- Expected: pairs=a;b;c,proxy_pairs=30,default=2,empty_custom=0
