-- Test: Varargs with methods
local results = {}

-- Test 1: Method with varargs
local obj = {
    value = 10,
    addAll = function(self, ...)
        local sum = self.value
        for i = 1, select("#", ...) do
            sum = sum + select(i, ...)
        end
        return sum
    end
}
results[#results + 1] = "method=" .. obj:addAll(1, 2, 3)

-- Test 2: Forward varargs from method
obj.forward = function(self, ...)
    return self:addAll(...)
end
results[#results + 1] = "forward=" .. obj:forward(5, 10, 15)

-- Test 3: Method returning varargs
obj.getMulti = function(self)
    return self.value, self.value * 2, self.value * 3
end
local a, b, c = obj:getMulti()
results[#results + 1] = "multi_ret=" .. a .. ";" .. b .. ";" .. c

-- Test 4: Chain methods with varargs
obj.process = function(self, ...)
    local result = {...}
    for i = 1, #result do
        result[i] = result[i] * self.value
    end
    local unpack_fn = table.unpack or unpack
    return unpack_fn(result)
end
local x, y, z = obj:process(1, 2, 3)
results[#results + 1] = "process=" .. (x or "nil") .. ";" .. (y or "nil") .. ";" .. (z or "nil")

-- Test 5: Varargs with self parameter
local function createMultiplier(base)
    return {
        base = base,
        multiply = function(self, ...)
            local results = {}
            for i = 1, select("#", ...) do
                results[i] = select(i, ...) * self.base
            end
            local unpack_fn = table.unpack or unpack
            return unpack_fn(results)
        end
    }
end
local mult = createMultiplier(5)
local m1, m2, m3 = mult:multiply(2, 4, 6)
results[#results + 1] = "mult=" .. (m1 or "nil") .. ";" .. (m2 or "nil") .. ";" .. (m3 or "nil")

print(table.concat(results, ","))
-- Expected: method=16,forward=40,multi_ret=10;20;30,process=10;20;30,mult=10;20;30
