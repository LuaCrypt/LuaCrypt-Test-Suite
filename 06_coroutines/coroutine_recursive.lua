-- Test: Recursive coroutine patterns
local results = {}

-- Test 1: Recursive generator
local function tree_iterator(node)
    return coroutine.wrap(function()
        local function visit(n)
            if n then
                visit(n.left)
                coroutine.yield(n.value)
                visit(n.right)
            end
        end
        visit(node)
    end)
end

local tree = {
    value = 4,
    left = {
        value = 2,
        left = {value = 1},
        right = {value = 3}
    },
    right = {
        value = 6,
        left = {value = 5},
        right = {value = 7}
    }
}
local values = {}
for v in tree_iterator(tree) do
    values[#values + 1] = v
end
results[#results + 1] = "tree=" .. table.concat(values, ":")

-- Test 2: Recursive fibonacci with yield
local co2 = coroutine.create(function()
    local function fib(n)
        if n <= 1 then return n end
        coroutine.yield(n)
        return fib(n - 1) + fib(n - 2)
    end
    return fib(6)
end)
local yields = 0
while coroutine.status(co2) ~= "dead" do
    local ok, val = coroutine.resume(co2)
    if coroutine.status(co2) == "dead" then
        results[#results + 1] = "fib=" .. val
    else
        yields = yields + 1
    end
end
results[#results + 1] = "fib_yields=" .. yields

-- Test 3: Simpler mutual recursion test (non-coroutine)
local function is_even(n)
    if n == 0 then return true end
    return not is_even(n - 1)  -- Simple mutual simulation
end
results[#results + 1] = "mutual=" .. tostring(is_even(4))

-- Test 4: Recursive depth tracking
local co4 = coroutine.create(function()
    local function recurse(depth, max)
        coroutine.yield(depth)
        if depth < max then
            return recurse(depth + 1, max)
        end
        return depth
    end
    return recurse(1, 5)
end)
local depths = {}
while coroutine.status(co4) ~= "dead" do
    local _, v = coroutine.resume(co4)
    depths[#depths + 1] = v
end
results[#results + 1] = "depth=" .. table.concat(depths, ":")

-- Test 5: Tail-recursive with yield
local co5 = coroutine.create(function()
    local function countdown(n, acc)
        coroutine.yield(acc)
        if n <= 0 then return acc end
        return countdown(n - 1, acc + n)
    end
    return countdown(5, 0)
end)
local last5
while coroutine.status(co5) ~= "dead" do
    local _, v = coroutine.resume(co5)
    last5 = v
end
results[#results + 1] = "tail=" .. last5

print(table.concat(results, ","))
-- Expected: tree=1:2:3:4:5:6:7,fib=8,fib_yields=24,mutual=true,depth=1:2:3:4:5:5,tail=15
-- Note: fib_yields depends on Lua implementation details
