-- Test: LuaJIT FFI basics (if available)
local results = {}

-- Check if LuaJIT
if not jit then
    results[#results + 1] = "skip=not_luajit"
    print(table.concat(results, ","))
    return
end

-- Try to load FFI
local ok, ffi = pcall(require, "ffi")
if not ok then
    results[#results + 1] = "skip=no_ffi"
    print(table.concat(results, ","))
    return
end

-- Test 1: FFI loaded
results[#results + 1] = "ffi=loaded"

-- Test 2: C types
ffi.cdef[[
    typedef struct { int x; int y; } Point;
]]
local pt = ffi.new("Point", 10, 20)
results[#results + 1] = "struct=" .. pt.x .. ":" .. pt.y

-- Test 3: Arrays
local arr = ffi.new("int[5]", {1, 2, 3, 4, 5})
results[#results + 1] = "array=" .. arr[2]  -- 0-indexed

-- Test 4: sizeof
results[#results + 1] = "sizeof=" .. ffi.sizeof("int")

-- Test 5: typeof
local int_t = ffi.typeof("int")
results[#results + 1] = "typeof=" .. type(int_t)

-- Test 6: String conversion
local cstr = ffi.new("char[6]", "hello")
results[#results + 1] = "cstr=" .. ffi.string(cstr)

-- Test 7: Casting
local ptr = ffi.cast("int*", ffi.new("int[1]", {42}))
results[#results + 1] = "cast=" .. ptr[0]

-- Test 8: istype
local is_point = ffi.istype("Point", pt)
results[#results + 1] = "istype=" .. tostring(is_point)

-- Test 9: copy
local src = ffi.new("int[3]", {10, 20, 30})
local dst = ffi.new("int[3]")
ffi.copy(dst, src, ffi.sizeof(src))
results[#results + 1] = "copy=" .. dst[1]

-- Test 10: fill
local buf = ffi.new("char[10]")
ffi.fill(buf, 10, 65)  -- Fill with 'A'
results[#results + 1] = "fill=" .. ffi.string(buf, 1)

-- Test 11: Struct with methods via metatables
ffi.cdef[[
    typedef struct { double x; double y; } Vec2;
]]
local Vec2
Vec2 = ffi.metatype("Vec2", {
    __add = function(a, b)
        return Vec2(a.x + b.x, a.y + b.y)
    end,
    __tostring = function(v)
        return string.format("(%g,%g)", v.x, v.y)
    end
})
local v1 = Vec2(1, 2)
local v2 = Vec2(3, 4)
local v3 = v1 + v2
results[#results + 1] = "metatype=" .. v3.x .. ":" .. v3.y

-- Test 12: Pointer arithmetic
local nums = ffi.new("int[5]", {10, 20, 30, 40, 50})
local ptr2 = nums + 2
results[#results + 1] = "ptrarith=" .. ptr2[0]

print(table.concat(results, ","))
-- Expected: ffi=loaded,struct=10:20,array=3,sizeof=4,typeof=cdata,cstr=hello,cast=42,istype=true,copy=20,fill=A,metatype=4:6,ptrarith=30
