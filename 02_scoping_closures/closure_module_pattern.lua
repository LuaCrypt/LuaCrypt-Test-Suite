-- Test: Module pattern using closures
local results = {}

-- Test 1: Simple module
local Counter = (function()
    local count = 0  -- Private

    return {
        increment = function()
            count = count + 1
        end,
        decrement = function()
            count = count - 1
        end,
        getCount = function()
            return count
        end
    }
end)()

Counter.increment()
Counter.increment()
Counter.decrement()
results[#results + 1] = "module=" .. Counter.getCount()

-- Test 2: Module with private functions
local Calculator = (function()
    -- Private
    local function validate(n)
        return type(n) == "number"
    end

    local lastResult = 0

    -- Public
    return {
        add = function(a, b)
            if validate(a) and validate(b) then
                lastResult = a + b
                return lastResult
            end
            return nil
        end,
        getLastResult = function()
            return lastResult
        end
    }
end)()

Calculator.add(5, 3)
results[#results + 1] = "calc=" .. Calculator.getLastResult()

-- Test 3: Module factory
local function createBank(initial)
    local balance = initial or 0

    return {
        deposit = function(amount)
            if amount > 0 then
                balance = balance + amount
                return true
            end
            return false
        end,
        withdraw = function(amount)
            if amount > 0 and amount <= balance then
                balance = balance - amount
                return true
            end
            return false
        end,
        getBalance = function()
            return balance
        end
    }
end

local bank = createBank(100)
bank.deposit(50)
bank.withdraw(30)
results[#results + 1] = "bank=" .. bank.getBalance()

-- Test 4: Multiple instances don't share state
local bank1 = createBank(100)
local bank2 = createBank(200)
bank1.deposit(50)
results[#results + 1] = "bank1=" .. bank1.getBalance() .. "_bank2=" .. bank2.getBalance()

-- Test 5: Revealing module pattern
local RevealingModule = (function()
    local privateVar = "secret"
    local publicVar = "public"

    local function privateMethod()
        return privateVar
    end

    local function publicMethod()
        return privateMethod() .. "+" .. publicVar
    end

    return {
        method = publicMethod,
        value = publicVar
    }
end)()

results[#results + 1] = "revealing=" .. RevealingModule.method()

print(table.concat(results, ","))
-- Expected: module=1,calc=8,bank=120,bank1=150_bank2=200,revealing=secret+public
