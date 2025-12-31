-- Test: Deterministic execution order
local results = {}
local trace = {}

-- Test 1: Function call order
local function f1() trace[#trace + 1] = "f1" return 1 end
local function f2() trace[#trace + 1] = "f2" return 2 end
local function f3() trace[#trace + 1] = "f3" return 3 end
local sum = f1() + f2() + f3()
results[#results + 1] = "call_order=" .. table.concat(trace, "")

-- Test 2: Table constructor order
trace = {}
local function g1() trace[#trace + 1] = "g1" return "a" end
local function g2() trace[#trace + 1] = "g2" return "b" end
local t = {[g1()] = 1, [g2()] = 2}
results[#results + 1] = "tbl_order=" .. table.concat(trace, "")

-- Test 3: Multiple assignment order
trace = {}
local function h1() trace[#trace + 1] = "h1" return 1, 2 end
local function h2() trace[#trace + 1] = "h2" return 3 end
local a, b, c = h1(), h2()
results[#results + 1] = "assign_order=" .. table.concat(trace, "")

-- Test 4: Argument evaluation order
trace = {}
local function args(x, y, z)
    return x + y + z
end
local r4 = args(f1(), f2(), f3())
results[#results + 1] = "arg_order=" .. table.concat(trace, "")

-- Test 5: Logical operator evaluation
trace = {}
local function side_effect_true()
    trace[#trace + 1] = "t"
    return true
end
local function side_effect_false()
    trace[#trace + 1] = "f"
    return false
end
local _ = side_effect_true() or side_effect_false()
local _ = side_effect_false() and side_effect_true()
results[#results + 1] = "logic_order=" .. table.concat(trace, "")

-- Test 6: Comparison chain
trace = {}
local function cmp_val(v)
    trace[#trace + 1] = tostring(v)
    return v
end
local cmp = cmp_val(1) < cmp_val(2)
results[#results + 1] = "cmp_order=" .. table.concat(trace, "")

-- Test 7: for loop evaluation order
trace = {}
local function start_val()
    trace[#trace + 1] = "s"
    return 1
end
local function end_val()
    trace[#trace + 1] = "e"
    return 3
end
local function step_val()
    trace[#trace + 1] = "i"
    return 1
end
for i = start_val(), end_val(), step_val() do
    trace[#trace + 1] = tostring(i)
end
results[#results + 1] = "for_order=" .. table.concat(trace, "")

-- Test 8: Method call order
trace = {}
local obj = {
    a = function(self)
        trace[#trace + 1] = "a"
        return self
    end,
    b = function(self)
        trace[#trace + 1] = "b"
        return self
    end
}
local _ = obj:a():b()
results[#results + 1] = "method_order=" .. table.concat(trace, "")

-- Test 9: Vararg evaluation
trace = {}
local function vararg_test(...)
    local n = select('#', ...)
    trace[#trace + 1] = tostring(n)
end
vararg_test(f1(), f2(), f3())
results[#results + 1] = "vararg_order=" .. table.concat(trace, "")

-- Test 10: Return value order
trace = {}
local function multi_return()
    trace[#trace + 1] = "ret"
    return 1, 2, 3
end
local x, y, z = multi_return()
results[#results + 1] = "ret_order=" .. table.concat(trace, "")

print(table.concat(results, ","))
-- Expected: deterministic order across runs
