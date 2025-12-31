-- Test: Object-oriented programming patterns
local results = {}

-- Test 1: Basic class pattern
local function class()
    local cls = {}
    cls.__index = cls
    function cls:new(...)
        local instance = setmetatable({}, cls)
        if instance.init then
            instance:init(...)
        end
        return instance
    end
    return cls
end

local Animal = class()
function Animal:init(name)
    self.name = name
end
function Animal:speak()
    return self.name .. " makes a sound"
end

local animal = Animal:new("Generic")
results[#results + 1] = "class=" .. animal:speak()

-- Test 2: Inheritance
local function extends(parent)
    local cls = class()
    setmetatable(cls, {__index = parent})
    return cls
end

local Dog = extends(Animal)
function Dog:speak()
    return self.name .. " barks"
end

local dog = Dog:new("Rex")
results[#results + 1] = "inherit=" .. dog:speak()

-- Test 3: Super call
local Cat = extends(Animal)
function Cat:speak()
    local parent_speech = Animal.speak(self)
    return parent_speech .. " and meows"
end

local cat = Cat:new("Whiskers")
results[#results + 1] = "super=" .. cat:speak()

-- Test 4: Multiple levels
local Kitten = extends(Cat)
function Kitten:speak()
    return "tiny " .. Cat.speak(self)
end

local kitten = Kitten:new("Fluffy")
results[#results + 1] = "deep=" .. kitten:speak()

-- Test 5: instanceof pattern
local function instanceof(obj, cls)
    local mt = getmetatable(obj)
    while mt do
        if mt == cls then return true end
        mt = getmetatable(mt)
    end
    return false
end

results[#results + 1] = "instanceof=" ..
    tostring(instanceof(dog, Dog)) .. ":" ..
    tostring(instanceof(dog, Animal)) .. ":" ..
    tostring(instanceof(cat, Dog))

-- Test 6: Method chaining
local Builder = class()
function Builder:init()
    self.parts = {}
end
function Builder:add(part)
    self.parts[#self.parts + 1] = part
    return self
end
function Builder:build()
    return table.concat(self.parts, "+")
end

local built = Builder:new():add("A"):add("B"):add("C"):build()
results[#results + 1] = "chain=" .. built

-- Test 7: Private via closure
local function createPerson(name, age)
    local private_age = age

    local self = {}
    self.name = name

    function self:getAge()
        return private_age
    end

    function self:birthday()
        private_age = private_age + 1
    end

    return self
end

local person = createPerson("Alice", 30)
person:birthday()
results[#results + 1] = "private=" .. person.name .. ":" .. person:getAge()

-- Test 8: Static methods
local Counter = class()
Counter.count = 0

function Counter:init()
    Counter.count = Counter.count + 1
    self.id = Counter.count
end

function Counter.getTotal()
    return Counter.count
end

Counter:new()
Counter:new()
Counter:new()
results[#results + 1] = "static=" .. Counter.getTotal()

-- Test 9: Abstract method pattern
local Shape = class()
function Shape:area()
    error("abstract method")
end
function Shape:describe()
    return "Area: " .. self:area()
end

local Rectangle = extends(Shape)
function Rectangle:init(w, h)
    self.width = w
    self.height = h
end
function Rectangle:area()
    return self.width * self.height
end

local rect = Rectangle:new(4, 5)
results[#results + 1] = "abstract=" .. rect:describe()

-- Test 10: Composition over inheritance
local function createEngine()
    return {
        start = function() return "engine started" end
    }
end
local function createWheels()
    return {
        roll = function() return "wheels rolling" end
    }
end
local function createCar()
    local engine = createEngine()
    local wheels = createWheels()

    return {
        drive = function()
            return engine.start() .. ", " .. wheels.roll()
        end
    }
end

local car = createCar()
results[#results + 1] = "compose=" .. car.drive()

print(table.concat(results, ","))
-- Expected: class=Generic makes a sound,inherit=Rex barks,super=Whiskers makes a sound and meows,deep=tiny Fluffy makes a sound and meows,instanceof=true:true:false,chain=A+B+C,private=Alice:31,static=3,abstract=Area: 20,compose=engine started, wheels rolling
