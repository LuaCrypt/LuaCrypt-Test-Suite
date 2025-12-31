-- Edge cases for repeat-until scope and control flow
-- Tests: variable scope in until condition, break behavior, nested patterns

local results = {}

-- Test 1: Basic repeat-until
local i = 0
repeat
    i = i + 1
until i >= 5
results[#results + 1] = i  -- 5

-- Test 2: Variable declared in repeat visible in until
local j = 0
repeat
    j = j + 1
    local stop = (j >= 3)
until stop
results[#results + 1] = j  -- 3

-- Test 3: Multiple locals in repeat body visible in until
local k = 0
repeat
    k = k + 1
    local a = k
    local b = k * 2
    local should_stop = (a + b >= 9)  -- 3 + 6 = 9
until should_stop
results[#results + 1] = k  -- 3

-- Test 4: Break in repeat-until
local m = 0
repeat
    m = m + 1
    if m == 3 then break end
until m >= 10
results[#results + 1] = m  -- 3

-- Test 5: Nested repeat-until
local outer = 0
local inner_count = 0
repeat
    outer = outer + 1
    local inner = 0
    repeat
        inner = inner + 1
        inner_count = inner_count + 1
    until inner >= 2
until outer >= 3
results[#results + 1] = inner_count  -- 6 (2 iterations x 3 outer)

-- Test 6: Repeat with always-true condition (single iteration)
local single = 0
repeat
    single = single + 1
until true
results[#results + 1] = single  -- 1

-- Test 7: Repeat with function call in condition
local function check(val)
    return val >= 5
end

local n = 0
repeat
    n = n + 1
until check(n)
results[#results + 1] = n  -- 5

-- Test 8: Local shadowing in repeat
local x = 100
repeat
    local x = 1  -- shadows outer x
    x = x + 1    -- modifies local x
until x > 1      -- uses local x (which is 2)
results[#results + 1] = x  -- 100 (outer x unchanged)

-- Test 9: Upvalue capture in repeat
local closures = {}
local idx = 0
repeat
    idx = idx + 1
    local captured = idx
    closures[idx] = function() return captured end
until idx >= 3

results[#results + 1] = closures[1]()  -- 1
results[#results + 1] = closures[2]()  -- 2
results[#results + 1] = closures[3]()  -- 3

-- Test 10: Complex condition with multiple locals
local p = 0
repeat
    p = p + 1
    local a = p
    local b = p + 1
    local c = p + 2
until a > 2 and b > 3 and c > 4  -- p=3: a=3, b=4, c=5
results[#results + 1] = p  -- 3

-- Test 11: Repeat with goto
local q = 0
repeat
    q = q + 1
    if q == 2 then
        goto continue_repeat
    end
    q = q + 10
    ::continue_repeat::
until q >= 15
results[#results + 1] = q  -- 23 (1+10=11, 12 skips, 13+10=23)

-- Test 12: Repeat returning from function
local function repeat_return()
    local r = 0
    repeat
        r = r + 1
        if r == 3 then
            return r * 10
        end
    until r >= 10
    return r
end
results[#results + 1] = repeat_return()  -- 30

-- Test 13: Nested repeat with break
local s = 0
repeat
    s = s + 1
    local t = 0
    repeat
        t = t + 1
        if t == 2 then break end
    until t >= 10
    -- t should be 2 here due to break
until s >= 3
results[#results + 1] = s  -- 3

-- Test 14: Repeat with table modification
local tbl = {count = 0}
repeat
    tbl.count = tbl.count + 1
    local current = tbl.count
until current >= 4
results[#results + 1] = tbl.count  -- 4

-- Test 15: Repeat with method call
local counter_obj = {
    val = 0,
    increment = function(self)
        self.val = self.val + 1
        return self.val
    end,
    done = function(self)
        return self.val >= 5
    end
}

repeat
    counter_obj:increment()
until counter_obj:done()
results[#results + 1] = counter_obj.val  -- 5

-- Test 16: Variable lifetime edge case
local u = 0
repeat
    u = u + 1
    local temp = u * 2
    -- temp is visible in until
until temp >= 8  -- u=4, temp=8
results[#results + 1] = u  -- 4

-- Test 17: Repeat with pcall
local v = 0
repeat
    v = v + 1
    local ok = pcall(function()
        if v == 2 then error("test") end
    end)
    local should_continue = not ok
until v >= 3 or should_continue
results[#results + 1] = v  -- 2 (stops when pcall fails)

print(table.concat(results, ","))
-- Expected: 5,3,3,3,6,1,5,100,1,2,3,3,23,30,3,4,5,4,2
