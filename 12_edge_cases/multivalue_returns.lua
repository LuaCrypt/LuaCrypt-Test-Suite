-- Edge cases for multi-value returns and assignments
-- Tests fixes for: return register protection, global multi-value assignment

local results = {}

-- Test 1: Multi-value return with computations
local function compute_multi()
    local x = 10
    local y = 20
    local z = 30
    return x + 1, y + 2, z + 3
end

local a, b, c = compute_multi()
results[#results + 1] = a  -- 11
results[#results + 1] = b  -- 22
results[#results + 1] = c  -- 33

-- Test 2: Multi-value return with function calls in return
local function inner(n)
    return n * 2
end

local function outer()
    return inner(5), inner(6), inner(7)
end

local d, e, f = outer()
results[#results + 1] = d  -- 10
results[#results + 1] = e  -- 12
results[#results + 1] = f  -- 14

-- Test 3: Global multi-value assignment
local function get_globals()
    return 100, 200, 300
end

_G.g1, _G.g2, _G.g3 = get_globals()
results[#results + 1] = _G.g1  -- 100
results[#results + 1] = _G.g2  -- 200
results[#results + 1] = _G.g3  -- 300

-- Test 4: Mixed local and table assignment from multi-return
local t = {}
local x
x, t.a, t.b = 1, 2, 3
results[#results + 1] = x    -- 1
results[#results + 1] = t.a  -- 2
results[#results + 1] = t.b  -- 3

-- Test 5: Multi-value from pcall
local function may_fail(succeed)
    if succeed then
        return "ok", 42
    else
        error("failed")
    end
end

local ok, val = pcall(may_fail, true)
results[#results + 1] = tostring(ok)  -- true
results[#results + 1] = val           -- ok

-- Test 6: Chained multi-value assignments
local function triple()
    return "a", "b", "c"
end

local p, q, r = triple()
local s, t_var, u = p, q, r
results[#results + 1] = s      -- a
results[#results + 1] = t_var  -- b
results[#results + 1] = u      -- c

-- Test 7: Multi-value with nil in middle
local function with_nil()
    return 1, nil, 3
end

local v, w, y = with_nil()
results[#results + 1] = v                    -- 1
results[#results + 1] = (w == nil and "nil" or w)  -- nil
results[#results + 1] = y                    -- 3

-- Test 8: Excess values discarded
local function five_values()
    return 1, 2, 3, 4, 5
end

local m, n = five_values()
results[#results + 1] = m  -- 1
results[#results + 1] = n  -- 2

-- Test 9: Insufficient values become nil
local function one_value()
    return 42
end

local o, pp, qq = one_value()
results[#results + 1] = o                    -- 42
results[#results + 1] = (pp == nil and "nil" or pp)  -- nil
results[#results + 1] = (qq == nil and "nil" or qq)  -- nil

-- Test 10: Return with complex expressions
local function complex_return()
    local tbl = {x = 10}
    return tbl.x + 5, (function() return 20 end)(), 30 + 5
end

local cr1, cr2, cr3 = complex_return()
results[#results + 1] = cr1  -- 15
results[#results + 1] = cr2  -- 20
results[#results + 1] = cr3  -- 35

-- Cleanup globals
_G.g1, _G.g2, _G.g3 = nil, nil, nil

print(table.concat(results, ","))
-- Expected: 11,22,33,10,12,14,100,200,300,1,2,3,true,ok,a,b,c,1,nil,3,1,2,42,nil,nil,15,20,35
