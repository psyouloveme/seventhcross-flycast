require "string"
local dump = require "lua.seventhcross.dump"
local consts = require "lua.seventhcross.constants"
local maingrind_window = require "lua.seventhcross.windows.maingrid"
local build_supergrid_window = require "lua.seventhcross.windows.supergrid"
local build_evp_window = require "lua.seventhcross.windows.evp"
local calc_window = require "lua.seventhcross.windows.calc"

NEXT_PAUSE_DUMP_TYPE = consts.dump_type.None
-- local f = 0

local function cbPause()
  if NEXT_PAUSE_DUMP_TYPE ~= consts.dump_type.None then
    dump.do_gui_dump(NEXT_PAUSE_DUMP_TYPE)
    NEXT_PAUSE_DUMP_TYPE = consts.dump_type.None
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

local function cbResume()
  print("Game resumed")
end

local function cbOverlay()
  -- f = f + 1
  -- build_evp_window()
  -- build_stat_window()
  build_supergrid_window()
  -- maingrind_window.build_grid_controls_window()
  -- maingrind_window.build_grid_viewer()
  calc_window.build_calc_window()
  -- build_supergrid_window()
  -- build_maingrid_window()
  -- build_grid_controls()
  -- build_maingrid_window()
end

local function cbStart()
  local s = flycast.state
  print("Game started: " .. s.media)
  print("Game Id: " .. s.gameId)
  print("Display: " .. s.display.width .. "x" .. s.display.height)
  flycast.emulator.loadState(1)
  -- supergrid_matrix = supergrid.read_supergrid()
  -- maingrid_matrix_test = maingrid.read_inner_grid(maingrid_coord.x, maingrid_coord.y)
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
