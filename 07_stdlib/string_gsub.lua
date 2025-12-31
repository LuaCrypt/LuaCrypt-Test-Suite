-- Test: String gsub comprehensive
local results = {}

-- Test 1: Simple replacement
local s1 = string.gsub("hello world", "world", "lua")
results[#results + 1] = "simple=" .. s1

-- Test 2: Count replacements
local s2, c2 = string.gsub("aaa", "a", "b")
results[#results + 1] = "count=" .. s2 .. ":" .. c2

-- Test 3: Limited replacements
local s3 = string.gsub("aaa", "a", "b", 2)
results[#results + 1] = "limit=" .. s3

-- Test 4: Pattern replacement
local s4 = string.gsub("abc123def456", "%d+", "NUM")
results[#results + 1] = "pattern=" .. s4

-- Test 5: Capture substitution
local s5 = string.gsub("hello world", "(%w+)", "[%1]")
results[#results + 1] = "capture=" .. s5

-- Test 6: Function replacement
local s6 = string.gsub("hello", ".", function(c)
    return string.upper(c)
end)
results[#results + 1] = "func=" .. s6

-- Test 7: Table replacement
local t7 = {a = "1", b = "2", c = "3"}
local s7 = string.gsub("abc", ".", t7)
results[#results + 1] = "table=" .. s7

-- Test 8: Nested captures
local s8 = string.gsub("abc def", "((%w)%w+)", "<%1:%2>")
results[#results + 1] = "nested=" .. s8

-- Test 9: Empty pattern match
local s9 = string.gsub("abc", "", "-")
results[#results + 1] = "empty_len=" .. #s9

-- Test 10: Special characters in replacement
local s10 = string.gsub("hello", "l", "%%")
results[#results + 1] = "special=" .. s10

-- Test 11: No match
local s11, c11 = string.gsub("hello", "x", "y")
results[#results + 1] = "nomatch=" .. s11 .. ":" .. c11

-- Test 12: Anchor patterns
local s12 = string.gsub("hello", "^.", "X")
results[#results + 1] = "anchor=" .. s12

-- Test 13: Function returning nil (no replacement)
local s13 = string.gsub("abcde", ".", function(c)
    if c == "c" then return nil end
    return string.upper(c)
end)
results[#results + 1] = "nilret=" .. s13

-- Test 14: Complex pattern
local s14 = string.gsub("key=value;foo=bar", "(%w+)=(%w+)", "%2=%1")
results[#results + 1] = "complex=" .. s14

print(table.concat(results, ","))
-- Expected: simple=hello lua,count=bbb:3,limit=bba,pattern=abcNUMdefNUM,capture=[hello] [world],func=HELLO,table=123,nested=<abc:a> <def:d>,empty_len=7,special=he%%o,nomatch=hello:0,anchor=Xello,nilret=ABcDE,complex=value=key;bar=foo
