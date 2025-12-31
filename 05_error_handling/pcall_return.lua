-- Test: pcall return value handling
local results = {}

-- Test 1: No return value
local ok1, v1 = pcall(function()
    -- Nothing returned
end)
results[#results + 1] = "no_ret=" .. tostring(ok1) .. ":" .. tostring(v1)

-- Test 2: Single return
local ok2, v2 = pcall(function()
    return 42
end)
results[#results + 1] = "single=" .. v2

-- Test 3: Multiple returns
local ok3, a, b, c, d = pcall(function()
    return 1, 2, 3, 4
end)
results[#results + 1] = "multi=" .. a .. ";" .. b .. ";" .. c .. ";" .. d

-- Test 4: Return nil explicitly
local ok4, v4 = pcall(function()
    return nil
end)
results[#results + 1] = "ret_nil=" .. tostring(ok4) .. ":" .. tostring(v4)

-- Test 5: Return multiple nils
local ok5, n1, n2, n3 = pcall(function()
    return nil, nil, nil
end)
results[#results + 1] = "multi_nil=" .. tostring(n1) .. ";" .. tostring(n2) .. ";" .. tostring(n3)

-- Test 6: Error return
local ok6, err6 = pcall(function()
    error("fail")
end)
results[#results + 1] = "err_ret=" .. tostring(ok6) .. ":" .. (string.find(err6, "fail") and "msg" or "no_msg")

-- Test 7: Return from nested function
local ok7, v7 = pcall(function()
    local function inner()
        return 100
    end
    return inner()
end)
results[#results + 1] = "nested=" .. v7

print(table.concat(results, ","))
-- Expected: no_ret=true:nil,single=42,multi=1;2;3;4,ret_nil=true:nil,multi_nil=nil;nil;nil,err_ret=false:msg,nested=100
