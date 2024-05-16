local partfind = require "lua.seventhcross.components.partfind"
local constants = require "lua.seventhcross.constants"
local grid = require "lua.seventhcross.components.maingrid"
local calcc = require "lua.seventhcross.components.calculator3"


local exports = {}

local function assert_coords(x1, y1, x2, y2, index, offset)
  local i1 = grid.outer_grid.coord_to_index(x1, y1, x2, y2)
  local o1 = grid.outer_grid.coord_to_offset(x1, y1, x2, y2)
  local c1 = grid.outer_grid.index_to_coord(i1)
  local o2 = grid.outer_grid.index_to_offset(i1)
  local c2 = grid.outer_grid.offset_to_coord(o1)
  local i2 = grid.outer_grid.offset_to_index(o1)

  local st = string.format("Coord Test (%d, %d, %d, %d):\n", x1, y1, x2, y2)
  st = st..string.format("  Index:  %d\n", i1)
  st = st..string.format("  Offset: 0x%08x (0x%08x)\n", o1, o1 + constants.addrs.MainGrid)
  st = st..string.format("  Remapped Index to Coord:  (%d, %d, %d, %d)\n", c1.x1, c1.y1, c1.x2, c1.y2)
  st = st..string.format("  Remapped Index to Offset: 0x%08x (0x%08x)\n", o2, o2 + constants.addrs.MainGrid)
  st = st..string.format("  Remapped Offset to Coord: (%d, %d, %d, %d)\n", c2.x1, c2.y1, c2.x2, c2.y2)
  st = st..string.format("  Remapped Offset to Index: %d", i2)
  print(st)
  assert(i1    == index , string.format("! coord_to_index failed - %d ~= %d",      i1   , index ))
  assert(o1    == offset, string.format("! coord_to_offset failed - %d ~= %d",     o1   , offset))
  assert(c1.x1 == x1    , string.format("! index_to_coord x1 failed - %d ~= %d",   c1.x1, x1    ))
  assert(c1.y1 == y1    , string.format("! index_to_coord y1 failed - %d ~= %d",   c1.y1, y1    ))
  assert(c1.x2 == x2    , string.format("! index_to_coord x2 failed - %d ~= %d",   c1.x2, x2    ))
  assert(c1.y2 == y2    , string.format("! index_to_coord y2 failed - %d ~= %d",   c1.y2, y2    ))
  assert(o2    == offset, string.format("! index_to_offset failed - %d ~= %d",     o2   , offset))
  assert(c2.x1 == x1    , string.format("! offset_to_coord x1 failed - %d ~= %d",  c2.x1, x1    ))
  assert(c2.y1 == y1    , string.format("! offset_to_coord y1 failed - %d ~= %d",  c2.y1, y1    ))
  assert(c2.x2 == x2    , string.format("! offset_to_coord x2 failed - %d ~= %d",  c2.x2, x2    ))
  assert(c2.y2 == y2    , string.format("! offset_to_coord y2 failed - %d ~= %d",  c2.y2, y2    ))
  assert(i2    == index , string.format("! offset_to_index failed - %d ~= %d",     i2   , index ))
end


local function test_coords(x1, y1, x2, y2)
  local i1 = grid.outer_grid.coord_to_index(x1, y1, x2, y2)
  local o1 = grid.outer_grid.coord_to_offset(x1, y1, x2, y2)
  local c1 = grid.outer_grid.index_to_coord(i1)
  local o2 = grid.outer_grid.index_to_offset(i1)
  local c2 = grid.outer_grid.offset_to_coord(o1)
  local i2 = grid.outer_grid.offset_to_index(o1)

  local st = string.format("Coord Test (%d, %d, %d, %d):\n", x1, y1, x2, y2)
  st = st..string.format("  Index:  %d\n", i1)
  st = st..string.format("  Offset: 0x%08x (0x%08x)\n", o1, o1 + constants.addrs.MainGrid)
  st = st..string.format("  Remapped Index to Coord:  (%d, %d, %d, %d)\n", c1.x1, c1.y1, c1.x2, c1.y2)
  st = st..string.format("  Remapped Index to Offset: 0x%08x (0x%08x)\n", o2, o2 + constants.addrs.MainGrid)
  st = st..string.format("  Remapped Offset to Coord: (%d, %d, %d, %d)\n", c2.x1, c2.y1, c2.x2, c2.y2)
  st = st..string.format("  Remapped Offset to Index: %d", i2)
  -- print(st)
end



local function build_calc_window()
    local ui = flycast.ui
    local memory = flycast.memory
    ui.beginWindow("Calc", 960, 270, 100, 0)
    ui.button("L30 Body", function()
      -- math.randomseed(os.time())
      -- for g = 0, 10 do
      --   local x1 = math.random(0,19)
      --   local y1 = math.random(0,19)
      --   local x2 = math.random(0,9)
      --   local y2 = math.random(0,9)
      --   test_coords(x1, y1, x2, y2)
      -- end
      -- test_coords(0,14,7,5)
      -- assert_coords(7,75,1475,0x8c3bfb18)
      -- local x = math.random(0,grid.width)
      -- local y = math.random(0,grid.height)
      -- local index = math.random(0,(grid.width * grid.height) - 1)
      -- local offset = math.random(grid.start_address, grid.start_address + ((grid.height * grid.width) * grid.value_size))
      print("Start coordinate test")
      -- print(grid.tests.test_coords(75,7,1475,0x8c3bfb18))
      -- print(grid.tests.test_coords(151,73,14751,0x8c3cca88))
      -- print(grid.run_conversions(x,y,index,offset))
      -- print(grid.tests.run_conversions(75,7,1475,0x8c3bfb18))
      -- print(grid.tests.run_conversions(75,7,1475,0x8c3bfb18))
      -- print(grid.tests.run_conversions(75,7,1475,0x8c3bfb18))
      -- print(grid.tests.run_conversions(nil,nil,17170,nil))
      -- print(grid.tests.run_conversions(nil,nil,17172,nil))


      print("**************************")
      -- print(grid.tests.run_conversions(0,0,0,0x8c3be40c))
      -- print(grid.tests.run_conversions(0,1,1,0x8c3be410))
      -- print(grid.tests.run_conversions(1,0,10,0x8c3bfb18))
      -- print(grid.tests.run_conversions(9,9,99,0x8c3be598))
      -- print(grid.tests.run_conversions(9,8,98,0x8c3be594))
      -- print(grid.tests.run_conversions(8,9,89,0x8c3be570))
      print("**************************")
      -- print(grid.tests.run_conversions(75,7,1475,0x8c3bfb18))
      -- print(grid.tests.run_conversions(75,7,1475,0x8c3bfb18))
      -- print(grid.tests.run_conversions(75,7,1475,0x8c3bfb18))
      -- print(grid.tests.run_conversions(75,7,1475,0x8c3bfb18))

      -- print(grid.tests.test_coords(172,85,17172,0x8c3cf05c))
      -- local r = math.random(0,9)
      -- partfind.do_function_f(constants.parts.BODY, 30, 2)
      -- grid.do_function_f(constants.parts.BODY, 30, 2)
      print("End coordinate test")
    end)
    ui.button("L30 Leg", function()
      partfind.do_function_f(constants.parts.LEG, 30, 2)
      grid.do_function_f(constants.parts.LEG, 30, 2)
    end)
    ui.button("L30 Leg", function()
      calcc.find_part(constants.parts.LEG, 30, 5)
    end)
    ui.button("L30 Body", function()
      calcc.find_part(constants.parts.BODY, 30, 5)
    end)
    ui.button("L30 Arm", function()
      calcc.find_part(constants.parts.ARM, 30, 5)
    end)
    ui.button("L30 Head", function()
      calcc.find_part(constants.parts.HEAD, 30, 5)
    end)
    ui.endWindow()
end

return build_calc_window