-- Test: String library differences across Lua versions
local results = {}

-- Test 1: string.pack/unpack (5.3+)
if string.pack then
    local packed = string.pack(">I2", 0x1234)
    local val = string.unpack(">I2", packed)
    results[#results + 1] = "pack=" .. string.format("%x", val)
else
    results[#results + 1] = "pack=nil"
end

-- Test 2: string.packsize (5.3+)
if string.packsize then
    results[#results + 1] = "packsize=" .. string.packsize(">I4")
else
    results[#results + 1] = "packsize=nil"
end

-- Test 3: Frontier pattern %f (5.2+)
local frontier_ok = pcall(function()
    return string.match("the cat sat", "%f[%a]cat")
end)
if frontier_ok then
    local match = string.match("the cat sat", "%f[%a]cat")
    results[#results + 1] = "frontier=" .. (match == "cat" and "works" or "fail")
else
    results[#results + 1] = "frontier=nil"
end

-- Test 4: Empty captures
local empty_cap = string.match("abc", "()")
results[#results + 1] = "empty_cap=" .. (empty_cap == 1 and "pos" or "other")

-- Test 5: %g pattern class (printable except space, 5.2+)
local g_ok = pcall(function()
    return string.match("ab cd", "%g+")
end)
if g_ok then
    local match = string.match("ab cd", "%g+")
    results[#results + 1] = "g_class=" .. (match == "ab" and "works" or "fail")
else
    results[#results + 1] = "g_class=nil"
end

-- Test 6: string.gmatch named captures (behavior)
local gmatch_test = {}
for w in string.gmatch("hello world lua", "(%w+)") do
    gmatch_test[#gmatch_test + 1] = w
end
results[#results + 1] = "gmatch=" .. #gmatch_test

-- Test 7: string.gsub return type consistency
local replaced, count = string.gsub("aaa", "a", "b")
results[#results + 1] = "gsub_count=" .. count

-- Test 8: Long string nesting
local nested = "[=[level1]=]"
results[#results + 1] = "nested_str=" .. (nested:find("level1") and "works" or "fail")

-- Test 9: NUL bytes in strings
local with_nul = "hello\0world"
results[#results + 1] = "nul=" .. #with_nul

-- Test 10: string.format %q
local quoted = string.format("%q", "line1\nline2")
results[#results + 1] = "format_q=" .. (quoted:find("\\n") and "escaped" or "literal")

-- Test 11: string.format %s with nil (behavior varies)
local nil_fmt = pcall(function()
    return string.format("%s", nil)
end)
results[#results + 1] = "fmt_nil=" .. (nil_fmt and "ok" or "error")

-- Test 12: Very long patterns
local long_pattern = string.rep("a", 100)
local long_string = string.rep("a", 100)
local match = string.match(long_string, long_pattern)
results[#results + 1] = "long_pat=" .. (match == long_string and "works" or "fail")

-- Test 13: Unicode in patterns (basic)
local utf8_str = "héllo"
local len_bytes = #utf8_str
results[#results + 1] = "utf8_bytes=" .. len_bytes

print(table.concat(results, ","))
-- Expected varies by Lua version
