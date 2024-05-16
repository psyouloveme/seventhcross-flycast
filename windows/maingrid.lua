local maingrid = require "lua.seventhcross.components.maingrid"
local util = require "lua.seventhcross.windows.gridshared"
local logger  = require "lua.seventhcross.components.log"

---@enum MainGridWindowActionType
local actions = {
  Step_Grid_X_Up = 0;
  Step_Grid_Y_Up = 1;
  Step_Grid_X_Down = 2;
  Step_Grid_Y_Down = 3;
  Step_Grid_Precision_Plus = 4;
  Step_Grid_Precision_Minus = 5;
  Update_Main_Grid_Start = 6;
  Update_Main_Grid_End = 7;
  Toggle_Main_Grid_Autoupdate = 8;
};

---@class MainGridWindowReducerAction
---@field type MainGridWindowActionType Reducer action type
---@field payload? any Reducer payload

---@class MainGridWindowState
---@field x integer X coordinate of the displayed 10x10 sub-grid
---@field y integer Y coordinate of the displayed 10x10 sub-grid
---@field precision integer Floating point decimal precision to use for display
---@field grid table|nil Table containing the 10x10 grid
---@field grid_string string|nil String representation of the 10x10 grid for display
---@field changes table|nil Table containing change data determined when updating the grid
---@field changes_string string|nil String representation of the change data for display
---@field loading boolean Internal grid refresh in-progress indicator
---@field autoupdate boolean Enable/disable automatic grid updates
local maingrid_window_state = {
  x = 0;
  y = 0;
  precision = 4;
  loading = false;
  autoupdate = false;
  grid = nil;
  grid_string = nil;
  changes = nil;
  changes_string = nil;
};

---Render count for autoupdate intervals
local render_count = 0

---Reducer for main grid display state
---@param state MainGridWindowState Main grid display state
---@param action MainGridWindowReducerAction Action to execute
---@return MainGridWindowState next_state State after action is applied
local function reducer(state, action)
  local next_state = {}
  for k, v in pairs(state) do
    next_state[k] = v
  end
  if action.type == actions.Step_Grid_X_Down then
    next_state.loading = true
    next_state.x = util.step_view(state.x, 19, -1)
  elseif action.type == actions.Step_Grid_X_Up then
    next_state.loading = true
    next_state.x = util.step_view(state.x, 19, 1)
  elseif action.type == actions.Step_Grid_Y_Down then
    next_state.loading = true
    next_state.y = util.step_view(state.y, 19, -1)
  elseif action.type == actions.Step_Grid_Y_Up then
    next_state.loading = true
    next_state.y = util.step_view(state.y, 19, 1)
  elseif action.type == actions.Step_Grid_Precision_Minus then
    next_state.loading = true
    next_state.precision = util.step_view(state.precision, 9, -1)
  elseif action.type == actions.Step_Grid_Precision_Plus then
    next_state.loading = true
    next_state.precision = util.step_view(state.precision, 9, 1)
  elseif action.type == actions.Update_Main_Grid_Start then
    next_state.loading = true
  elseif action.type == actions.Update_Main_Grid_End then
    next_state.loading = false
    next_state.grid = action.payload
    util.grid_refresh_end(next_state, state)
    print("Main Grid Refresh - End")
  elseif action.type == actions.Toggle_Main_Grid_Autoupdate then
    next_state.autoupdate = not state.autoupdate
  end
  if next_state.loading then
    print("Main Grid Refresh - Start")
  end
  return next_state
end

---Dispatch function for grid window actions
---@param action MainGridWindowReducerAction Action to execute
local function dispatch(action)
  maingrid_window_state = reducer(maingrid_window_state, action)
end

---Refresh the main grid data
---@param mg MainGridWindowState window state
local function refresh_main_grid(mg)
  dispatch({
    type = actions.Update_Main_Grid_End,
    payload = maingrid.sub.read_by_super_coord_transposed(mg.x, mg.y)
  })
end

---Create main grid control window 
---@param state MainGridWindowState current window state
local function build_grid_controls_window(state)
  if not state.loading and state.grid == nil then
    refresh_main_grid(state)
  end
  local ui = flycast.ui
  ui.beginWindow("Move", 1065, 200, 100, 0)
  -- ui.text("Viewing")
  -- ui.text(string.format("(%d,%d)", og_x, og_y))
  ui.button("-x", function()
    if not state.loading then
      dispatch({ type = actions.Step_Grid_X_Down })
      refresh_main_grid(state)
    else
      print("Not changing grid position - loading new grid view")
    end
  end)
  ui.button("+x", function()
    if not state.loading then
      dispatch({ type = actions.Step_Grid_X_Up })
      refresh_main_grid(state)
    else
      print("Not changing grid position - loading new grid view")
    end
  end)
  ui.button("-y", function()
    if not state.loading then
      dispatch({ type = actions.Step_Grid_Y_Down })
      refresh_main_grid(state)
    else
      print("Not changing grid position - loading new grid view")
    end
  end)
  ui.button("+y", function()
    if not state.loading then
      dispatch({ type = actions.Step_Grid_Y_Up })
      refresh_main_grid(state)
    else
      print("Not changing grid position - loading new grid view")
    end
  end)
  ui.button("-1p", function()
    if not state.loading then
      dispatch({ type = actions.Step_Grid_Precision_Minus })
    else
      print("Not changing precision - loading new grid view")
    end
  end)
  ui.button("+1p", function()
    if not state.loading then
      dispatch({ type = actions.Step_Grid_Precision_Plus })
      refresh_main_grid(state)
    else
      print("Not changing precision - loading new grid view")
    end
  end)
  ui.button((state.autoupdate and "O" or "X").." Auto-update", function()
    dispatch({ type = actions.Toggle_Main_Grid_Autoupdate })
  end)
  ui.button("Update", function()
    if not state.loading then
      dispatch({ type = actions.Update_Main_Grid_Start })
      refresh_main_grid(state)
    else
      print("Not refreshing main grid - grid refresh in progress")
    end
  end)
  ui.endWindow()
end

-- Create main grid data viewer
---@param state MainGridWindowState current window state
local function build_grid_viewer(state)
  local ui = flycast.ui
  ui.beginWindow("Grid View", 0, 0, 1060, 0)
  ui.text(string.format("Viewing grid (%d,%d)", state.x, state.y))
  ui.rightText(string.format("Viewing grid (%d,%d)", state.x, state.y))
  ui.text(state.grid_string)
  ui.endWindow()
end

---Build main grid windows
local function build_grid_windows()
  render_count = render_count + 1
  build_grid_controls_window(maingrid_window_state)
  build_grid_viewer(maingrid_window_state)
end

return build_grid_windows