-- Edge cases for string escapes with problematic bytes
-- Tests fixes for: \258 invalid escape, bytes followed by digits

local results = {}

-- Test 1: Basic escape sequences
local s1 = "hello\nworld"
results[#results + 1] = tostring(#s1)  -- 11

-- Test 2: Null byte in string
local s2 = "a\0b"
results[#results + 1] = tostring(#s2)  -- 3

-- Test 3: All single-char escapes
local s3 = "\a\b\f\n\r\t\v\\\"\'"
results[#results + 1] = tostring(#s3)  -- 10

-- Test 4: Numeric escape followed by digit (the problematic case)
-- \2 followed by '5' should NOT become \25
local s4 = string.char(2) .. "5"  -- byte 2, then '5'
local b1 = string.byte(s4, 1)
local b2 = string.byte(s4, 2)
results[#results + 1] = b1  -- 2
results[#results + 1] = b2  -- 53 (ASCII '5')

-- Test 5: High byte values
local s5 = string.char(255)
results[#results + 1] = string.byte(s5, 1)  -- 255

-- Test 6: Byte 0-9 followed by digits
local problematic = ""
for i = 0, 9 do
    problematic = problematic .. string.char(i) .. "0"
end
results[#results + 1] = #problematic  -- 20

-- Test 7: Non-ASCII bytes
local s7 = string.char(128, 129, 130)
results[#results + 1] = #s7  -- 3
results[#results + 1] = string.byte(s7, 1)  -- 128

-- Test 8: Mixed ASCII and non-ASCII
local s8 = "A" .. string.char(200) .. "B"
results[#results + 1] = string.byte(s8, 2)  -- 200

-- Test 9: String with many escape sequences
local s9 = "\t\t\n\n\r\r"
results[#results + 1] = #s9  -- 6

-- Test 10: Hex escapes (Lua 5.2+)
local s10 = "\x41\x42\x43"  -- ABC
results[#results + 1] = s10  -- ABC

-- Test 11: Long string with special chars (no escaping)
local s11 = [[
line1
line2]]
results[#results + 1] = tostring(s11:find("\n") ~= nil)  -- true

-- Test 12: Quote escapes
local s12 = "say \"hello\""
results[#results + 1] = #s12  -- 11

-- Test 13: Backslash escapes
local s13 = "path\\to\\file"
results[#results + 1] = #s13  -- 12

-- Test 14: Binary data preservation
local binary = ""
for i = 0, 255 do
    binary = binary .. string.char(i)
end
results[#results + 1] = #binary  -- 256

-- Verify each byte
local binary_ok = true
for i = 0, 255 do
    if string.byte(binary, i + 1) ~= i then
        binary_ok = false
        break
    end
end
results[#results + 1] = tostring(binary_ok)  -- true

-- Test 15: UTF-8 sequences (as raw bytes)
local utf8_char = "\xC3\xA9"  -- é in UTF-8
results[#results + 1] = #utf8_char  -- 2

-- Test 16: String comparison with escapes
local cmp1 = "a\0b"
local cmp2 = "a\0c"
results[#results + 1] = tostring(cmp1 < cmp2)  -- true

-- Test 17: Concatenation with escapes
local cat = "\t" .. "x" .. "\n"
results[#results + 1] = #cat  -- 3

-- Test 18: Byte 10 (newline) followed by digits
local newline_digit = "\n123"
results[#results + 1] = string.byte(newline_digit, 1)  -- 10
results[#results + 1] = string.byte(newline_digit, 2)  -- 49 ('1')

print(table.concat(results, ","))
-- Expected: 11,3,10,2,53,255,20,3,128,200,6,ABC,true,11,12,256,true,2,true,3,10,49
