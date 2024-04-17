local supergrid = require "lua.seventhcross.supergrid"
local constants = require "lua.seventhcross.constants"
local supergrid_str = nil
local supergrid_matrix = nil
local part_grids = {
  head = nil,
  arm = nil,
  body = nil,
  leg = nil
}
function part_grids.get(part_type)
  if part_type == constants.parts.HEAD then return part_grids.head end
  if part_type == constants.parts.ARM then return part_grids.arm end
  if part_type == constants.parts.BODY then return part_grids.body end
  if part_type == constants.parts.LEG then return part_grids.leg end
  return nil
end

function part_grids.set(part_type, grid)
  if part_type == constants.parts.HEAD then part_grids.head = grid end
  if part_type == constants.parts.ARM then part_grids.arm = grid end
  if part_type == constants.parts.BODY then part_grids.body = grid end
  if part_type == constants.parts.LEG then part_grids.leg = grid end
end

local part_grid_x_offset = 350
local part_grid_y_offset = 260
function part_grids.get_window_pos(part_type)
  if part_type == constants.parts.HEAD then return { x = 0, y = 0} end
  if part_type == constants.parts.BODY then return { x = part_grid_x_offset, y = 0} end
  if part_type == constants.parts.ARM then return { x = 0, y = part_grid_y_offset} end
  if part_type == constants.parts.LEG then return { x = part_grid_x_offset, y = part_grid_y_offset} end
  return nil
end

local function build_quadrant_window(part_type)
  if part_grids.get(part_type) == nil then
    print("buiding", constants.get_part_string(part_type))
    local grid = supergrid.read_part_quadrant(part_type, true)
    part_grids.set(part_type, supergrid.print_grid(grid))
  end
  local ui = flycast.ui
  local pos = part_grids.get_window_pos(part_type)
  if pos ~= nil then
    ui.beginWindow(constants.get_part_string(part_type), pos.x, pos.y, 0, 0)
    ui.text(part_grids.get(part_type))
    ui.endWindow()
  end
end

local function build_supergrid_window()
  -- if supergrid_matrix == nil then
    -- print("refreshing supergrid")
    -- supergrid_matrix = supergrid.read_supergrid()
    -- supergrid_str = supergrid.print_grid(supergrid_matrix)
  -- end
  -- local ui = flycast.ui
  -- ui.beginWindow("Super Grid", 0, 265, 0, 0)
  -- ui.text(supergrid_str)
  -- ui.endWindow()
  build_quadrant_window(constants.parts.HEAD)
  build_quadrant_window(constants.parts.ARM)
  build_quadrant_window(constants.parts.BODY)
  build_quadrant_window(constants.parts.LEG)
end



return build_supergrid_window