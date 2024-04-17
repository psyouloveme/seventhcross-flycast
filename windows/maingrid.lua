local grid = require "lua.seventhcross.grid"
local exports = {}
local maingrid_coord = { x = 1, y = 1}
local maingrid_matrix_test = nil

-- x coord being set in controls
local og_x = 0
-- y coord being set in controls
local og_y = 0

-- previously rendered x coord
local last_render_og_x = nil
-- previously rendered y coord
local last_render_og_y = nil
-- current rendered x coord
local render_og_x = og_x
-- current rendered y coord
local render_og_y = og_y

-- current rendered grid string
local render_ig_str = nil

local function step_grid_x(direction)
  if direction < 0 then
    if og_x - 1 < 0 then
      og_x = 19
    else 
      og_x = og_x - 1
    end
  elseif direction > 0 then
    if og_x + 1 > 19 then
      og_x = 0
    else
      og_x = og_x + 1
    end
  end
  render_og_x = og_x
end

local function step_grid_y(direction)
  if direction < 0 then
    if og_y - 1 < 0 then
      og_y = 19
    else 
      og_y = og_y - 1
    end
  elseif direction > 0 then
    if og_y + 1 > 19 then
      og_y = 0
    else
      og_y = og_y + 1
    end
  end
  render_og_y = og_y
end


function exports.build_maingrid_window()
    flycast.ui.beginWindow(string.format("Main Grid (%d, %d)", maingrid_coord.x, maingrid_coord.y), 800, 10, 455, 560)
    flycast.ui.endWindow()
end

function exports.build_grid_controls_window()
    local ui = flycast.ui
    ui.beginWindow("Move", 1065, 0, 100, 0)
    -- ui.text("Viewing")
    -- ui.text(string.format("(%d,%d)", og_x, og_y))
    ui.button("-x", function()
      step_grid_x(-1)
    end)
    ui.button("+x", function()
      step_grid_x(1)
    end)
    ui.button("-y", function()
      step_grid_y(-1)
    end)
    ui.button("+y", function()
      step_grid_y(1)
    end)
    ui.button("Update", function()
      last_render_og_x = nil
      last_render_og_y = nil
    end)
    ui.endWindow()
  end

  function exports.build_grid_viewer()
    if ((last_render_og_x ~= render_og_x) or (last_render_og_y ~= render_og_y)) then
      print(string.format("Updating rendered grid to %d %d", og_x, og_y))
      local ig = grid.read_inner_grid(render_og_x, render_og_y)
      render_ig_str = grid.print_grid(ig)
      last_render_og_x = render_og_x
      last_render_og_y = render_og_y
    end
    local ui = flycast.ui
    ui.beginWindow("Grid View", 0, 0, 1060, 0)
    ui.text(string.format("Viewing grid (%d,%d)", render_og_x, render_og_y))
    ui.rightText(string.format("Viewing grid (%d,%d)", render_og_x, render_og_y))
    ui.text(render_ig_str)
    ui.endWindow()
  end

  return exports