-- Test: Complex nested upvalue chains
local results = {}

-- Test 1: Upvalue from grandparent scope
local grand = "grand"
local function parent()
    local par = "parent"
    local function child()
        local ch = "child"
        local function grandchild()
            return grand .. "+" .. par .. "+" .. ch
        end
        return grandchild()
    end
    return child()
end
results[#results + 1] = "chain=" .. parent()

-- Test 2: Multiple upvalues from different levels
local l1 = 1
local function f1()
    local l2 = 2
    local function f2()
        local l3 = 3
        local function f3()
            local l4 = 4
            local function f4()
                return l1 + l2 + l3 + l4
            end
            return f4()
        end
        return f3()
    end
    return f2()
end
results[#results + 1] = "multi_level=" .. f1()

-- Test 3: Modify upvalue at each level
local shared = 0
local function outer()
    shared = shared + 1
    local function middle()
        shared = shared + 10
        local function inner()
            shared = shared + 100
        end
        inner()
    end
    middle()
end
outer()
results[#results + 1] = "mod_chain=" .. shared

-- Test 4: Different closures from same nested function
local base = 10
local function makeOps()
    local mult = 2
    local function createAdd(n)
        return function()
            return base + n * mult
        end
    end
    return createAdd(5), createAdd(10)
end
local add5, add10 = makeOps()
results[#results + 1] = "diff_closures=" .. add5() .. ";" .. add10()

-- Test 5: Closure captures closure
local function maker()
    local x = 100
    local function getter()
        return x
    end
    local function user()
        return getter() + 1
    end
    return user
end
local user_fn = maker()
results[#results + 1] = "closure_captures=" .. user_fn()

print(table.concat(results, ","))
-- Expected: chain=grand+parent+child,multi_level=10,mod_chain=111,diff_closures=20;30,closure_captures=101
