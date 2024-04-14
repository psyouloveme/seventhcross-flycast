local memory = {}

function memory.read8(addr)
    local val = flycast.memory.read8(addr)
    return val
end

function memory.read16(addr)
    local val = flycast.memory.read16(addr)
    return val
end

function memory.read16_rbo(addr)
    local val = flycast.memory.read16(addr)
    local rbo = 0
    if val ~= 0 then
        rbo = memory.util.reverse_byte_order(val)
    end
    return rbo
end

function memory.read32(addr)
    local val = flycast.memory.read32(addr)
    return val
end

function memory.read64(addr)
    local val = flycast.memory.read64(addr)
    return val
end

function memory.read32_dumb_str(addr)
    local b1 = memory.util.tohexchar(memory.read8(addr))
    local b2 = memory.util.tohexchar(memory.read8(addr+1))
    local b3 = memory.util.tohexchar(memory.read8(addr+2))
    local b4 = memory.util.tohexchar(memory.read8(addr+3))
    return tonumber(b4..b3..b2..b1)
end

function memory.read32_dumb_str2(addr)
    local b1 = memory.util.tohexchar(memory.read8(addr))
    local b2 = memory.util.tohexchar(memory.read8(addr+1))
    local b3 = memory.util.tohexchar(memory.read8(addr+2))
    local b4 = memory.util.tohexchar(memory.read8(addr+3))
    return memory.util.convertFloat(b4..b3..b2..b1)
end

function memory.read32_dumb_str3(addr)
    local b1 = memory.util.tohexchar(memory.read8(addr))
    local b2 = memory.util.tohexchar(memory.read8(addr+1))
    local b3 = memory.util.tohexchar(memory.read8(addr+2))
    local b4 = memory.util.tohexchar(memory.read8(addr+3))
    return tonumber(b1..b2..b3..b4)
end

function memory.read32_dumb_str4(addr)
    local b1 = memory.util.tohexchar(memory.read8(addr))
    local b2 = memory.util.tohexchar(memory.read8(addr+1))
    local b3 = memory.util.tohexchar(memory.read8(addr+2))
    local b4 = memory.util.tohexchar(memory.read8(addr+3))
    return memory.util.convertFloat(b1..b2..b3..b4)
end

function memory.read32_dumb_str5(addr)
    local bs = memory.read32(addr)
    -- print(string.format("about to repack %04x read at %08x", bs, addr))
    local ss = string.pack("i4",bs)
    local ff = string.unpack("f",ss)
    return ff
end


function memory.readFloat32(addr)
    local raw_val = memory.read32(addr)
    return memory.util.fix_mem_float(raw_val)
    -- local string_val = string.format("%08x",raw_val)
    -- local converted_val = memory.util.convertFloat(string_val)
    -- return converted_val
end

memory.util = {}
function memory.util.tohexchar(c)
    return string.format("%02x", c)
end

function memory.util.tohexstr(s)
    return string.format("%02x", s)
end

function memory.util.fix_mem_float(raw_val)
    local string_val = string.format("%04x",raw_val)
    local converted_val = memory.util.convertFloat(string_val)
    return converted_val
end

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

function memory.util.reverse_byte_order(bytes)
    return tonumber(memory.util.get_rbo_string(bytes))
end

-- http://lua-users.org/lists/lua-l/2010-03/msg00910.html
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

return memory