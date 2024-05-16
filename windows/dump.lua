local constants = require "lua.seventhcross.constants"

local function schedule_dump(dump_type)
  if NEXT_PAUSE_DUMP_TYPE ~= dump_type then
    NEXT_PAUSE_DUMP_TYPE = dump_type
    flycast.emulator.pause()
  end
end

local function build_dump_window()
  local ui = flycast.ui
  ui.beginWindow("Dump", 1065, 270, 100, 0)
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
  ui.endWindow()
end

return build_dump_window