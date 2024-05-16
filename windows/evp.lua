local constants = require "lua.seventhcross.constants"

local evp_curr = 0

local function build_evp_window()
  local ui = flycast.ui
  local memory = flycast.memory
  ui.beginWindow("Tools", 1065, 270, 100, 0)
  ui.text("Stats")
  evp_curr = memory.read32(constants.addrs.Evp)
  ui.text("EVP: " .. evp_curr)
  ui.button("Set 999", function()
    memory.write32(constants.addrs.Evp, 999)
  end)
  ui.endWindow()
end

return build_evp_window