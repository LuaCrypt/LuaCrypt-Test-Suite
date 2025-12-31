-- Test: Basic OS library functions (safe subset)
local results = {}

-- Test 1: os.time
local t1 = os.time()
results[#results + 1] = "time=" .. (type(t1) == "number" and t1 > 0 and "valid" or "invalid")

-- Test 2: os.time with table
local t2 = os.time({year=2020, month=1, day=1, hour=0, min=0, sec=0})
results[#results + 1] = "time_tbl=" .. (type(t2) == "number" and "valid" or "invalid")

-- Test 3: os.date components
local d3 = os.date("*t", 0)
-- epoch should be 1970 (or close)
results[#results + 1] = "date_t=" .. (d3.year >= 1969 and d3.year <= 1970 and "valid" or "invalid")

-- Test 4: os.date formatted
local d4 = os.date("%Y-%m-%d", os.time({year=2023, month=6, day=15}))
results[#results + 1] = "date_fmt=" .. (d4 == "2023-06-15" and "match" or "nomatch")

-- Test 5: os.difftime
local t5a = os.time({year=2020, month=1, day=1})
local t5b = os.time({year=2020, month=1, day=2})
local diff = os.difftime(t5b, t5a)
results[#results + 1] = "diff=" .. (diff == 86400 and "24h" or "other")

-- Test 6: os.clock
local c6 = os.clock()
results[#results + 1] = "clock=" .. (type(c6) == "number" and c6 >= 0 and "valid" or "invalid")

-- Test 7: os.date with format string
local d7 = os.date("%H:%M:%S", os.time({year=2020, month=1, day=1, hour=12, min=30, sec=45}))
results[#results + 1] = "time_fmt=" .. (d7 == "12:30:45" and "match" or "nomatch")

-- Test 8: os.date weekday
local d8 = os.date("*t", os.time({year=2024, month=1, day=1}))
-- Jan 1, 2024 was Monday (wday=2)
results[#results + 1] = "wday=" .. d8.wday

-- Test 9: os.date with ! (UTC)
local d9_local = os.date("*t")
local d9_utc = os.date("!*t")
results[#results + 1] = "utc=" .. (type(d9_utc.hour) == "number" and "valid" or "invalid")

-- Test 10: os.getenv (likely nil for random var)
local env = os.getenv("LUACRYPT_TEST_VAR_UNLIKELY_TO_EXIST")
results[#results + 1] = "getenv=" .. (env == nil and "nil" or "set")

-- Test 11: os.date year/month boundary
local boundary = os.time({year=2020, month=12, day=31, hour=23, min=59, sec=59})
local next_sec = boundary + 1
local d11 = os.date("*t", next_sec)
results[#results + 1] = "boundary=" .. d11.year .. ":" .. d11.month .. ":" .. d11.day

print(table.concat(results, ","))
-- Expected output depends on timezone, but format should be valid
