-- Test: Errors in loops
local results = {}

-- Test 1: Error in for loop (caught)
local iterations = 0
local ok1, err1 = pcall(function()
    for i = 1, 10 do
        iterations = iterations + 1
        if i == 5 then
            error("at 5")
        end
    end
end)
results[#results + 1] = "for=" .. iterations

-- Test 2: Error in while loop
local count = 0
local ok2, err2 = pcall(function()
    while true do
        count = count + 1
        if count >= 3 then
            error("while error")
        end
    end
end)
results[#results + 1] = "while=" .. count

-- Test 3: Error in for-in loop
local items = {"a", "b", "c", "d"}
local processed = 0
local ok3, err3 = pcall(function()
    for i, v in ipairs(items) do
        processed = processed + 1
        if v == "c" then
            error("found c")
        end
    end
end)
results[#results + 1] = "forin=" .. processed

-- Test 4: Continue pattern with pcall in loop
local successes = 0
for i = 1, 5 do
    local ok = pcall(function()
        if i == 3 then error("skip") end
        successes = successes + 1
    end)
end
results[#results + 1] = "continue=" .. successes

-- Test 5: Nested loops with error
local outer_count = 0
local inner_count = 0
local ok5, err5 = pcall(function()
    for i = 1, 3 do
        outer_count = outer_count + 1
        for j = 1, 3 do
            inner_count = inner_count + 1
            if i == 2 and j == 2 then
                error("nested")
            end
        end
    end
end)
results[#results + 1] = "nested=" .. outer_count .. ":" .. inner_count

print(table.concat(results, ","))
-- Expected: for=5,while=3,forin=3,continue=4,nested=2:5
