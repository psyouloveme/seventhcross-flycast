local constants = {
    sizeof = {
        float = 4
    },
    dump_type = {
        None = 0,
        Player = 1,
        Main = 2,
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
        }
    },
    addrs = {
        Evp = 0x8c1e19ec
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
    }
}

return constants