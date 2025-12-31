-- Test: Metatable inheritance patterns
local results = {}

-- Test 1: Simple prototype chain
local Animal = {speak = function() return "..." end}
Animal.__index = Animal

local Dog = setmetatable({speak = function() return "woof" end}, {__index = Animal})
Dog.__index = Dog

local myDog = setmetatable({}, Dog)
results[#results + 1] = "proto=" .. myDog:speak()

-- Test 2: Three-level chain
local Base = {level = 1, baseMethod = function() return "base" end}
Base.__index = Base

local Middle = setmetatable({level = 2, middleMethod = function() return "middle" end}, {__index = Base})
Middle.__index = Middle

local Top = setmetatable({level = 3}, {__index = Middle})
Top.__index = Top

local obj = setmetatable({}, Top)
results[#results + 1] = "chain=" .. obj.level .. ":" .. obj:baseMethod()

-- Test 3: Shared metatable
local shared = {__index = {default = 42}}
local a = setmetatable({}, shared)
local b = setmetatable({}, shared)
a.own = 1
b.own = 2
results[#results + 1] = "shared=" .. a.default .. ";" .. b.default .. ":" .. a.own .. ";" .. b.own

-- Test 4: Override in child
local Parent = {value = "parent"}
Parent.__index = Parent

local Child = setmetatable({value = "child"}, {__index = Parent})
Child.__index = Child

local instance = setmetatable({}, Child)
results[#results + 1] = "override=" .. instance.value

-- Test 5: Call parent method
local Vehicle = {
    wheels = 4,
    describe = function(self)
        return "Vehicle with " .. self.wheels .. " wheels"
    end
}
Vehicle.__index = Vehicle

local Car = setmetatable({
    describe = function(self)
        return "Car: " .. Vehicle.describe(self)  -- Call parent
    end
}, {__index = Vehicle})
Car.__index = Car

local myCar = setmetatable({wheels = 4}, Car)
results[#results + 1] = "super=" .. string.sub(myCar:describe(), 1, 8)

print(table.concat(results, ","))
-- Expected: proto=woof,chain=3:base,shared=42;42:1;2,override=child,super=Car: Veh
