-- Test: String operation determinism
local results = {}

-- Test 1: Basic string operations
local s = "Hello, World!"
results[#results + 1] = "len=" .. #s
results[#results + 1] = "upper=" .. s:upper()
results[#results + 1] = "lower=" .. s:lower()

-- Test 2: Substring
results[#results + 1] = "sub=" .. s:sub(1, 5)
results[#results + 1] = "sub_neg=" .. s:sub(-6)

-- Test 3: Find and match
local pos = s:find("World")
results[#results + 1] = "find=" .. (pos or "nil")
local match = s:match("(%w+)")
results[#results + 1] = "match=" .. (match or "nil")

-- Test 4: gsub
local replaced, count = s:gsub("o", "0")
results[#results + 1] = "gsub=" .. replaced .. ":" .. count

-- Test 5: Byte operations
local bytes = {}
for i = 1, 5 do
    bytes[i] = s:byte(i)
end
results[#results + 1] = "bytes=" .. table.concat(bytes, ":")

-- Test 6: Char operations
local chars = string.char(72, 101, 108, 108, 111)
results[#results + 1] = "char=" .. chars

-- Test 7: Rep
results[#results + 1] = "rep=" .. string.rep("ab", 5)

-- Test 8: Reverse
results[#results + 1] = "rev=" .. s:reverse()

-- Test 9: Format
results[#results + 1] = "fmt=" .. string.format("%05d:%.2f:%s", 42, 3.14, "test")

-- Test 10: Pattern captures
local text = "key1=val1;key2=val2"
local captures = {}
for k, v in text:gmatch("(%w+)=(%w+)") do
    captures[#captures + 1] = k .. ">" .. v
end
results[#results + 1] = "captures=" .. table.concat(captures, ",")

-- Test 11: Long string operations
local long = string.rep("abcdefghij", 100)
results[#results + 1] = "long_len=" .. #long
results[#results + 1] = "long_find=" .. (long:find("fgh", 500) or "nil")

-- Test 12: Concatenation
local parts = {"one", "two", "three"}
results[#results + 1] = "concat=" .. table.concat(parts, "-")

-- Test 13: Unicode bytes (UTF-8)
local utf8_str = "Ñ"  -- 2 bytes in UTF-8
results[#results + 1] = "utf8_len=" .. #utf8_str

-- Test 14: Empty string edge cases
local empty = ""
results[#results + 1] = "empty=" .. #empty .. ":" .. (empty:sub(1, 5) == "" and "yes" or "no")

print(table.concat(results, ","))
-- Expected: consistent across runs
