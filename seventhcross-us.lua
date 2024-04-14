require "string"
local dump = require "lua.seventhcross.dump"
local stats = require "lua.seventhcross.stats"
local grid  = require "lua.seventhcross.grid"
local mem = require "lua.seventhcross.memory"

ADDR_MAIN_MEMORY_START   = 0x8c1b1744
ADDR_PLAYER_STRUCT_START = 0x8c000000
ADDR_EVP                 = 0x8c1e19ec
ADDR_PLAYER_STRUCT_END   = 0x8c010000
ADDR_MAIN_MEMORY_END     = 0x8d000000

local next_pause_dump_type = dump.DUMP_TYPE_NONE
local f = 0
local evp_curr
local stats_current = nil

local function schedule_dump(dump_type)
  if next_pause_dump_type ~= dump_type then
    next_pause_dump_type = dump_type
    flycast.emulator.pause()
  end
end

local function cbPause()
  if next_pause_dump_type ~= dump.DUMP_TYPE_NONE then
    dump.do_gui_dump(next_pause_dump_type)
    next_pause_dump_type = dump.DUMP_TYPE_NONE
    -- this doesn't work
    -- flycast.emulator.resume()
  end
end


local function cbTerminate()
  print("Game terminated")
end

local function cbLoadState()
  print("State loaded")
end

local function cbVBlank()
--  print("vblank x,y=", flycast.input.getAbsCoordinates(1))
end







local function build_evp_window()
  local ui = flycast.ui
  local memory = flycast.memory
  ui.beginWindow("Tools", 10, 10, 150, 0)

  -- dumping stuff
  ui.text("Memory Dumps")
  ui.button("Player", function()
    schedule_dump(dump.DUMP_TYPE_PLAYER)
    flycast.emulator.displayNotification("Staring data memory dump", 2000)
  end)
  ui.button("Main Memory", function() 
    schedule_dump(dump.DUMP_TYPE_MAIN)
    flycast.emulator.displayNotification("Staring main memory dump", 2000)
  end)

  ui.text("Stats")

  evp_curr = memory.read32(ADDR_EVP)
  ui.text("EVP: " .. evp_curr)
  ui.button("Set 999", function()
    memory.write32(ADDR_EVP, 999)
  end)

  ui.button("Search L30 Head", function()
    local ad1 = mem.read8(0x8c0c72b4)
    local ad2 = mem.read8(0x8c0c72b4+1)
    -- print(mem.read32(0x8c0c72b4))
    print(ad1)
    print(ad2)
    flycast.emulator.displayNotification(string.format("read supergrid %d, %d", ad1, ad2), 2500)
    -- print(mem.read32(0x8c0c72b4 + 4))
    -- grid.do_function_f(grid.PART_TYPE_ARM, 30, 2)
  end)
  ui.button("Search L30 Arm", function()
    -- local ad1 = mem.read32(0x8c3be40c)
    -- local ad2 = mem.readFloat32New(0x8c3be40c)
    -- local ad3 = mem.readFloat32New2(0x8c3be40c)
    -- local ad4 = mem.read32_rbo(0x8c3be40c)
    local ad5 = mem.readFloat32(0x8c3be40c)
    print("0x8c3be410: 5 print: ", ad5)
    print(string.format("0x8c3be40c: 5 hex: %f", ad5))
    flycast.emulator.displayNotification(string.format("read grid %f", ad5), 2500)
    -- grid.do_function_f(grid.PART_TYPE_ARM, 30, 2)
  end)
  ui.button("Search L30 Body", function()
    -- grid.do_function_f(grid.PART_TYPE_ARM, 30, 2)
  end)
  ui.button("Search L30 Leg", function()
    -- grid.do_function_f(grid.PART_TYPE_ARM, 30, 2)
  end)
  ui.endWindow()
end


local function build_stat_window()
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
      elseif mapped.type_name == stats.TYPE_BYTE then
        uilabel = mapped.label
        uistr = string.format("0x%02x", v)
        uiraw = string.format("0x%02x", v)
      elseif mapped.type_name == stats.TYPE_POINTER then
        uilabel = mapped.label
        uistr = string.format("0x%08x", v)
        uiraw = string.format("0x%08x", v)
      elseif mapped.type_name == stats.TYPE_USHORT then
        uilabel = mapped.label
        -- local converted = string.unpack("i", string.format("%04x", v))
        uistr = string.format("%i", v)
        uiraw = string.format("0x%04x", v)
      elseif mapped.type_name == stats.TYPE_SHORT then
        uilabel = mapped.label
        uistr = string.format("%d", v)
        uiraw = string.format("0x%04x", v)
      elseif mapped.type_name == stats.TYPE_INT8 then
        uilabel = mapped.label
        uistr = string.format("%d", v)
        uiraw = string.format("0x%02x", v)
      elseif mapped.type_name == stats.TYPE_INT then
        uilabel = mapped.label
        uistr = string.format("%i", v)
        uiraw = string.format("0x%08x", v)
      elseif mapped.type_name == stats.TYPE_WORD then
        uilabel = mapped.label
        uistr = string.format("0x%04x", v)
        uiraw = string.format("0x%04x", v)
      elseif mapped.type_name == stats.TYPE_DWORD then
        uilabel = mapped.label
        uistr = string.format("0x%08x", v)
        uiraw = string.format("0x%08x", v)
      elseif mapped.type_name ==  stats.TYPE_FLOAT then
        -- local temp_table = {}
        -- local final_string = ""
        -- for byte_str in string.gmatch(temp_hex_string, "[a-zA-Z0-9][a-zA-Z0-9]") do
        --   table.insert(temp_table, byte_str) end
        -- table.sort(temp_table, function(lef, rig) return lef < rig end)
        -- final_string = table.concat(temp_table)
        -- local final_value = string.unpack("f", final_string)
        uilabel = mapped.label
        if v > 0 then
          uistr = string.format("%f", v)
          uiraw = tostring(v)
        else
          uistr = string.format("%f", v)
          uiraw = tostring(0.0)
        end
      elseif mapped.type_name ==  stats.TYPE_STRING then
        local st = string.format("%x",v)        
        -- https://stackoverflow.com/a/65477617
        st = st:gsub("%x%x", function(digit) return string.char(tonumber(digit, 16)) end)
        uilabel = mapped.label
        uistr = string.format("%s", st)
        uiraw = string.format("0x%08x", v)
      end
      ui.text(uilabel)
      ui.rightText(uistr..string.format("%16s", uiraw))
    end
  else
    ui.text("Memory didn't load.")
  end
  ui.endWindow()
end


local function cbOverlay()
  f = f + 1
  build_evp_window()
  build_stat_window()
end

local function cbStart()
  local s = flycast.state
  print("Game started: " .. s.media)
  print("Game Id: " .. s.gameId)
  print("Display: " .. s.display.width .. "x" .. s.display.height)
  flycast.emulator.loadState(1)
end

flycast_callbacks = {
  start = cbStart,
  pause = cbPause,
  resume = cbResume,
  terminate = cbTerminate,
  loadState = cbLoadState,
  vblank = cbVBlank,
  overlay = cbOverlay
}

print("Callbacks set")
flycast.emulator.startGame("C:\\drop\\flycast\\rom\\Seventh Cross Evolution v1.000 (1999)(UFO)(US)[!]\\Seventh Cross Evolution v1.000 (1999)(UFO)(US)[!].gdi")
