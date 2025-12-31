-- Test: String pattern matching
local results = {}

-- Test 1: Character classes
results[#results + 1] = "digit=" .. (string.match("abc123", "%d+") or "nil")
results[#results + 1] = "alpha=" .. (string.match("123abc", "%a+") or "nil")
results[#results + 1] = "alnum=" .. (string.match("---abc123---", "%w+") or "nil")

-- Test 2: Quantifiers
results[#results + 1] = "star=" .. (string.match("aaab", "a*") or "nil")
results[#results + 1] = "plus=" .. (string.match("aaab", "a+") or "nil")
results[#results + 1] = "opt=" .. #(string.match("ab", "a?b") or "")

-- Test 3: Captures
local a, b = string.match("hello world", "(%w+) (%w+)")
results[#results + 1] = "capture=" .. a .. ":" .. b

-- Test 4: Character sets
results[#results + 1] = "set=" .. (string.match("abc123", "[abc]+") or "nil")
results[#results + 1] = "negset=" .. (string.match("abc123", "[^abc]+") or "nil")

-- Test 5: Anchors
results[#results + 1] = "start=" .. (string.match("hello", "^h") and "yes" or "no")
results[#results + 1] = "end=" .. (string.match("hello", "o$") and "yes" or "no")

-- Test 6: gmatch iterator
local words = {}
for w in string.gmatch("hello world lua", "%w+") do
    words[#words + 1] = w
end
results[#results + 1] = "gmatch=" .. #words

-- Test 7: Frontier pattern (Lua 5.2+)
if pcall(function() string.match("hello", "%f[%a]") end) then
    local boundary = string.match("the cat sat", "%f[%a]cat")
    results[#results + 1] = "frontier=" .. (boundary and "yes" or "no")
end

-- Test 8: Balanced match
local nested = string.match("(a(b)c)", "%b()")
results[#results + 1] = "balanced=" .. (nested and #nested or 0)

print(table.concat(results, ","))
-- Expected: digit=123,alpha=abc,alnum=abc123,star=aaa,plus=aaa,opt=2,capture=hello:world,set=abc,negset=123,start=yes,end=yes,gmatch=3,frontier=yes,balanced=7
