-- Test: Basic string library functions
local results = {}

-- Test 1: Length and concatenation
local s = "hello"
results[#results + 1] = "len=" .. #s
results[#results + 1] = "concat=" .. (s .. " world")

-- Test 2: Upper/lower
results[#results + 1] = "upper=" .. string.upper("hello")
results[#results + 1] = "lower=" .. string.lower("HELLO")

-- Test 3: Sub
results[#results + 1] = "sub=" .. string.sub("hello", 2, 4)
results[#results + 1] = "sub_neg=" .. string.sub("hello", -3)

-- Test 4: Rep
results[#results + 1] = "rep=" .. string.rep("ab", 3)

-- Test 5: Byte and char
results[#results + 1] = "byte=" .. string.byte("A")
results[#results + 1] = "char=" .. string.char(65)

-- Test 6: Find
local pos = string.find("hello world", "world")
results[#results + 1] = "find=" .. (pos or "nil")

-- Test 7: Match
local matched = string.match("hello123", "%d+")
results[#results + 1] = "match=" .. (matched or "nil")

-- Test 8: Gsub
local replaced, count = string.gsub("hello hello", "hello", "hi")
results[#results + 1] = "gsub=" .. replaced .. ":" .. count

-- Test 9: Format
results[#results + 1] = "format=" .. string.format("%d+%d=%d", 2, 3, 5)

-- Test 10: Reverse
results[#results + 1] = "reverse=" .. string.reverse("abc")

print(table.concat(results, ","))
-- Expected: len=5,concat=hello world,upper=HELLO,lower=hello,sub=ell,sub_neg=llo,rep=ababab,byte=65,char=A,find=7,match=123,gsub=hi hi:2,format=2+3=5,reverse=cba
