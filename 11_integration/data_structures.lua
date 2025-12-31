-- Test: Common data structure implementations
local results = {}

-- Test 1: Stack
local function createStack()
    local items = {}
    return {
        push = function(item)
            items[#items + 1] = item
        end,
        pop = function()
            if #items > 0 then
                return table.remove(items)
            end
        end,
        peek = function()
            return items[#items]
        end,
        size = function()
            return #items
        end,
        isEmpty = function()
            return #items == 0
        end
    }
end

local stack = createStack()
stack.push(1)
stack.push(2)
stack.push(3)
local stack_vals = {stack.pop(), stack.pop(), stack.pop()}
results[#results + 1] = "stack=" .. table.concat(stack_vals, ":")

-- Test 2: Queue
local function createQueue()
    local first = 1
    local last = 0
    local items = {}

    return {
        enqueue = function(item)
            last = last + 1
            items[last] = item
        end,
        dequeue = function()
            if first <= last then
                local item = items[first]
                items[first] = nil
                first = first + 1
                return item
            end
        end,
        size = function()
            return last - first + 1
        end
    }
end

local queue = createQueue()
queue.enqueue(1)
queue.enqueue(2)
queue.enqueue(3)
local queue_vals = {queue.dequeue(), queue.dequeue(), queue.dequeue()}
results[#results + 1] = "queue=" .. table.concat(queue_vals, ":")

-- Test 3: Linked List
local function createLinkedList()
    local head = nil
    local tail = nil
    local size = 0

    return {
        append = function(val)
            local node = {value = val, next = nil}
            if not head then
                head = node
                tail = node
            else
                tail.next = node
                tail = node
            end
            size = size + 1
        end,
        prepend = function(val)
            local node = {value = val, next = head}
            head = node
            if not tail then tail = node end
            size = size + 1
        end,
        toArray = function()
            local arr = {}
            local current = head
            while current do
                arr[#arr + 1] = current.value
                current = current.next
            end
            return arr
        end,
        size = function() return size end
    }
end

local list = createLinkedList()
list.append(2)
list.append(3)
list.prepend(1)
results[#results + 1] = "list=" .. table.concat(list.toArray(), ":")

-- Test 4: Set
local function createSet()
    local items = {}

    return {
        add = function(item)
            items[item] = true
        end,
        remove = function(item)
            items[item] = nil
        end,
        has = function(item)
            return items[item] == true
        end,
        toArray = function()
            local arr = {}
            for k in pairs(items) do
                arr[#arr + 1] = k
            end
            table.sort(arr)
            return arr
        end
    }
end

local set = createSet()
set.add(3)
set.add(1)
set.add(2)
set.add(1)  -- duplicate
results[#results + 1] = "set=" .. table.concat(set.toArray(), ":")

-- Test 5: Map with default
local function createDefaultMap(default_fn)
    local items = {}

    return {
        get = function(key)
            if items[key] == nil then
                items[key] = default_fn()
            end
            return items[key]
        end,
        set = function(key, value)
            items[key] = value
        end
    }
end

local map = createDefaultMap(function() return 0 end)
map.set("a", map.get("a") + 1)
map.set("a", map.get("a") + 1)
map.set("b", map.get("b") + 1)
results[#results + 1] = "map=" .. map.get("a") .. ":" .. map.get("b")

-- Test 6: Priority Queue (min heap simulation)
local function createPriorityQueue()
    local items = {}

    local function siftUp(idx)
        while idx > 1 do
            local parent = math.floor(idx / 2)
            if items[parent].priority <= items[idx].priority then break end
            items[parent], items[idx] = items[idx], items[parent]
            idx = parent
        end
    end

    local function siftDown(idx)
        while idx * 2 <= #items do
            local child = idx * 2
            if child + 1 <= #items and items[child + 1].priority < items[child].priority then
                child = child + 1
            end
            if items[idx].priority <= items[child].priority then break end
            items[idx], items[child] = items[child], items[idx]
            idx = child
        end
    end

    return {
        insert = function(value, priority)
            items[#items + 1] = {value = value, priority = priority}
            siftUp(#items)
        end,
        extractMin = function()
            if #items == 0 then return nil end
            local min = items[1].value
            items[1] = items[#items]
            items[#items] = nil
            if #items > 0 then siftDown(1) end
            return min
        end
    }
end

local pq = createPriorityQueue()
pq.insert("low", 3)
pq.insert("high", 1)
pq.insert("med", 2)
local pq_vals = {pq.extractMin(), pq.extractMin(), pq.extractMin()}
results[#results + 1] = "pqueue=" .. table.concat(pq_vals, ":")

-- Test 7: LRU Cache
local function createLRU(capacity)
    local cache = {}
    local order = {}

    local function touch(key)
        for i, k in ipairs(order) do
            if k == key then
                table.remove(order, i)
                break
            end
        end
        order[#order + 1] = key
    end

    return {
        get = function(key)
            if cache[key] then
                touch(key)
                return cache[key]
            end
            return nil
        end,
        set = function(key, value)
            if cache[key] then
                touch(key)
            else
                if #order >= capacity then
                    local oldest = table.remove(order, 1)
                    cache[oldest] = nil
                end
                order[#order + 1] = key
            end
            cache[key] = value
        end,
        keys = function()
            return order
        end
    }
end

local lru = createLRU(3)
lru.set("a", 1)
lru.set("b", 2)
lru.set("c", 3)
lru.get("a")  -- touch a
lru.set("d", 4)  -- evicts b
results[#results + 1] = "lru=" .. table.concat(lru.keys(), ":")

print(table.concat(results, ","))
-- Expected: stack=3:2:1,queue=1:2:3,list=1:2:3,set=1:2:3,map=2:1,pqueue=high:med:low,lru=c:a:d
