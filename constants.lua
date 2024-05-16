---@class GridDefinition
---@field height integer the height of the grid
---@field width integer the width of the grid
---@field value_size SizeOf the size (in bytes) of a value in the grid
---@field start_address USAddress the starting address of the grid

---@class MemoryRange
---@field Start integer the starting address of the range
---@field End integer the ending address of the range

---@class MemoryType
---@field size integer the size (in bytes) of the type
---@field id integer a unique identifier for this type

local constants = {
    ---@enum SizeOf
    sizeof = {
        float = 4;
        byte = 1;
    };
    ---@enum DumpType
    dump_type = {
        None = 0;
        Player = 1;
        Main = 2;
        MainGrid = 3;
        All = 4;
    };
    ---@enum USMemoryRange
    ranges = {
        ---@type MemoryRange
        MainMemory = {
            Start = 0x8c1b1744;
            End = 0x8d000000;
        };
        ---@type MemoryRange
        PlayerStruct = {
            Start = 0x8c1e1960;
            End = 0x8c010000;
        };
        ---@type MemoryRange
        MainGrid = {
            Start = 0x8c3be40c;
            End = 0x8c3e550c;
        };
    };
    ---@enum USAddress
    addrs = {
        Evp = 0x8c1e19ec,
        SuperGrid = 0x8c0c72b4,
        MainGrid = 0x8c3be40c
    };
    ---@enum MemoryTypes
    newtypes = {
        ---@type MemoryType
        byte = { size = 1, id = 1 };
        ---@type MemoryType
        float = { size = 4, id = 2 };
    };
    ---@enum DataTypes
    types = {
        Byte    = 1;
        Word    = 2;
        DWord   = 3;
        Int     = 4;
        Pointer = 5;
        UShort  = 6;
        Float   = 7;
        String  = 8;
        Short   = 9;
        Int8    = 10;
    };
    ---@enum PartType
    parts = {
        HEAD = 0;
        BODY = 1;
        ARM = 2;
        LEG = 3;
    };
};

---@enum GridDefinitions
constants.grid = {
    ---@type GridDefinition
    main = {
        height = 200;
        width = 200;
        value_size = constants.sizeof.float;
        start_address = constants.addrs.MainGrid;
    };
    ---@type GridDefinition
    super = {
        height = 20;
        width = 20;
        value_size = constants.sizeof.byte;
        start_address = constants.addrs.SuperGrid;
    };
    ---@type GridDefinition
    sub = {
        height = 10;
        width = 10;
        value_size = constants.sizeof.float;
        start_address = constants.addrs.MainGrid;
    };
}

---Get the string representation of a part type
---@param part_type PartType the part type to map
---@return string part_string the string representation of this part
function constants.get_part_string(part_type)
    if part_type == constants.parts.HEAD then return "HEAD" end
    if part_type == constants.parts.ARM then return "ARM" end
    if part_type == constants.parts.BODY then return "BODY" end
    if part_type == constants.parts.LEG then return "LEG" end
    return "INVALID"
end

return constants