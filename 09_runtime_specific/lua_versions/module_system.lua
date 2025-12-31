-- Test: Module system differences
local results = {}

-- Test 1: require function exists
results[#results + 1] = "require=" .. type(require)

-- Test 2: package table
results[#results + 1] = "package=" .. type(package)

-- Test 3: package.loaded
results[#results + 1] = "loaded=" .. type(package.loaded)

-- Test 4: package.path
results[#results + 1] = "path=" .. (package.path and "set" or "nil")

-- Test 5: package.cpath
results[#results + 1] = "cpath=" .. (package.cpath and "set" or "nil")

-- Test 6: package.preload
results[#results + 1] = "preload=" .. type(package.preload)

-- Test 7: package.searchers/loaders
if package.searchers then
    results[#results + 1] = "searchers=" .. #package.searchers
elseif package.loaders then
    results[#results + 1] = "loaders=" .. #package.loaders
else
    results[#results + 1] = "searchers=nil"
end

-- Test 8: package.searchpath (5.2+)
if package.searchpath then
    results[#results + 1] = "searchpath=exists"
else
    results[#results + 1] = "searchpath=nil"
end

-- Test 9: package.config
if package.config then
    local sep = package.config:sub(1, 1)
    results[#results + 1] = "config=" .. (sep == "/" or sep == "\\" and "set" or "other")
else
    results[#results + 1] = "config=nil"
end

-- Test 10: module function (5.1, deprecated in 5.2+)
if module then
    results[#results + 1] = "module=exists"
else
    results[#results + 1] = "module=nil"
end

-- Test 11: Custom searcher/loader
package.preload["__test_module"] = function()
    return {value = 42}
end
local test_mod = require("__test_module")
results[#results + 1] = "preload_use=" .. test_mod.value
package.preload["__test_module"] = nil
package.loaded["__test_module"] = nil

-- Test 12: require caches results
package.preload["__cache_test"] = function()
    return {counter = 0}
end
local mod1 = require("__cache_test")
mod1.counter = mod1.counter + 1
local mod2 = require("__cache_test")
results[#results + 1] = "cache=" .. (mod1 == mod2 and mod2.counter == 1 and "cached" or "not")
package.preload["__cache_test"] = nil
package.loaded["__cache_test"] = nil

-- Test 13: package.loaded manipulation
package.loaded["__fake_module"] = {fake = true}
local fake = require("__fake_module")
results[#results + 1] = "loaded_inject=" .. (fake.fake and "works" or "fail")
package.loaded["__fake_module"] = nil

print(table.concat(results, ","))
-- Expected varies by Lua version
