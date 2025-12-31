-- Test: __len metamethod
local results = {}

-- Test 1: Custom length
local t1 = setmetatable({1, 2, 3}, {
    __len = function(t)
        return 100
    end
})
results[#results + 1] = "custom=" .. #t1

-- Test 2: Length based on content
local t2 = setmetatable({items = {1, 2, 3, 4, 5}}, {
    __len = function(t)
        return #t.items
    end
})
results[#results + 1] = "content=" .. #t2

-- Test 3: Zero length
local t3 = setmetatable({1, 2, 3}, {
    __len = function()
        return 0
    end
})
results[#results + 1] = "zero=" .. #t3

-- Test 4: Without __len (default behavior)
local t4 = setmetatable({1, 2, 3}, {})
results[#results + 1] = "default=" .. #t4

-- Test 5: Length from closure state
local function makeCountedTable()
    local count = 0
    return setmetatable({}, {
        __newindex = function(t, k, v)
            count = count + 1
            rawset(t, k, v)
        end,
        __len = function()
            return count
        end
    })
end
local t5 = makeCountedTable()
t5.a = 1
t5.b = 2
t5.c = 3
results[#results + 1] = "counted=" .. #t5

-- Note: __len for tables was added in Lua 5.2
-- In Lua 5.1, # always uses raw length

print(table.concat(results, ","))
-- Expected varies by Lua version
