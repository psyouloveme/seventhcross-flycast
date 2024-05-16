local memory = {}

---Read a 1-byte (8-bit) value from memory
---@param addr integer the memory address to read from
---@return any value the value read from memory
function memory.read8(addr)
    local val = flycast.memory.read8(addr)
    return val
end

---Read a 2-byte (16-bit) value from memory
---@param addr integer the memory address to read from
---@return any value the value read from memory
function memory.read16(addr)
    local val = flycast.memory.read16(addr)
    return val
end

---Read a 2-byte (16-bit) value from memory then reverse the byte order
---@param addr integer the memory address to read from
---@return any value the value read from memory
function memory.read16_rbo(addr)
    local val = flycast.memory.read16(addr)
    local rbo = 0
    if val ~= 0 then
        rbo = memory.util.reverse_byte_order(val)
    end
    return rbo
end

---Read a 4-byte (32-bit) value from memory
---@param addr integer the memory address to read from
---@return any value the value read from memory
function memory.read32(addr)
    local val = flycast.memory.read32(addr)
    return val
end

---Read a 8-byte (64-bit) value from memory
---@param addr integer the memory address to read from
---@return any value the value read from memory
function memory.read64(addr)
    local val = flycast.memory.read64(addr)
    return val
end

---DEPRECATED: Read a 4-byte (32-bit) floating point value from memory
---@param addr integer the memory address to read from
---@return number|nil value the value read from memory
function memory.read32_dumb_str(addr)
    local b1 = memory.util.tohexchar(memory.read8(addr))
    local b2 = memory.util.tohexchar(memory.read8(addr+1))
    local b3 = memory.util.tohexchar(memory.read8(addr+2))
    local b4 = memory.util.tohexchar(memory.read8(addr+3))
    return tonumber(b4..b3..b2..b1)
end

---DEPRECATED: Read a 4-byte (32-bit) floating point value from memory
---@param addr integer the memory address to read from
---@return number|nil value the value read from memory
function memory.read32_dumb_str2(addr)
    local b1 = memory.util.tohexchar(memory.read8(addr))
    local b2 = memory.util.tohexchar(memory.read8(addr+1))
    local b3 = memory.util.tohexchar(memory.read8(addr+2))
    local b4 = memory.util.tohexchar(memory.read8(addr+3))
    return memory.util.convertFloat(b4..b3..b2..b1)
end

---DEPRECATED: Read a 4-byte (32-bit) floating point value from memory
---@param addr integer the memory address to read from
---@return number|nil value the value read from memory
function memory.read32_dumb_str3(addr)
    local b1 = memory.util.tohexchar(memory.read8(addr))
    local b2 = memory.util.tohexchar(memory.read8(addr+1))
    local b3 = memory.util.tohexchar(memory.read8(addr+2))
    local b4 = memory.util.tohexchar(memory.read8(addr+3))
    return tonumber(b1..b2..b3..b4)
end

---DEPRECATED: Read a 4-byte (32-bit) floating point value from memory
---@param addr integer the memory address to read from
---@return number value the value read from memory
function memory.read32_dumb_str4(addr)
    local b1 = memory.util.tohexchar(memory.read8(addr))
    local b2 = memory.util.tohexchar(memory.read8(addr+1))
    local b3 = memory.util.tohexchar(memory.read8(addr+2))
    local b4 = memory.util.tohexchar(memory.read8(addr+3))
    return memory.util.convertFloat(b1..b2..b3..b4)
end


---Read a 4-byte (32-bit) floating point value from memory
---@param addr integer the memory address to read from
---@return number value the value read from memory
function memory.readFloat32(addr)
    local bs = memory.read32(addr)
    -- print(string.format("bs: 0x%08x",bs))
    -- print(string.format("about to repack %04x read at %08x", bs, addr))
    local ss = string.pack("i4",bs)
    local ff = string.unpack("f",ss)
    return ff
end

---DEPRECATED: Read a 4-byte (32-bit) floating point value from memory
---@param addr integer the memory address to read from
---@return number value the value read from memory
function memory.readFloat32_old(addr)
    local raw_val = memory.read32(addr)
    return memory.util.fix_mem_float(raw_val)
    -- local string_val = string.format("%08x",raw_val)
    -- local converted_val = memory.util.convertFloat(string_val)
    -- return converted_val
end

memory.util = {}

---Convert a number to a hex string
---@param c any the number to convert
---@return string result the hex string representation
function memory.util.tohexchar(c)
    return string.format("%02x", c)
end

---DEPRECATED: attempt to fix a floating point number read from memory
---@param raw_val any the number to fix
---@return number result the floating point result
function memory.util.fix_mem_float(raw_val)
    local string_val = string.format("%04x",raw_val)
    local converted_val = memory.util.convertFloat(string_val)
    return converted_val
end

---Convert a value to a hex string in reverse byte order
---@param bytes any the number to convert
---@return string result the reverse byte order string representation
function memory.util.get_rbo_string(bytes)
    local temp_hex_string = string.format("%04x",bytes)
    local temp_table = {}
    local final_string = ""
    for byte_str in string.gmatch(temp_hex_string, "[a-zA-Z0-9][a-zA-Z0-9]") do
        table.insert(temp_table, byte_str) end
    table.sort(temp_table, function(lef, rig) return lef < rig end)
    final_string = table.concat(temp_table)
    return final_string
end

---Convert a value to a hex string in reverse byte order
---@param bytes any the number to convert
---@return number result the number representation of the reversed value
function memory.util.reverse_byte_order(bytes)
    local n = tonumber(memory.util.get_rbo_string(bytes))
    if n == nil then
        error("unable to reverse byte order of "..tostring(bytes))
    end
    return n
end

---http://lua-users.org/lists/lua-l/2010-03/msg00910.html
---Convert a float from memory to a version that can be represented as bytes.
---This isn't the original intended use of this method.
---@param x number|string the float to convert
---@return integer val byte string value that can be used to print raw bytes
function memory.util.convertFloat(x)
    local sign = 1
    local mantissa = string.byte(x, 3) % 128

    for i = 2, 1, -1 do
        mantissa = mantissa * 256 + string.byte(x, i)
    end

    if string.byte(x, 4) > 127 then
        sign = -1
    end
    local exponent = (string.byte(x, 4) % 128) * 2 + math.floor(string.byte(x, 3) / 128)
    if exponent == 0 then
        return 0
    end
---@diagnostic disable-next-line: deprecated
    mantissa = (math.ldexp(mantissa, -23) + 1) * sign
---@diagnostic disable-next-line: deprecated
    return math.ldexp(mantissa, exponent - 127)
end

memory.tests = {}

function memory.tests.try_float_print_formats(fl, label)
    if fl == nil then
      print(string.format("%s is nil", label))
    else
      print(string.format("%s: print: ", label), fl)
      print(string.format("%s: tostring: ", label), tostring(fl))
      print(string.format("%s: strf: %f", label, fl))
    end
  end
  
function memory.tests.try_float_formats(addr, label)
    local m1 = memory.read32(addr)
    local m2 = memory.readFloat32_old(addr)
    local m3 = memory.read32_dumb_str(addr)
    local m4 = memory.read32_dumb_str2(addr)
    local m5 = memory.read32_dumb_str3(addr)
    local m6 = memory.read32_dumb_str4(addr)
    local m7 = memory.readFloat32(addr)

    memory.tests.try_float_print_formats(m1, label.."-1")
    memory.tests.try_float_print_formats(m2, label.."-2")
    memory.tests.try_float_print_formats(m3, label.."-3")
    memory.tests.try_float_print_formats(m4, label.."-4")
    memory.tests.try_float_print_formats(m5, label.."-5")
    memory.tests.try_float_print_formats(m6, label.."-6")
    memory.tests.try_float_print_formats(m7, label.."-7")
end

return memory