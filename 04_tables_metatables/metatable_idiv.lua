-- Test: __idiv metamethod (Lua 5.3+)
local results = {}

-- Check if integer division is available
local has_idiv = pcall(function() return 5 // 2 end)

if has_idiv then
    local function makeNum(n)
        return setmetatable({n = n}, {
            __idiv = function(a, b)
                local va = type(a) == "table" and a.n or a
                local vb = type(b) == "table" and b.n or b
                return makeNum(va // vb)
            end
        })
    end

    -- Test 1: Basic integer division
    local n1 = makeNum(17)
    local n2 = makeNum(5)
    results[#results + 1] = "idiv=" .. (n1 // n2).n

    -- Test 2: With regular number
    results[#results + 1] = "with_num=" .. (n1 // 3).n

    -- Test 3: Number on left
    results[#results + 1] = "num_left=" .. (20 // n2).n

    -- Test 4: Negative
    local n3 = makeNum(-17)
    results[#results + 1] = "negative=" .. (n3 // n2).n

    -- Test 5: Chained
    local n4 = makeNum(100)
    results[#results + 1] = "chain=" .. (n4 // makeNum(3) // makeNum(2)).n
else
    results[#results + 1] = "idiv=not_available"
end

print(table.concat(results, ","))
-- Expected (Lua 5.3+): idiv=3,with_num=5,num_left=4,negative=-4,chain=16
