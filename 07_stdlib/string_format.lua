-- Test: String format function
local results = {}

-- Test 1: Integer formatting
results[#results + 1] = "int=" .. string.format("%d", 42)
results[#results + 1] = "neg_int=" .. string.format("%d", -42)

-- Test 2: Float formatting
results[#results + 1] = "float=" .. string.format("%.2f", 3.14159)
results[#results + 1] = "exp=" .. string.format("%.2e", 1234.5)

-- Test 3: String formatting
results[#results + 1] = "str=" .. string.format("%s", "hello")
results[#results + 1] = "str_width=" .. string.format("%10s", "hi")

-- Test 4: Hex formatting
results[#results + 1] = "hex=" .. string.format("%x", 255)
results[#results + 1] = "HEX=" .. string.format("%X", 255)

-- Test 5: Octal
results[#results + 1] = "oct=" .. string.format("%o", 8)

-- Test 6: Padding
results[#results + 1] = "pad_zero=" .. string.format("%05d", 42)
results[#results + 1] = "pad_space=" .. string.format("%5d", 42)
results[#results + 1] = "pad_left=" .. string.format("%-5d|", 42)

-- Test 7: Sign
results[#results + 1] = "plus=" .. string.format("%+d", 42)

-- Test 8: Multiple args
results[#results + 1] = "multi=" .. string.format("%s=%d", "x", 10)

-- Test 9: Char
results[#results + 1] = "char=" .. string.format("%c", 65)

-- Test 10: Percent literal
results[#results + 1] = "percent=" .. string.format("100%%")

-- Test 11: Width and precision
results[#results + 1] = "wp=" .. string.format("%8.3f", 3.14159)

-- Test 12: String precision (truncate)
results[#results + 1] = "strprec=" .. string.format("%.3s", "hello")

-- Test 13: unsigned
results[#results + 1] = "unsigned=" .. string.format("%u", 42)

-- Test 14: Complex format
local complex = string.format("[%5s] %08d %6.2f", "ab", 123, 45.6)
results[#results + 1] = "complex=" .. complex

-- Test 15: q format for quoted strings
local quoted = string.format("%q", "hello\nworld")
results[#results + 1] = "quoted=" .. (quoted:find("\\n") and "has_esc" or "no_esc")

print(table.concat(results, ","))
-- Expected: int=42,neg_int=-42,float=3.14,exp=1.23e+03,str=hello,str_width=        hi,hex=ff,HEX=FF,oct=10,pad_zero=00042,pad_space=   42,pad_left=42   |,plus=+42,multi=x=10,char=A,percent=100%,wp=   3.142,strprec=hel,unsigned=42,complex=[   ab] 00000123  45.60,quoted=has_esc
