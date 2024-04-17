local constants = {
    sizeof = {
        float = 4,
        byte = 1
    },
    dump_type = {
        None = 0,
        Player = 1,
        Main = 2,
        MainGrid = 3,
        All = 4
    },
    ranges = {
        MainMemory = {
            Start = 0x8c1b1744,
            End = 0x8d000000
        },
        PlayerStruct = {
            Start = 0x8c1e1960,
            End = 0x8c010000
        },
        MainGrid = {
            Start = 0x8c3be40c,
            End = 0x8c3e550c
        }
    },
    addrs = {
        Evp = 0x8c1e19ec,
        SuperGrid = 0x8c0c72b4,
        MainGrid = 0x8c3be40c
    },
    newtypes = {
        byte = { size = 1, id = 1 },
        float = { size = 4, id = 2 }
    },
    types = {
        Byte    = 1,
        Word    = 2,
        DWord   = 3,
        Int     = 4,
        Pointer = 5,
        UShort  = 6,
        Float   = 7,
        String  = 8,
        Short   = 9,
        Int8    = 10
    },
    parts = {
        HEAD = 0,
        BODY = 1,
        ARM = 2,
        LEG = 3
    }
}

function constants.get_part_string(part_type)
    if part_type == constants.parts.HEAD then return "HEAD" end
    if part_type == constants.parts.ARM then return "ARM" end
    if part_type == constants.parts.BODY then return "BODY" end
    if part_type == constants.parts.LEG then return "LEG" end
    return "INVALID"
end

return constants