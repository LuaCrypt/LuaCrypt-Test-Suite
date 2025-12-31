-- Test: IO operations with string manipulation
-- Note: Avoids actual file I/O for portability
local results = {}

-- Test 1: type checking
results[#results + 1] = "io_type=" .. type(io)

-- Test 2: io.write exists
results[#results + 1] = "write_fn=" .. type(io.write)

-- Test 3: io.read exists
results[#results + 1] = "read_fn=" .. type(io.read)

-- Test 4: io.output exists
results[#results + 1] = "output_fn=" .. type(io.output)

-- Test 5: io.input exists
results[#results + 1] = "input_fn=" .. type(io.input)

-- Test 6: io.stdin/stdout/stderr
results[#results + 1] = "stdin=" .. (io.stdin and "exists" or "nil")
results[#results + 1] = "stdout=" .. (io.stdout and "exists" or "nil")
results[#results + 1] = "stderr=" .. (io.stderr and "exists" or "nil")

-- Test 7: file type (simulated)
local f = io.tmpfile and io.tmpfile()
if f then
    results[#results + 1] = "tmpfile=" .. (type(f) == "userdata" and "valid" or "invalid")
    f:close()
else
    results[#results + 1] = "tmpfile=skipped"
end

-- Test 8: io.type function
results[#results + 1] = "type_fn=" .. type(io.type)
if io.stdout then
    local ftype = io.type(io.stdout)
    results[#results + 1] = "stdout_type=" .. (ftype == "file" and "file" or "other")
end

-- Test 9: io.lines function exists
results[#results + 1] = "lines_fn=" .. type(io.lines)

-- Test 10: flush function
results[#results + 1] = "flush_fn=" .. type(io.flush)

-- Test 11: close function
results[#results + 1] = "close_fn=" .. type(io.close)

-- Test 12: open function
results[#results + 1] = "open_fn=" .. type(io.open)

print(table.concat(results, ","))
-- Expected: io_type=table,write_fn=function,read_fn=function,output_fn=function,input_fn=function,stdin=exists,stdout=exists,stderr=exists,tmpfile=valid,type_fn=function,stdout_type=file,lines_fn=function,flush_fn=function,close_fn=function,open_fn=function
