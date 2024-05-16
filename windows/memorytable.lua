local stats = require "lua.seventhcross.components.stats"
local consts = require("lua.seventhcross.constants")

local stats_current = nil
local types = consts.types

local function build_memory_window()
  stats_current = stats.getStatMemoryTable()
  local ui = flycast.ui
  ui.beginWindow("Memory", 10, 32, 400, 630)
  if stats_current ~= nil then
    local a = {}
    for n in pairs(stats_current) do table.insert(a, n) end
    table.sort(a)
    for i, k in ipairs(a) do
      local v = stats_current[k]
      local mapped = nil
      local uistr = nil
      local uiraw = nil
      local uilabel = nil
      mapped = stats.StatLabels[k]
      if mapped == nil then
        uilabel = string.format("0x%x")
        uistr = string.format("0x%x", k, v)
        uiraw = string.format("0x%08x", v)
      elseif mapped.type_name == types.Byte then
        uilabel = mapped.label
        uistr = string.format("0x%02x", v)
        uiraw = string.format("0x%02x", v)
      elseif mapped.type_name == types.Pointer then
        uilabel = mapped.label
        uistr = string.format("0x%08x", v)
        uiraw = string.format("0x%08x", v)
      elseif mapped.type_name == types.UShort then
        uilabel = mapped.label
        -- local converted = string.unpack("i", string.format("%04x", v))
        uistr = string.format("%i", v)
        uiraw = string.format("0x%04x", v)
      elseif mapped.type_name == types.Short then
        uilabel = mapped.label
        uistr = string.format("%d", v)
        uiraw = string.format("0x%04x", v)
      elseif mapped.type_name == types.Int8 then
        uilabel = mapped.label
        uistr = string.format("%d", v)
        uiraw = string.format("0x%02x", v)
      elseif mapped.type_name == types.Int then
        uilabel = mapped.label
        uistr = string.format("%i", v)
        uiraw = string.format("0x%08x", v)
      elseif mapped.type_name == types.Word then
        uilabel = mapped.label
        uistr = string.format("0x%04x", v)
        uiraw = string.format("0x%04x", v)
      elseif mapped.type_name == types.DWord then
        uilabel = mapped.label
        uistr = string.format("0x%08x", v)
        uiraw = string.format("0x%08x", v)
      elseif mapped.type_name ==  types.Float then
        -- local temp_table = {}
        -- local final_string = ""
        -- for byte_str in string.gmatch(temp_hex_string, "[a-zA-Z0-9][a-zA-Z0-9]") do
        --   table.insert(temp_table, byte_str) end
        -- table.sort(temp_table, function(lef, rig) return lef < rig end)
        -- final_string = table.concat(temp_table)
        -- local final_value = string.unpack("f", final_string)
        uilabel = mapped.label
        -- local converted_float = mem.util.fix_mem_float(v)
        -- if converted_float ~= 0 then
        -- local ss = string.pack("i4",v)
        -- local ff = string.unpack("f",ss)
        local fixed_val = string.unpack("f", string.pack("i4", v))
        uistr = tostring(fixed_val)
          -- uistr = string.format("%f",converted_float)
        uiraw = string.format("0x%04x", v)
          -- string.format("0x%s", string.pack("i4", v))
          -- print(uiraw)
        -- else
        --   uistr = string.format("%f",0.0)
        --   uiraw = string.format("0x%04x", 0.0)
        -- end
      elseif mapped.type_name ==  types.String then
        local st = string.format("%x",v)        
        -- https://stackoverflow.com/a/65477617
        st = st:gsub("%x%x", function(digit) return string.char(tonumber(digit, 16)) end)
        uilabel = mapped.label
        uistr = string.format("%s", st)
        uiraw = string.format("0x%08x", v)
      end
      ui.text(uilabel)
      -- ui.text(string.format("%-30s %16s", uilabel, uistr))
      -- ui.rightText(uistr..string.format("%16s", uiraw))
      ui.rightText(uistr)
      -- ui.rightText(string.format("%16s", uiraw))
    end
  else
    ui.text("Memory didn't load.")
  end
  ui.endWindow()
end

return build_memory_window