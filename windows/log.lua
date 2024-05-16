local logger = require "lua.seventhcross.components.log"

local function build_log_window()
  flycast.ui.beginWindow("Log", 0, 0, 400, 300)
  local log = logger.get()
  for i, v in ipairs(log) do
    flycast.ui.text(v)
  end
  flycast.ui.endWindow()
end

return build_log_window