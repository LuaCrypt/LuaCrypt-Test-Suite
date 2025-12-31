-- Test: __call metamethod
local results = {}

-- Test 1: Simple callable table
local t1 = setmetatable({}, {
    __call = function(self, x)
        return x * 2
    end
})
results[#results + 1] = "simple=" .. t1(5)

-- Test 2: Callable with state
local counter = setmetatable({count = 0}, {
    __call = function(self)
        self.count = self.count + 1
        return self.count
    end
})
results[#results + 1] = "state=" .. counter() .. ";" .. counter() .. ";" .. counter()

-- Test 3: Callable with multiple args
local adder = setmetatable({}, {
    __call = function(self, a, b, c)
        return (a or 0) + (b or 0) + (c or 0)
    end
})
results[#results + 1] = "multi=" .. adder(1, 2, 3)

-- Test 4: Callable returning multiple values
local multi_ret = setmetatable({}, {
    __call = function()
        return 1, 2, 3
    end
})
local a, b, c = multi_ret()
results[#results + 1] = "multi_ret=" .. a .. ";" .. b .. ";" .. c

-- Test 5: Factory pattern
local function createFactory(base)
    return setmetatable({base = base}, {
        __call = function(self, mult)
            return self.base * mult
        end
    })
end
local factory = createFactory(10)
results[#results + 1] = "factory=" .. factory(5)

-- Test 6: Nested call
local nested = setmetatable({}, {
    __call = function(self, x)
        return setmetatable({}, {
            __call = function(self2, y)
                return x + y
            end
        })
    end
})
results[#results + 1] = "nested=" .. nested(10)(20)

print(table.concat(results, ","))
-- Expected: simple=10,state=1;2;3,multi=6,multi_ret=1;2;3,factory=50,nested=30
