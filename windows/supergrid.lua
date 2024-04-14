local supergrid = require "lua.seventhcross.supergrid"

-- local supergrid_matrix = nil
local supergrid_str = nil

local function build_supergrid_window()
  if supergrid_str == nil then
    print("refreshing supergrid")
    local supergrid_matrix = supergrid.read_supergrid()
    local supergrid_header = ""
    supergrid_str = supergrid.print_grid(supergrid_matrix)
    for c = 0, #supergrid_matrix, 1 do
      supergrid_header = supergrid_header..string.format("%02d", c).." "
    end
    supergrid_header = supergrid_header.."\n\n"
    supergrid_str = supergrid_header..supergrid_str
  end
  local ui = flycast.ui
  ui.beginWindow("Super Grid", 10, 332, 430, 415)
  -- local g = supergrid.read_supergrid()
  -- local cl = "       "
  -- for c = 0, #supergrid_matrix, 1 do
  --   cl = string.format("%s %02d", cl, c)
  -- end
  -- ui.text(cl)
  -- for r = 0, #supergrid_matrix, 1 do
  --   local rs = string.format("%02d | %s", r, supergrid.row_to_string(supergrid_matrix, r))
  --   ui.text(rs)
  -- end
  -- local sgstr = supergrid.print_grid(supergrid_matrix)
  -- ui.text(supergrid_header)
  ui.text(supergrid_str)
  -- ui.text(sgstr)
  ui.endWindow()
end

return build_supergrid_window