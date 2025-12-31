-- Test: Upvalue reassignment scenarios
local results = {}

-- Test 1: Reassign upvalue to different type
local val = 10
local function getVal()
    return val
end
results[#results + 1] = "type1=" .. type(getVal())
val = "string"
results[#results + 1] = "type2=" .. type(getVal())
val = {x = 1}
results[#results + 1] = "type3=" .. type(getVal())

-- Test 2: Reassign upvalue to nil
local nilable = "exists"
local function getNilable()
    return nilable
end
results[#results + 1] = "before_nil=" .. tostring(getNilable())
nilable = nil
results[#results + 1] = "after_nil=" .. tostring(getNilable())

-- Test 3: Swap upvalues
local a, b = 1, 2
local function getA() return a end
local function getB() return b end
local function swap()
    a, b = b, a
end
results[#results + 1] = "before_swap=" .. getA() .. ";" .. getB()
swap()
results[#results + 1] = "after_swap=" .. getA() .. ";" .. getB()

-- Test 4: Reassign in loop
local loopVal = 0
local function getLoopVal()
    return loopVal
end
for i = 1, 5 do
    loopVal = i
end
results[#results + 1] = "loop_reassign=" .. getLoopVal()

-- Test 5: Reassign from closure
local outer = 100
local function setOuter(v)
    outer = v
end
setOuter(200)
results[#results + 1] = "closure_reassign=" .. outer

-- Test 6: Chain of reassignments
local chain = 0
local function step1() chain = chain + 1 end
local function step2() chain = chain * 2 end
local function step3() chain = chain + 10 end
step1(); step2(); step3(); step1(); step2()
results[#results + 1] = "chain=" .. chain

print(table.concat(results, ","))
-- Expected: type1=number,type2=string,type3=table,before_nil=exists,after_nil=nil,before_swap=1;2,after_swap=2;1,loop_reassign=5,closure_reassign=200,chain=26
