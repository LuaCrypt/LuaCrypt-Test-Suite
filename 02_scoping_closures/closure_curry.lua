-- Test: Currying and partial application with closures
local results = {}

-- Test 1: Simple currying
local function curry2(fn)
    return function(a)
        return function(b)
            return fn(a, b)
        end
    end
end

local add = curry2(function(a, b) return a + b end)
results[#results + 1] = "curry=" .. add(3)(4)

-- Test 2: Three-argument curry
local function curry3(fn)
    return function(a)
        return function(b)
            return function(c)
                return fn(a, b, c)
            end
        end
    end
end

local sum3 = curry3(function(a, b, c) return a + b + c end)
results[#results + 1] = "curry3=" .. sum3(1)(2)(3)

-- Test 3: Partial application
local function partial(fn, fixedArg)
    return function(...)
        return fn(fixedArg, ...)
    end
end

local function greet(greeting, name)
    return greeting .. " " .. name
end
local hello = partial(greet, "Hello")
results[#results + 1] = "partial=" .. hello("World")

-- Test 4: Partial with multiple fixed args
local function partial2(fn, a, b)
    return function(c)
        return fn(a, b, c)
    end
end

local function calc(a, b, c)
    return a * b + c
end
local calc_5_10 = partial2(calc, 5, 10)
results[#results + 1] = "partial2=" .. calc_5_10(3)

-- Test 5: Curried comparison
local function curryCompare(op)
    return function(a)
        return function(b)
            if op == "gt" then return a > b
            elseif op == "lt" then return a < b
            else return a == b end
        end
    end
end
local gt5 = curryCompare("gt")(5)
results[#results + 1] = "curry_cmp=" .. tostring(gt5(3)) .. ";" .. tostring(gt5(7))

-- Test 6: Composition with currying
local function pipe(...)
    local fns = {...}
    return function(x)
        local result = x
        for _, fn in ipairs(fns) do
            result = fn(result)
        end
        return result
    end
end

local pipeline = pipe(
    function(x) return x + 1 end,
    function(x) return x * 2 end,
    function(x) return x - 3 end
)
results[#results + 1] = "pipe=" .. pipeline(5)

print(table.concat(results, ","))
-- Expected: curry=7,curry3=6,partial=Hello World,partial2=53,curry_cmp=true;false,pipe=9
