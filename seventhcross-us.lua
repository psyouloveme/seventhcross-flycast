require "string"
local logger                 = require "lua.seventhcross.components.log"
local consts                 = require "lua.seventhcross.constants"
local dump                   = require "lua.seventhcross.components.dump"
local build_calc_window      = require "lua.seventhcross.windows.calc"
local build_dump_window      = require "lua.seventhcross.windows.dump"
local build_evp_window       = require "lua.seventhcross.windows.evp"
local build_maingrid_window  = require "lua.seventhcross.windows.maingrid"
local build_memory_window    = require "lua.seventhcross.windows.memorytable"
local build_scoregrid_window = require "lua.seventhcross.windows.scoregrid"
local build_supergrid_window = require "lua.seventhcross.windows.supergrid"
local build_test_window      = require "lua.seventhcross.windows.tests"
local build_unicode_window   = require "lua.seventhcross.windows.unicodetest"
local build_stat_edit_windows = require "lua.seventhcross.windows.stat_edit"

---do this dumb workaround to get typing for the global
---@type Flycast
_G.flycast = _G.flycast

---@type Flycast.Callbacks
_G.flycast_callbacks = _G.flycast_callbacks

---dump type storage to use in dump window
NEXT_PAUSE_DUMP_TYPE = consts.dump_type.None
-- TARGET_FPS = 30

---Meta UI render counter
-- local ui_render_count = 0;
-- local vblank_count = 0;
-- local frame_count = 0;

---Pause callback
local function cbPause()
  if NEXT_PAUSE_DUMP_TYPE ~= consts.dump_type.None then
    dump.do_gui_dump(NEXT_PAUSE_DUMP_TYPE)
    NEXT_PAUSE_DUMP_TYPE = consts.dump_type.None
    -- this doesn't work
    -- flycast.emulator.resume()
  end
end

---Terminate callback
local function cbTerminate()
  print("Game terminated")
end

---Load state callback
local function cbLoadState()
  print("State loaded")
end



---Resume callback
local function cbResume()
  print("Game resumed")
end

---@class WindowEnabledState
local windows_enabled = {
  calc = false;
  dump = false;
  evp = false;
  maingrid = false;
  memorytable = false;
  scoregrid = false;
  statedit = true;
  supergrid = false;
  tests = false;
  unicodetest = false;
}

---Build a toggle button for a meta window control
---@param name string key into window enabled state
---@param uiname string name to display on the toggle button
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

---Build meta window controls
local function build_window_controls()
  local ui = flycast.ui
  ui.beginWindow("Windows", 1065, 0, 0, 0)
  build_toggle("calc", "Calc")
  build_toggle("dump", "Dump")
  build_toggle("evp", "EVP")
  build_toggle("maingrid", "Main Grid")
  build_toggle("memorytable", "Memory")
  build_toggle("scoregrid", "Score Grid")
  build_toggle("statedit", "Stat edit")
  build_toggle("supergrid", "Super Grid")
  build_toggle("tests", "Tests")
  build_toggle("unicodetest", "Unicode")
  ui.endWindow()
end

---Overlay callback
local function cbOverlay()
  build_window_controls()
  local we = windows_enabled
  if we.calc then
    build_calc_window()
  end
  if we.dump then
    build_dump_window()
  end
  if we.evp then
    build_evp_window()
  end
  if we.maingrid then
    build_maingrid_window()
  end
  if we.memorytable then
    build_memory_window()
  end
  if we.scoregrid then
    build_scoregrid_window()
  end
  if we.supergrid then
    build_supergrid_window()
  end
  if we.tests then
    build_test_window()
  end
  if we.unicodetest then
    build_unicode_window()
  end
  if we.statedit then
    build_stat_edit_windows()
  end
end

---VBlank callback
local function cbVBlank()
  -- if vblank_count % TARGET_FPS == 0 then
  --   frame_count = frame_count + 1
  --   vblank_count = 0;
  -- end
  -- string.format("vblank: buttons1: %08x", flycast.input.getButtons(1))
 print(string.format("vblank: buttons1: %08x", flycast.input.getButtons(1)))
--  print(string.format("vblank: getAxis11: %08x", flycast.input.getAxis(1, 0)))
 print(string.format("vblank: getAxis11: %08x", flycast.input.getAxis(1, 1)))
 print(string.format("vblank: getAxis12: %08x", flycast.input.getAxis(1, 2)))
 print(string.format("vblank: getAxis13: %08x", flycast.input.getAxis(1, 3)))
 print(string.format("vblank: getAxis14: %08x", flycast.input.getAxis(1, 4)))
 print(string.format("vblank: getAxis15: %08x", flycast.input.getAxis(1, 5)))
 print(string.format("vblank: getAxis16: %08x", flycast.input.getAxis(1, 6)))

 print(string.format("vblank: getAxis21: %08x", flycast.input.getAxis(2, 1)))
 print(string.format("vblank: getAxis22: %08x", flycast.input.getAxis(2, 2)))
 print(string.format("vblank: getAxis23: %08x", flycast.input.getAxis(2, 3)))
 print(string.format("vblank: getAxis24: %08x", flycast.input.getAxis(2, 4)))
 print(string.format("vblank: getAxis25: %08x", flycast.input.getAxis(2, 5)))
 print(string.format("vblank: getAxis26: %08x", flycast.input.getAxis(2, 6)))
--  print(string.format("vblank: getAxis21: %08x", flycast.input.getAxis(2, 1)))
--  print(string.format("vblank: getAxis22: %08x", flycast.input.getAxis(2, 2)))
--  print(string.format("vblank: getAxis23: %08x", flycast.input.getAxis(2, 3)))
--  print(string.format("vblank: getAxis24: %08x", flycast.input.getAxis(2, 4)))
--  print(string.format("vblank: getAxis25: %08x", flycast.input.getAxis(2, 5)))
--  print(string.format("vblank: getAxis26: %08x", flycast.input.getAxis(2, 6)))
--  vblank_count = vblank_count + 1;
end

---Start callback
local function cbStart()
  local s = flycast.state
  print("Game started: " .. s.media)
  print("Game Id: " .. s.gameId)
  print("Display: " .. s.display.width .. "x" .. s.display.height)
  -- flycast.emulator.loadState(1)
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

flycast.emulator.startGame("C:\\drop\\flycast\\rom\\Seventh Cross Evolution v1.000 (1999)(UFO)(US)[!]\\Seventh Cross Evolution v1.000 (1999)(UFO)(US)[!].gdi")
print("Game Loaded")