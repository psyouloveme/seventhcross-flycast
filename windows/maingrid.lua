

local maingrid_coord = { x = 1, y = 1}
local maingrid_matrix_test = nil


local og_x = 0
local og_y = 0
local ig_str = 0

local function step_grid_x(direction)
  if direction < 0 then
    if og_x - 1 < 0 then
      og_x = 9
    else 
      og_x = og_x - 1
    end
  elseif direction > 0 then
    if og_x + 1 > 9 then
      og_x = 0
    else
      og_x = og_x + 1
    end
  end
end

local function step_grid_y(direction)
  if direction < 0 then
    if og_x - 1 < 0 then
      og_x = 9
    else 
      og_x = og_x - 1
    end
  elseif direction > 0 then
    if og_x + 1 > 9 then
      og_x = 0
    else
      og_x = og_x + 1
    end
  end
end


local function build_maingrid_window()
    flycast.ui.beginWindow(string.format("Main Grid (%d, %d)", maingrid_coord.x, maingrid_coord.y), 800, 10, 455, 560)
    flycast.ui.endWindow()
end

local function build_grid_controls_window()
    local ui = flycast.ui
    ui.beginWindow("Grid View", 10, 10, 600, 600)
    ui.text("Viewing")
    ui.text(string.format("(%d,%d)", og_x, og_y))
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
    ui.endWindow()
  end

  local function build_grid_viewer()
    local ui = flycast.ui
    ui.beginWindow("Grid View", 10, 10, 600, 600)
    ui.text(string.format("Viewing grid (%d,%d)", og_x, og_y))
  
    ui.endWindow()
  end

  return {
    build_grid_viewer,
    build_grid_controls_window,
    build_maingrid_window
  }