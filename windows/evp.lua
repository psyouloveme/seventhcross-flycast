local dump = require "lua.seventhcross.dump"
local supergrid = require "lua.seventhcross.supergrid"
local grid  = require "lua.seventhcross.grid"
local partfind = require "lua.seventhcross.partfind"
local mem = require "lua.seventhcross.memory"
local constants = require "lua.seventhcross.constants"

local evp_curr = 0

local function try_float_print_formats(fl, label)
  if fl == nil then
    print(string.format("%s is nil", label))
  else
    print(string.format("%s: print: ", label), fl)
    print(string.format("%s: tostring: ", label), tostring(fl))
    print(string.format("%s: strf: %f", label, fl))
  end
end


local function try_float_formats(addr, label)
  local m1 = mem.read32(addr)
  local m2 = mem.readFloat32_old(addr)
  local m3 = mem.read32_dumb_str(addr)
  local m4 = mem.read32_dumb_str2(addr)
  local m5 = mem.read32_dumb_str3(addr)
  local m6 = mem.read32_dumb_str4(addr)
  local m6 = mem.readFloat32(addr)

  try_float_print_formats(m1, label.."-1")
  try_float_print_formats(m2, label.."-2")
  try_float_print_formats(m3, label.."-3")
  try_float_print_formats(m4, label.."-4")
  try_float_print_formats(m5, label.."-5")
  try_float_print_formats(m6, label.."-6")
end


local function schedule_dump(dump_type)
  if NEXT_PAUSE_DUMP_TYPE ~= dump_type then
    NEXT_PAUSE_DUMP_TYPE = dump_type
    flycast.emulator.pause()
  end
end

local function build_evp_window()
    local ui = flycast.ui
    local memory = flycast.memory
    ui.beginWindow("Tools", 1065, 270, 100, 0)
  
    -- dumping stuff
    ui.text("Dump")
    ui.button("Player", function()
      schedule_dump(constants.dump_type.Player)
      flycast.emulator.displayNotification("Staring player memory dump", 2000)
    end)
    ui.button("Grid", function()
      schedule_dump(constants.dump_type.MainGrid)
      flycast.emulator.displayNotification("Staring grid memory dump", 2000)
    end)
    ui.button("Memory", function()
      schedule_dump(constants.dump_type.Main)
      flycast.emulator.displayNotification("Staring main memory dump", 2000)
    end)
  
    -- ui.text("Stats")
  
    -- evp_curr = memory.read32(constants.addrs.Evp)
    -- ui.text("EVP: " .. evp_curr)
    -- ui.button("Set 999", function()
    --   memory.write32(constants.addrs.Evp, 999)
    -- end)
  
    -- ui.button("L30 Head", function()
    --   local g = supergrid.read_supergrid()
    --   supergrid.print_grid(g)
    --   -- partfind.do_function_f(grid.PART_TYPE_HEAD, 30, 2)
    --   -- print("trying float formats")
  
    --   -- local ad1 = mem.read8(0x8c0c72b4)
    --   -- local ad2 = mem.read8(0x8c0c72b4+1)
    --   -- print(mem.read32(0x8c0c72b4))
    --   -- print(ad1)
    --   -- print(ad2)
    --   -- flycast.emulator.displayNotification(string.format("read supergrid %d, %d", ad1, ad2), 2500)
    --   -- print(mem.read32(0x8c0c72b4 + 4))
    --   -- grid.do_function_f(grid.PART_TYPE_ARM, 30, 2)
    -- end)
    -- ui.button("L30 Arm", function()
    --   local g = grid.read_inner_grid(0,0)
    --   local grid_str  = grid.print_grid(g)
    --   print(grid_str)
    --   g = grid.read_inner_grid(0,1)
    --   grid_str  = grid.print_grid(g)
    --   print(grid_str)
    --   g = grid.read_inner_grid(1,1)
    --   grid_str  = grid.print_grid(g)
    --   print(grid_str)
  
    --   -- partfind.do_function_f(grid.PART_TYPE_ARM, 30, 2)
    --   -- print("trying float formats")
    --   -- try_float_formats(0x8c3be40c, "f1")
    --   -- try_float_formats(0x8c1e1984, "f2")
    --   -- try_float_formats(0x8c1e1990, "f3")
  
    --   -- local ad1 = mem.read32(0x8c3be40c)
    --   -- local ad2 = mem.readFloat32New(0x8c3be40c)
    --   -- local ad3 = mem.readFloat32New2(0x8c3be40c)
    --   -- local ad4 = mem.read32_rbo(0x8c3be40c)
    --   -- local ad5 = mem.readFloat32(0x8c3be40c)
  
  
    --   -- print("0x8c3be410: 5 print: ", ad5)
    --   -- print(string.format("0x8c3be40c: 5 hex: %f", ad5))
    --   -- -- flycast.emulator.displayNotification(string.format("read grid %f", ad5), 2500)
  
    --   -- local ad6 = mem.readFloat32(0x8c1e1984)
    --   -- print("0x8c1e1984: 5 print: ", ad6)
    --   -- print("0x8c1e1984: 5 tostring: ", tostring(ad6))
    --   -- print(string.format("0x8c1e1984: 5 hex: %f", ad6))
    --   -- flycast.emulator.displayNotification(string.format("read grid %f", ad6), 2500)
  
    --   -- grid.do_function_f(grid.PART_TYPE_ARM, 30, 2)
    -- end)
    -- ui.button("L30 Body", function()
  
    --   partfind.do_function_f(grid.PART_TYPE_BODY, 30, 2)
    --   -- grid.do_function_f(grid.PART_TYPE_BODY, 30, 2)
    -- end)
    -- ui.button("L30 Leg", function()
    --   partfind.do_function_f(grid.PART_TYPE_LEG, 30, 2)
    --   -- grid.do_function_f(grid.PART_TYPE_LEG, 30, 2)
    -- end)
    ui.endWindow()
  end
  
  return build_evp_window