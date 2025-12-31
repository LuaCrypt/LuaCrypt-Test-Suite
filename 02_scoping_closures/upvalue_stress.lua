-- Test: Stress tests for upvalue handling
local results = {}

-- Test 1: Many upvalues in single closure
local u1, u2, u3, u4, u5, u6, u7, u8, u9, u10 = 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
local function sumAll()
    return u1 + u2 + u3 + u4 + u5 + u6 + u7 + u8 + u9 + u10
end
results[#results + 1] = "ten_upvals=" .. sumAll()

-- Test 2: Deeply nested function creation
local function d1()
    local v1 = 1
    local function d2()
        local v2 = 2
        local function d3()
            local v3 = 3
            local function d4()
                local v4 = 4
                local function d5()
                    return v1 + v2 + v3 + v4
                end
                return d5
            end
            return d4
        end
        return d3
    end
    return d2
end
results[#results + 1] = "deep_nest=" .. d1()()()()()

-- Test 3: Many closures modifying same upvalue
local shared = 0
local mods = {}
for i = 1, 10 do
    mods[i] = function()
        shared = shared + i
    end
end
for i = 1, 10 do
    mods[i]()
end
results[#results + 1] = "many_mods=" .. shared

-- Test 4: Large number of independent closures
local makers = {}
for i = 1, 20 do
    local val = i
    makers[i] = function() return val end
end
local sum = 0
for i = 1, 20 do
    sum = sum + makers[i]()
end
results[#results + 1] = "many_closures=" .. sum

-- Test 5: Rapid upvalue modification
local rapid = 0
local function inc() rapid = rapid + 1 end
for i = 1, 100 do
    inc()
end
results[#results + 1] = "rapid=" .. rapid

print(table.concat(results, ","))
-- Expected: ten_upvals=55,deep_nest=10,many_mods=55,many_closures=210,rapid=100
