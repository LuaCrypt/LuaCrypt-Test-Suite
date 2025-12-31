-- Test: Expressions evaluated in conditions
local results = {}

-- Test 1: Function call in condition
local function getValue()
    results[#results + 1] = "getValue_called"
    return 42
end

if getValue() > 40 then
    results[#results + 1] = "gt40"
end

-- Test 2: Table access in condition
local t = {flag = true, value = 10}
if t.flag then
    results[#results + 1] = "flag_set"
end

-- Test 3: Computed table key in condition
local key = "value"
if t[key] > 5 then
    results[#results + 1] = "computed_key"
end

-- Test 4: Method call in condition
local obj = {
    check = function(self, threshold)
        return self.data > threshold
    end,
    data = 100
}
if obj:check(50) then
    results[#results + 1] = "method_check"
end

-- Test 5: Arithmetic in condition
local x = 5
if x * 2 + 3 > 10 then
    results[#results + 1] = "arithmetic"
end

-- Test 6: String concatenation in condition (truthy check)
local s1, s2 = "hello", "world"
if s1 .. s2 then
    results[#results + 1] = "concat_truthy"
end

print(table.concat(results, ","))
-- Expected: getValue_called,gt40,flag_set,computed_key,method_check,arithmetic,concat_truthy
