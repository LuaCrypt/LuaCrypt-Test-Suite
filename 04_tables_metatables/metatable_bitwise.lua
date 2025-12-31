-- Test: Bitwise metamethods (Lua 5.3+)
local results = {}

-- Check if bitwise operators are available
local has_bitwise = pcall(function() return 1 & 1 end)

if has_bitwise then
    local function makeBits(n)
        return setmetatable({n = n}, {
            __band = function(a, b)
                local va = type(a) == "table" and a.n or a
                local vb = type(b) == "table" and b.n or b
                return makeBits(va & vb)
            end,
            __bor = function(a, b)
                local va = type(a) == "table" and a.n or a
                local vb = type(b) == "table" and b.n or b
                return makeBits(va | vb)
            end,
            __bxor = function(a, b)
                local va = type(a) == "table" and a.n or a
                local vb = type(b) == "table" and b.n or b
                return makeBits(va ~ vb)
            end,
            __bnot = function(a)
                return makeBits(~a.n)
            end,
            __shl = function(a, b)
                local va = type(a) == "table" and a.n or a
                local vb = type(b) == "table" and b.n or b
                return makeBits(va << vb)
            end,
            __shr = function(a, b)
                local va = type(a) == "table" and a.n or a
                local vb = type(b) == "table" and b.n or b
                return makeBits(va >> vb)
            end
        })
    end

    local b1 = makeBits(0xFF)  -- 11111111
    local b2 = makeBits(0x0F)  -- 00001111

    -- Test 1: AND
    results[#results + 1] = "band=" .. (b1 & b2).n

    -- Test 2: OR
    results[#results + 1] = "bor=" .. (b1 | b2).n

    -- Test 3: XOR
    results[#results + 1] = "bxor=" .. (b1 ~ b2).n

    -- Test 4: Left shift
    results[#results + 1] = "shl=" .. (makeBits(1) << 4).n

    -- Test 5: Right shift
    results[#results + 1] = "shr=" .. (makeBits(16) >> 2).n

    -- Test 6: With regular number
    results[#results + 1] = "with_num=" .. (b1 & 0x55).n
else
    results[#results + 1] = "bitwise=not_available"
end

print(table.concat(results, ","))
-- Expected (Lua 5.3+): band=15,bor=255,bxor=240,shl=16,shr=4,with_num=85
