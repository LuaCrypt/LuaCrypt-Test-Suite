-- Test: Lexical scoping edge cases
local results = {}

-- Test 1: Block scope
local x = "outer"
do
    local x = "inner"
    results[#results + 1] = "block=" .. x
end
results[#results + 1] = "after_block=" .. x

-- Test 2: Loop variable scope
for i = 1, 1 do
    local loop_var = i
end
local loop_access = pcall(function() return loop_var end)
results[#results + 1] = "loop_scope=" .. (loop_access and "leaked" or "contained")

-- Test 3: repeat-until special scoping
local repeat_var
repeat
    local inside = "value"
    repeat_var = inside
until inside == "value"
results[#results + 1] = "repeat=" .. repeat_var

-- Test 4: Local function recursion
local function outer_rec()
    local function inner(n)
        if n <= 0 then return 0 end
        return n + inner(n - 1)
    end
    return inner(5)
end
results[#results + 1] = "local_rec=" .. outer_rec()

-- Test 5: Upvalue from different scope levels
local function scope_levels()
    local a = 1
    return function()
        local b = 2
        return function()
            local c = 3
            return a + b + c
        end
    end
end
results[#results + 1] = "levels=" .. scope_levels()()()

-- Test 6: Shadowing in nested functions
local shadow = "outer"
local function shadow_test()
    local shadow = "middle"
    return function()
        local shadow = "inner"
        return shadow
    end
end
results[#results + 1] = "shadow=" .. shadow_test()()

-- Test 7: Generic for iterator scope
local iter_vars = {}
for k, v in pairs({a = 1}) do
    iter_vars.k = k
    iter_vars.v = v
end
results[#results + 1] = "for_scope=" .. iter_vars.k .. iter_vars.v

-- Test 8: Multiple assignment scope
local ma, mb = 1, 2
local ma, mc = ma + 1, mb + 1
results[#results + 1] = "multi_assign=" .. ma .. mc

-- Test 9: Function parameter shadowing
local param = "global"
local function param_shadow(param)
    return param
end
results[#results + 1] = "param=" .. param_shadow("local")

-- Test 10: Table field vs local
local t = {field = "table"}
local field = "local"
results[#results + 1] = "field=" .. t.field .. field

-- Test 11: goto label scope (5.2+)
local goto_ok = pcall(function()
    local code = [[
        local x = 0
        ::start::
        x = x + 1
        if x < 3 then goto start end
        return x
    ]]
    local fn = load(code)
    return fn and fn()
end)
results[#results + 1] = "goto=" .. (goto_ok and "works" or "error")

-- Test 12: Local visibility before declaration
local visibility_ok = pcall(function()
    local code = [[
        local x = x or 1
        return x
    ]]
    local fn = load(code)
    return fn and fn()
end)
results[#results + 1] = "predecl=" .. (visibility_ok and "works" or "error")

print(table.concat(results, ","))
-- Expected: block=inner,after_block=outer,loop_scope=contained,repeat=value,local_rec=15,levels=6,shadow=inner,for_scope=a1,multi_assign=23,param=local,field=tablelocal,goto=works,predecl=works
