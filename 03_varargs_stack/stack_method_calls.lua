-- Test: Stack effects with method calls
local results = {}

local obj = {
    value = 10,
    pair = function(self)
        return self.value, self.value * 2
    end,
    triple = function(self)
        return 1, 2, 3
    end,
    sum = function(self, a, b, c)
        return (a or 0) + (b or 0) + (c or 0)
    end
}

-- Test 1: Method returning multiple values
local a, b = obj:pair()
results[#results + 1] = "method_multi=" .. a .. ";" .. b

-- Test 2: Method result as args
results[#results + 1] = "as_args=" .. obj:sum(obj:triple())

-- Test 3: Method result in middle
local function four()
    return 4
end
results[#results + 1] = "middle=" .. obj:sum(obj:pair(), four())

-- Test 4: Chained method (single value)
local chain = {
    get = function(self)
        return self, 100
    end,
    value = 42
}
local c1, c2 = chain:get()
results[#results + 1] = "chain=" .. c1.value .. ";" .. c2

-- Test 5: Method in table constructor
local t = {obj:triple()}
results[#results + 1] = "in_table=" .. #t

-- Test 6: Parallel assignment from methods
local function methodPair(o)
    return o:pair()
end
local x, y = methodPair(obj)
results[#results + 1] = "parallel=" .. x .. ";" .. y

print(table.concat(results, ","))
-- Expected: method_multi=10;20,as_args=6,middle=14,chain=42;100,in_table=3,parallel=10;20
