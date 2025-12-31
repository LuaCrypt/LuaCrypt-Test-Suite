-- Test: API-like usage patterns
local results = {}

-- Test 1: REST-like API simulation
local function createAPI()
    local data = {}
    local id_counter = 0

    return {
        get = function(id)
            return data[id]
        end,
        list = function()
            local items = {}
            for id, item in pairs(data) do
                items[#items + 1] = {id = id, data = item}
            end
            return items
        end,
        create = function(item)
            id_counter = id_counter + 1
            data[id_counter] = item
            return id_counter
        end,
        update = function(id, item)
            if data[id] then
                data[id] = item
                return true
            end
            return false
        end,
        delete = function(id)
            if data[id] then
                data[id] = nil
                return true
            end
            return false
        end
    }
end

local api = createAPI()
local id1 = api.create({name = "item1"})
local id2 = api.create({name = "item2"})
api.update(id1, {name = "updated1"})
local item1 = api.get(id1)
api.delete(id2)
local list = api.list()
results[#results + 1] = "api=" .. item1.name .. ":" .. #list

-- Test 2: Query builder pattern
local function createQueryBuilder()
    local query = {
        _select = "*",
        _from = nil,
        _where = {},
        _order = nil,
        _limit = nil
    }

    local builder = {}

    function builder:select(fields)
        query._select = fields
        return self
    end

    function builder:from(table_name)
        query._from = table_name
        return self
    end

    function builder:where(condition)
        query._where[#query._where + 1] = condition
        return self
    end

    function builder:orderBy(field)
        query._order = field
        return self
    end

    function builder:limit(n)
        query._limit = n
        return self
    end

    function builder:build()
        local sql = "SELECT " .. query._select
        sql = sql .. " FROM " .. (query._from or "?")
        if #query._where > 0 then
            sql = sql .. " WHERE " .. table.concat(query._where, " AND ")
        end
        if query._order then
            sql = sql .. " ORDER BY " .. query._order
        end
        if query._limit then
            sql = sql .. " LIMIT " .. query._limit
        end
        return sql
    end

    return builder
end

local qb = createQueryBuilder()
local sql = qb:select("id, name"):from("users"):where("active = 1"):where("age > 18"):orderBy("name"):limit(10):build()
results[#results + 1] = "query=" .. (sql:find("SELECT id, name") and "ok" or "fail")

-- Test 3: Configuration builder
local function createConfig()
    local config = {}

    return {
        set = function(key, value)
            local parts = {}
            for part in key:gmatch("[^.]+") do
                parts[#parts + 1] = part
            end
            local current = config
            for i = 1, #parts - 1 do
                current[parts[i]] = current[parts[i]] or {}
                current = current[parts[i]]
            end
            current[parts[#parts]] = value
        end,
        get = function(key)
            local parts = {}
            for part in key:gmatch("[^.]+") do
                parts[#parts + 1] = part
            end
            local current = config
            for i = 1, #parts do
                if current[parts[i]] == nil then return nil end
                current = current[parts[i]]
            end
            return current
        end
    }
end

local cfg = createConfig()
cfg.set("database.host", "localhost")
cfg.set("database.port", 5432)
cfg.set("app.name", "test")
results[#results + 1] = "config=" .. cfg.get("database.host") .. ":" .. cfg.get("database.port")

-- Test 4: Event emitter with namespaces
local function createEventEmitter()
    local handlers = {}

    return {
        on = function(event, handler)
            local parts = {}
            for part in event:gmatch("[^:]+") do
                parts[#parts + 1] = part
            end
            local namespace = parts[1]
            local name = parts[2] or "*"

            handlers[namespace] = handlers[namespace] or {}
            handlers[namespace][name] = handlers[namespace][name] or {}
            handlers[namespace][name][#handlers[namespace][name] + 1] = handler
        end,
        emit = function(event, data)
            local parts = {}
            for part in event:gmatch("[^:]+") do
                parts[#parts + 1] = part
            end
            local namespace = parts[1]
            local name = parts[2]

            if handlers[namespace] then
                if handlers[namespace][name] then
                    for _, h in ipairs(handlers[namespace][name]) do
                        h(data)
                    end
                end
                if handlers[namespace]["*"] then
                    for _, h in ipairs(handlers[namespace]["*"]) do
                        h(data)
                    end
                end
            end
        end
    }
end

local ee = createEventEmitter()
local emit_log = {}
ee.on("user:login", function(d) emit_log[#emit_log + 1] = "login:" .. d end)
ee.on("user:*", function(d) emit_log[#emit_log + 1] = "any:" .. d end)
ee.emit("user:login", "john")
results[#results + 1] = "events=" .. table.concat(emit_log, ",")

-- Test 5: Validation pipeline
local function createValidator()
    local rules = {}

    return {
        addRule = function(field, validator, message)
            rules[field] = rules[field] or {}
            rules[field][#rules[field] + 1] = {fn = validator, msg = message}
        end,
        validate = function(data)
            local errors = {}
            for field, field_rules in pairs(rules) do
                for _, rule in ipairs(field_rules) do
                    if not rule.fn(data[field]) then
                        errors[field] = errors[field] or {}
                        errors[field][#errors[field] + 1] = rule.msg
                    end
                end
            end
            return #errors == 0 and true or false, errors
        end
    }
end

local validator = createValidator()
validator.addRule("name", function(v) return v and #v > 0 end, "required")
validator.addRule("age", function(v) return v and v >= 18 end, "must be 18+")
local valid1, _ = validator.validate({name = "John", age = 20})
local valid2, _ = validator.validate({name = "", age = 15})
results[#results + 1] = "validate=" .. tostring(valid1) .. ":" .. tostring(valid2)

-- Test 6: Request/Response pattern
local function createServer()
    local routes = {}

    return {
        route = function(method, path, handler)
            routes[method .. ":" .. path] = handler
        end,
        handle = function(req)
            local key = req.method .. ":" .. req.path
            if routes[key] then
                local res = {status = 200, body = nil}
                routes[key](req, res)
                return res
            end
            return {status = 404, body = "Not Found"}
        end
    }
end

local server = createServer()
server.route("GET", "/users", function(req, res)
    res.body = "users list"
end)
server.route("POST", "/users", function(req, res)
    res.body = "created: " .. req.body
end)

local res1 = server.handle({method = "GET", path = "/users"})
local res2 = server.handle({method = "POST", path = "/users", body = "john"})
local res3 = server.handle({method = "GET", path = "/unknown"})
results[#results + 1] = "server=" .. res1.status .. ":" .. res2.body .. ":" .. res3.status

print(table.concat(results, ","))
-- Expected: api=updated1:1,query=ok,config=localhost:5432,events=login:john,any:john,validate=true:false,server=200:created: john:404
