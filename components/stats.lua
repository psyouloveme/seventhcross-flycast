
local memory = require("lua.seventhcross.emulator.memory")
local consts = require("lua.seventhcross.constants")

local stat_exports = {}
local types = consts.types

stat_exports.StatLabels = {
    [0x8c1e1960] = { type_name = types.Pointer,   label = "Ptr0" },
    [0x8c1e1964] = { type_name = types.Pointer,   label = "Ptr1" },
    [0x8c1e1968] = { type_name = types.Pointer,   label = "Ptr2" },
    [0x8c1e196c] = { type_name = types.Pointer,   label = "Ptr3" },
    [0x8c1e1970] = { type_name = types.Float,     label = "Float0" },
    [0x8c1e1974] = { type_name = types.Float,     label = "Float1" },
    [0x8c1e1978] = { type_name = types.Float,     label = "Float2" },
    [0x8c1e197c] = { type_name = types.Float,     label = "Float3" },
    [0x8c1e1980] = { type_name = types.Float,     label = "Float4" },
    [0x8c1e1984] = { type_name = types.Float,     label = "Float5" },
    [0x8c1e1988] = { type_name = types.Float,     label = "Float6" },
    [0x8c1e198c] = { type_name = types.Float,     label = "Float7" },
    [0x8c1e1990] = { type_name = types.Word,      label = "Word1" },
    [0x8c1e1992] = { type_name = types.Word,      label = "Word2" },
    [0x8c1e1994] = { type_name = types.Float,     label = "Float8" },
    [0x8c1e1998] = { type_name = types.Float,     label = "Float9" },
    [0x8c1e199c] = { type_name = types.Float,     label = "Float10" },
    [0x8c1e19a0] = { type_name = types.Float,     label = "Float11" },
    [0x8c1e19a4] = { type_name = types.Float,     label = "Float12" },
    [0x8c1e19a8] = { type_name = types.Int,       label = "Int1" },
    [0x8c1e19ac] = { type_name = types.Int,       label = "Int2" },
    [0x8c1e19b0] = { type_name = types.Int,       label = "Int3" },
    [0x8c1e19b4] = { type_name = types.Int,       label = "Int4" },
    [0x8c1e19b8] = { type_name = types.Float,     label = "Float13" },
    [0x8c1e19bc] = { type_name = types.Int8,      label = "Byte0" },
    [0x8c1e19bd] = { type_name = types.Int8,      label = "Byte1" },
    [0x8c1e19be] = { type_name = types.Int8,      label = "Byte2" },
    [0x8c1e19bf] = { type_name = types.Int8,      label = "Byte3" },
    [0x8c1e19c0] = { type_name = types.Int8,      label = "SpeedByte1" },
    [0x8c1e19c1] = { type_name = types.Int8,      label = "SpeedByte2" },
    [0x8c1e19c2] = { type_name = types.Int8,      label = "SpeedByte3" },
    [0x8c1e19c3] = { type_name = types.Int8,      label = "Byte1" },
    [0x8c1e19c4] = { type_name = types.Short,     label = "Short7" },
    [0x8c1e19c8] = { type_name = types.String,    label = "PlayerName1" },
    [0x8c1e19cc] = { type_name = types.String,    label = "PlayerName2" },
    [0x8c1e19d0] = { type_name = types.Word,      label = "field1_0x8" },
    [0x8c1e19d2] = { type_name = types.Word,      label = "field2_0xa" },
    [0x8c1e19d4] = { type_name = types.Word,      label = "field3_0xc" },
    [0x8c1e19d6] = { type_name = types.Word,      label = "field4_0xe" },
    [0x8c1e19d8] = { type_name = types.Word,      label = "field5_0x10" },
    [0x8c1e19da] = { type_name = types.Word,      label = "field6_0x12" },
    [0x8c1e19dc] = { type_name = types.Word,      label = "field7_0x14" },
    [0x8c1e19de] = { type_name = types.Short,     label = "HPCurrent" },
    [0x8c1e19e0] = { type_name = types.Short,     label = "EPCurrent" },
    [0x8c1e19e2] = { type_name = types.Short,     label = "HPBase" },
    [0x8c1e19e4] = { type_name = types.Short,     label = "EPBase" },
    [0x8c1e19e6] = { type_name = types.Short,     label = "HPHealRealted" },
    [0x8c1e19e8] = { type_name = types.Short,     label = "EPHealRelated" },
    [0x8c1e19ea] = { type_name = types.Short,     label = "field14_0x22" },
    [0x8c1e19ec] = { type_name = types.Short,     label = "EVP" },
    [0x8c1e19ee] = { type_name = types.Word,      label = "field16_0x26" },
    [0x8c1e19f0] = { type_name = types.Word,      label = "field17_0x28" },
    [0x8c1e19f2] = { type_name = types.Word,      label = "field18_0x2a" },
    [0x8c1e19f4] = { type_name = types.UShort,    label = "AttackBase" },
    [0x8c1e19f6] = { type_name = types.UShort,    label = "EXAttackBase" },
    [0x8c1e19f8] = { type_name = types.UShort,    label = "DefenseBase" },
    [0x8c1e19fa] = { type_name = types.UShort,    label = "IntelligenceBase" },
    [0x8c1e19fc] = { type_name = types.UShort,    label = "HealingBase" },
    [0x8c1e19fe] = { type_name = types.UShort,    label = "DextarityBase" },
    [0x8c1e1a0c] = { type_name = types.DWord,     label = "HeadsUnlocked" },
    [0x8c1e1a10] = { type_name = types.DWord,     label = "ArmsUnlocked" },
    [0x8c1e1a14] = { type_name = types.DWord,     label = "BodiesUnlocked" },
    [0x8c1e1a18] = { type_name = types.DWord,     label = "LegsUnlocked" },
    [0x8c1e1a1c] = { type_name = types.Byte,      label = "field30_0x54" },
    [0x8c1e1a1d] = { type_name = types.Byte,      label = "field31_0x55" },
    [0x8c1e1a1e] = { type_name = types.UShort,    label = "field32_0x56" },
    [0x8c1e1a20] = { type_name = types.Byte,      label = "field33_0x58" },
    [0x8c1e1a21] = { type_name = types.Byte,      label = "field34_0x59" },
    [0x8c1e1a22] = { type_name = types.Byte,      label = "field35_0x5a" },
    [0x8c1e1a23] = { type_name = types.Byte,      label = "field36_0x5b" }
}

function stat_exports.getStatMemoryTable()
    local tbl = {}
    for k, v in pairs(stat_exports.StatLabels) do
        if v.type_name == types.Byte then
            tbl[k] = memory.read8(k)
        elseif v.type_name == types.Word then
            tbl[k] = memory.read16(k)
        elseif v.type_name == types.DWord then
            tbl[k] = memory.read32(k)
        elseif v.type_name == types.Int then
            tbl[k] = memory.read32(k)
        elseif v.type_name == types.Pointer then
            tbl[k] = memory.read32(k)
        elseif v.type_name == types.UShort then
            tbl[k] = memory.read16(k)
        elseif v.type_name == types.Short then
            tbl[k] = memory.read16(k)
        elseif v.type_name == types.Float then
            tbl[k] = memory.read32(k)
        elseif v.type_name == types.String then
            tbl[k] = memory.read32(k)
        elseif v.type_name == types.Int8 then
            tbl[k] = memory.read8(k)
        end
    end
    return tbl
end

return stat_exports
