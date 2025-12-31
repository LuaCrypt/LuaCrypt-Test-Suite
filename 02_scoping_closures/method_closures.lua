-- Test: Methods and closures
local results = {}

-- Test 1: Method capturing self
local obj1 = {
    value = 10,
    getValue = function(self)
        return self.value
    end
}
results[#results + 1] = "method=" .. obj1:getValue()

-- Test 2: Closure returning method
local function makeObject(initial)
    local self = {value = initial}
    self.getValue = function()
        return self.value
    end
    self.setValue = function(v)
        self.value = v
    end
    return self
end
local obj2 = makeObject(100)
results[#results + 1] = "closure_method=" .. obj2.getValue()
obj2.setValue(200)
results[#results + 1] = "after_set=" .. obj2.getValue()

-- Test 3: Method with upvalue (not self)
local multiplier = 2
local obj3 = {
    value = 5,
    getMultiplied = function(self)
        return self.value * multiplier
    end
}
results[#results + 1] = "upval_method=" .. obj3:getMultiplied()
multiplier = 10
results[#results + 1] = "upval_changed=" .. obj3:getMultiplied()

-- Test 4: Storing method reference
local obj4 = {
    value = 42,
    getValue = function(self)
        return self.value
    end
}
local method = obj4.getValue
results[#results + 1] = "stored=" .. method(obj4)

-- Test 5: Method returning closure
local obj5 = {
    base = 100,
    makeAdder = function(self)
        local b = self.base
        return function(n)
            return b + n
        end
    end
}
local adder = obj5:makeAdder()
results[#results + 1] = "method_closure=" .. adder(50)

print(table.concat(results, ","))
-- Expected: method=10,closure_method=100,after_set=200,upval_method=10,upval_changed=50,stored=42,method_closure=150
