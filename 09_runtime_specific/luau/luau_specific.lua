-- Test: Luau-specific features
local results = {}

-- Test 1: Check if Luau (game is a Roblox global)
local is_luau = typeof ~= nil or game ~= nil or script ~= nil
results[#results + 1] = "luau=" .. (is_luau and "yes" or "no")

-- Test 2: typeof function (Luau extension)
if typeof then
    results[#results + 1] = "typeof_num=" .. typeof(42)
    results[#results + 1] = "typeof_str=" .. typeof("hello")
    results[#results + 1] = "typeof_tbl=" .. typeof({})
else
    results[#results + 1] = "typeof=nil"
end

-- Test 3: Strict type checking mode indicator
-- In Luau, --!strict enables static type checking
results[#results + 1] = "typecheck=runtime"

-- Test 4: table.freeze (Luau extension)
if table.freeze then
    local t = {a = 1, b = 2}
    table.freeze(t)
    local ok = pcall(function() t.c = 3 end)
    results[#results + 1] = "freeze=" .. (ok and "mutable" or "frozen")
else
    results[#results + 1] = "freeze=nil"
end

-- Test 5: table.isfrozen (Luau extension)
if table.isfrozen then
    local t = {}
    results[#results + 1] = "isfrozen=" .. tostring(table.isfrozen(t))
else
    results[#results + 1] = "isfrozen=nil"
end

-- Test 6: table.clone (Luau extension)
if table.clone then
    local t = {a = 1, b = {c = 2}}
    local clone = table.clone(t)
    results[#results + 1] = "clone=" .. (clone.a == 1 and clone ~= t and "works" or "fail")
else
    results[#results + 1] = "clone=nil"
end

-- Test 7: buffer library (Luau extension)
if buffer then
    local buf = buffer.create(16)
    buffer.writef32(buf, 0, 3.14)
    local val = buffer.readf32(buf, 0)
    results[#results + 1] = "buffer=" .. (val > 3 and val < 4 and "works" or "fail")
else
    results[#results + 1] = "buffer=nil"
end

-- Test 8: Vector3 type (if in Roblox context)
if Vector3 then
    local v = Vector3.new(1, 2, 3)
    results[#results + 1] = "vector3=" .. v.X
else
    results[#results + 1] = "vector3=nil"
end

-- Test 9: string interpolation syntax check
-- `string` with backticks is Luau syntax
local interp_ok = pcall(function()
    local x = 42
    -- Can't use actual syntax here since this should work on all Lua
    return true
end)
results[#results + 1] = "interp=" .. (interp_ok and "runtime_ok" or "error")

-- Test 10: Continue statement (Luau extension)
local continue_ok = pcall(function()
    local code = [[
        local sum = 0
        for i = 1, 10 do
            if i % 2 == 0 then continue end
            sum = sum + i
        end
        return sum
    ]]
    local fn = load or loadstring
    return fn and fn(code)
end)
results[#results + 1] = "continue=" .. (continue_ok and "maybe" or "no")

-- Test 11: Compound assignment operators (Luau)
local compound_ok = pcall(function()
    local code = [[
        local x = 5
        x += 3
        return x
    ]]
    local fn = load or loadstring
    if fn then
        local f = fn(code)
        return f and f() == 8
    end
    return false
end)
results[#results + 1] = "compound=" .. (compound_ok and "maybe" or "no")

-- Test 12: task library (Roblox Luau)
if task then
    results[#results + 1] = "task=exists"
else
    results[#results + 1] = "task=nil"
end

print(table.concat(results, ","))
-- Expected (on Luau): luau=yes,typeof_num=number,typeof_str=string,typeof_tbl=table,typecheck=runtime,freeze=frozen,isfrozen=false,clone=works,buffer=works,...
