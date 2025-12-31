-- Test: Bit operations (LuaJIT bit library or Lua 5.3+ operators)
local results = {}

-- Determine bit library
local bit_lib
if bit then
    bit_lib = bit
elseif bit32 then
    bit_lib = bit32
end

if bit_lib then
    -- Test 1: band
    results[#results + 1] = "band=" .. bit_lib.band(0xFF, 0x0F)

    -- Test 2: bor
    results[#results + 1] = "bor=" .. bit_lib.bor(0xF0, 0x0F)

    -- Test 3: bxor
    results[#results + 1] = "bxor=" .. bit_lib.bxor(0xFF, 0x0F)

    -- Test 4: bnot
    local bnot_result = bit_lib.bnot(0)
    results[#results + 1] = "bnot=" .. (bnot_result ~= 0 and "nonzero" or "zero")

    -- Test 5: lshift
    results[#results + 1] = "lshift=" .. bit_lib.lshift(1, 4)

    -- Test 6: rshift
    results[#results + 1] = "rshift=" .. bit_lib.rshift(16, 2)

    -- Test 7: arshift (arithmetic right shift)
    if bit_lib.arshift then
        results[#results + 1] = "arshift=" .. bit_lib.arshift(-16, 2)
    else
        results[#results + 1] = "arshift=nil"
    end

    -- Test 8: rol/ror (rotate, LuaJIT specific)
    if bit_lib.rol then
        results[#results + 1] = "rol=" .. bit_lib.rol(0x12345678, 8)
    else
        results[#results + 1] = "rol=nil"
    end

    -- Test 9: bswap (byte swap, LuaJIT specific)
    if bit_lib.bswap then
        local swapped = bit_lib.bswap(0x12345678)
        results[#results + 1] = "bswap=" .. string.format("%x", bit_lib.band(swapped, 0xFFFFFFFF))
    else
        results[#results + 1] = "bswap=nil"
    end

    -- Test 10: tobit (normalize to 32-bit, LuaJIT specific)
    if bit_lib.tobit then
        results[#results + 1] = "tobit=" .. bit_lib.tobit(0x100000000)
    else
        results[#results + 1] = "tobit=nil"
    end

    -- Test 11: tohex (LuaJIT specific)
    if bit_lib.tohex then
        results[#results + 1] = "tohex=" .. bit_lib.tohex(255, 4)
    else
        results[#results + 1] = "tohex=nil"
    end

    -- Test 12: Complex expression
    local complex = bit_lib.band(bit_lib.bor(0xAA, bit_lib.lshift(0x55, 8)), 0xFFFF)
    results[#results + 1] = "complex=" .. complex

else
    -- Lua 5.3+ native operators
    local ok = pcall(function()
        local code = [[
            local results = {}
            results[#results + 1] = "band=" .. (0xFF & 0x0F)
            results[#results + 1] = "bor=" .. (0xF0 | 0x0F)
            results[#results + 1] = "bxor=" .. (0xFF ~ 0x0F)
            results[#results + 1] = "bnot=" .. (~0 ~= 0 and "nonzero" or "zero")
            results[#results + 1] = "lshift=" .. (1 << 4)
            results[#results + 1] = "rshift=" .. (16 >> 2)
            return table.concat(results, ",")
        ]]
        local fn = load(code)
        print(fn())
    end)
    if not ok then
        results[#results + 1] = "bitops=unavailable"
    end
    print(table.concat(results, ","))
    return
end

print(table.concat(results, ","))
-- Expected (LuaJIT): band=15,bor=255,bxor=240,bnot=nonzero,lshift=16,rshift=4,arshift=-4,rol=878082192,bswap=78563412,tobit=0,tohex=00ff,complex=21930
