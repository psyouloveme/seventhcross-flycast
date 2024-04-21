require "string"
local dump = require "lua.seventhcross.dump"
local consts = require "lua.seventhcross.constants"
local maingrind_window = require "lua.seventhcross.windows.maingrid"
local build_supergrid_window = require "lua.seventhcross.windows.supergrid"
local build_evp_window = require "lua.seventhcross.windows.evp"
local calc_window = require "lua.seventhcross.windows.calc"
local build_stat_window = require "lua.seventhcross.windows.stats"

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


local windows_enabled = {
  evp = false,
  stats = false,
  maingrid = true,
  supergrid = true,
  calc = false
}

local function build_toggle(name, uiname)
  local txt
  local we = windows_enabled
  if we[name] ~= nil then
    if we[name] then
      txt = "O "..uiname
    else
      txt = "X "..uiname
    end
    flycast.ui.button(txt, function()
      we[name] = not we[name]
    end)
  end
end

local function build_window_controls()
  local ui = flycast.ui
  local txt = ""
  ui.beginWindow("Windows", 1065, 0, 0, 0)
  build_toggle("evp", "EVP")
  build_toggle("stats", "Stats")
  build_toggle("maingrid", "Maingrid")
  build_toggle("supergrid", "Supergrid")
  build_toggle("calc", "Calc")
  ui.endWindow()
end

local function cbOverlay()
  build_window_controls()
  if windows_enabled.evp then
    build_evp_window()
  end
  if windows_enabled.stats then
    build_stat_window()
  end
  if windows_enabled.maingrid then
    maingrind_window.build_grid_viewer()
    maingrind_window.build_grid_controls_window()
  end
  if windows_enabled.supergrid then
      build_supergrid_window()
  end
  if windows_enabled.calc then
    calc_window.build_calc_window()
  end
  -- f = f + 1
  -- build_evp_window()
  -- build_stat_window()
  -- build_supergrid_window()
  -- maingrind_window.build_grid_controls_window()
  -- maingrind_window.build_grid_viewer()
  -- calc_window.build_calc_window()
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
