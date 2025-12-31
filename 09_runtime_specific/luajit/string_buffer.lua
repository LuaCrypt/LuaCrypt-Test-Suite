-- Test: LuaJIT string buffer optimizations
local results = {}

if not jit then
    results[#results + 1] = "skip=not_luajit"
    print(table.concat(results, ","))
    return
end

-- Test 1: String concatenation in loop (interned)
local s1 = ""
for i = 1, 100 do
    s1 = s1 .. "x"
end
results[#results + 1] = "concat_len=" .. #s1

-- Test 2: table.concat efficiency
local t2 = {}
for i = 1, 100 do
    t2[i] = "x"
end
local s2 = table.concat(t2)
results[#results + 1] = "tbl_concat=" .. #s2

-- Test 3: String interning
local a = "hello"
local b = "hel" .. "lo"
results[#results + 1] = "intern=" .. tostring(a == b)

-- Test 4: String buffer pattern
local buffer = {}
local n = 0
for i = 1, 100 do
    n = n + 1
    buffer[n] = string.char(65 + (i % 26))
end
local s4 = table.concat(buffer)
results[#results + 1] = "buffer=" .. #s4

-- Test 5: string.format performance
local formatted = {}
for i = 1, 100 do
    formatted[i] = string.format("%d", i)
end
local s5 = table.concat(formatted, ",")
results[#results + 1] = "format=" .. (s5:find("50") and "found" or "notfound")

-- Test 6: string.rep
local s6 = string.rep("abc", 100)
results[#results + 1] = "rep=" .. #s6

-- Test 7: String pattern matching
local matches = 0
local text = string.rep("hello world ", 100)
for w in text:gmatch("%w+") do
    matches = matches + 1
end
results[#results + 1] = "gmatch=" .. matches

-- Test 8: gsub count
local s8, count = text:gsub("world", "lua")
results[#results + 1] = "gsub=" .. count

-- Test 9: String comparison (hash-based)
local strings = {}
for i = 1, 100 do
    strings[i] = "string" .. i
end
local found = 0
for i = 1, 100 do
    if strings[i] == "string50" then
        found = 1
        break
    end
end
results[#results + 1] = "compare=" .. found

-- Test 10: Substring extraction
local subs = {}
local long = string.rep("abcdefghij", 10)
for i = 1, 100 do
    subs[i] = long:sub(i, i + 5)
end
results[#results + 1] = "substr=" .. #subs

-- Test 11: String keys in table
local str_tbl = {}
for i = 1, 100 do
    str_tbl["key" .. i] = i
end
local lookup_sum = 0
for i = 1, 100 do
    lookup_sum = lookup_sum + str_tbl["key" .. i]
end
results[#results + 1] = "str_key=" .. lookup_sum

-- Test 12: Byte manipulation
local bytes = {}
for i = 1, 100 do
    bytes[i] = string.char(65 + (i % 26))
end
local byte_str = table.concat(bytes)
local byte_sum = 0
for i = 1, #byte_str do
    byte_sum = byte_sum + byte_str:byte(i)
end
results[#results + 1] = "bytes=" .. byte_sum

print(table.concat(results, ","))
-- Expected: concat_len=100,tbl_concat=100,intern=true,buffer=100,format=found,rep=300,gmatch=200,gsub=100,compare=1,substr=100,str_key=5050,bytes=...
