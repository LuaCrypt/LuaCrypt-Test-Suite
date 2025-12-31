-- Test: Decorator pattern with closures
local results = {}

-- Test 1: Simple logging decorator
local function withLogging(fn, name)
    local callLog = {}
    local wrapped = function(...)
        callLog[#callLog + 1] = name
        return fn(...)
    end
    return wrapped, function() return callLog end
end

local function add(a, b) return a + b end
local loggedAdd, getLog = withLogging(add, "add")
loggedAdd(1, 2)
loggedAdd(3, 4)
results[#results + 1] = "log=" .. table.concat(getLog(), ";")

-- Test 2: Timing decorator
local function withCounting(fn)
    local count = 0
    return function(...)
        count = count + 1
        return fn(...)
    end, function() return count end
end

local function double(x) return x * 2 end
local countedDouble, getCount = withCounting(double)
countedDouble(5)
countedDouble(10)
countedDouble(15)
results[#results + 1] = "count=" .. getCount()

-- Test 3: Caching decorator
local function withCache(fn)
    local cache = {}
    return function(x)
        if cache[x] == nil then
            cache[x] = fn(x)
        end
        return cache[x]
    end
end

local computeCalls = 0
local function expensiveCompute(x)
    computeCalls = computeCalls + 1
    return x * x
end
local cachedCompute = withCache(expensiveCompute)
cachedCompute(5)
cachedCompute(5)
cachedCompute(5)
results[#results + 1] = "cache_calls=" .. computeCalls

-- Test 4: Chained decorators
local function identity(x) return x end
local decorated = withCounting(withCache(identity))
decorated(1)
decorated(1)
decorated(2)
results[#results + 1] = "chained=" .. decorated(1)

-- Test 5: Before/after hooks
local function withHooks(fn, before, after)
    return function(...)
        if before then before(...) end
        local result = fn(...)
        if after then after(result) end
        return result
    end
end

local hookLog = {}
local hookedFn = withHooks(
    function(x) return x * 2 end,
    function(x) hookLog[#hookLog + 1] = "before:" .. x end,
    function(r) hookLog[#hookLog + 1] = "after:" .. r end
)
hookedFn(5)
results[#results + 1] = "hooks=" .. table.concat(hookLog, ",")

print(table.concat(results, ","))
-- Expected: log=add;add,count=3,cache_calls=1,chained=1,hooks=before:5,after:10
