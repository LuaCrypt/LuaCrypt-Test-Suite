-- Test: table.move function (Lua 5.3+)
local results = {}

-- Check if table.move is available
if table.move then
    -- Test 1: Basic move
    local t1 = {1, 2, 3, 4, 5}
    table.move(t1, 2, 4, 1)  -- Move [2,4] to position 1
    results[#results + 1] = "basic=" .. table.concat(t1, ";", 1, 5)

    -- Test 2: Move to different table
    local src = {10, 20, 30}
    local dest = {}
    table.move(src, 1, 3, 1, dest)
    results[#results + 1] = "diff_tbl=" .. table.concat(dest, ";")

    -- Test 3: Move with overlap (forward)
    local t3 = {1, 2, 3, 4, 5}
    table.move(t3, 1, 3, 3)  -- [1,2,3] -> positions [3,4,5]
    results[#results + 1] = "overlap_fwd=" .. table.concat(t3, ";", 1, 5)

    -- Test 4: Move with overlap (backward)
    local t4 = {1, 2, 3, 4, 5}
    table.move(t4, 3, 5, 1)  -- [3,4,5] -> positions [1,2,3]
    results[#results + 1] = "overlap_bwd=" .. table.concat(t4, ";", 1, 5)

    -- Test 5: Single element
    local t5 = {1, 2, 3}
    table.move(t5, 2, 2, 1)
    results[#results + 1] = "single=" .. t5[1]

    -- Test 6: Empty range
    local t6 = {1, 2, 3}
    table.move(t6, 2, 1, 1)  -- f > e, empty range
    results[#results + 1] = "empty=" .. table.concat(t6, ";")
else
    results[#results + 1] = "move=not_available"
end

print(table.concat(results, ","))
-- Expected (Lua 5.3+): basic=2;3;4;4;5,diff_tbl=10;20;30,overlap_fwd=1;2;1;2;3,overlap_bwd=3;4;5;4;5,single=2,empty=1;2;3
