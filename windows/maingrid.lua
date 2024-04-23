local maingrid = require "lua.seventhcross.maingrid"
local exports = {}

local actions = {
  Step_Grid_X_Up = 0;
  Step_Grid_Y_Up = 1;
  Step_Grid_X_Down = 2;
  Step_Grid_Y_Down = 3;
  Step_Grid_Precision_Plus = 4;
  Step_Grid_Precision_Minus = 5;
  Update_Main_Grid_Start = 6;
  Update_Main_Grid_End = 7;
  MAIN_GRID_END = 8;
  Step_Score_Precision_Up = 8;
  Step_Score_Precision_Down = 9;
  Update_Score_Grid_Start = 10;
  Update_Score_Grid_End = 11;
  SCORE_GRID_END = 12;
};

Grid_Window_State = {
  main_grid = {
      x = 0;
      y = 0;
      grid = nil;
      grid_string = nil;
      precision = 4;
      changes = nil;
      changes_string = nil;
      loading = false;
  };
  score_grid = {
      grid = nil;
      grid_string = nil;
      changes = nil;
      changes_string = nil;
      precision = 4;
      loading = false;
  };
};

---Step function with bound, wrapping on both ends
---@param current integer the current position
---@param max integer the maximum position
---@param direction integer direction to step
---@return integer next the next position
local function step_view(current, max, direction)
  local c = current
  if direction < 0 then
    if c - 1 < 0 then
      c = max
    else 
      c = c - 1
    end
  elseif direction > 0 then
    if c + 1 > max then
      c = 0
    else
      c = c + 1
    end
  end
  return c
end

---Process changes object to a string
---@param changes table Array of change data
---@param precision integer Floating point precision to display
---@return string changes_string String of changed data for display
local function changes_to_string(changes, precision)
  local s = ""
  local fmt = "%0."..tostring(precision).."f"
  if #changes > 0 then
    for r = 0, #changes - 1, 1 do
      local value = changes[r]
      if value ~= nil then
        s = s..string.format("(%d, %d) "..fmt.." -> "..fmt.."\n", value.x, value.y, value.a, value.b)
      end
    end
  end
  return s
end

---Create string representation of grid and calculate changes
---@param next_state { grid: table, grid_string: string, changes: table, changes_string: string } Grid window state to update
---@param prev_state { grid: table, grid_string: string, changes: table, changes_string: string, precision: integer } Previous grid window state
local function grid_refresh_end(next_state, prev_state)
  local tspc = maingrid.to_string_p_comp(next_state.grid, prev_state.grid, prev_state.precision);
  next_state.grid_string = tspc.grid_string
  next_state.changes = tspc.changes
  next_state.changes_string = changes_to_string(tspc.changes, prev_state.precision)
end

---Reducer for main grid display state
---@param state { x: integer, y: integer, precision: integer, grid: table, grid_string: string, changes: table, changes_string: string } Main grid display state
---@param action { type: integer, payload: table } Action to execute
---@return { x: integer, y: integer, precision: integer, grid: table, grid_string: string, changes: table, changes_string: string } next_state State after action is applied
local function main_grid_reducer(state, action)
  local next_state = {}
  for k, v in pairs(state) do
    next_state[k] = v
  end
  if action.type == actions.Step_Grid_X_Down then
    next_state.loading = true
    next_state.x = step_view(state.x, 19, -1)
  elseif action.type == actions.Step_Grid_X_Up then
    next_state.loading = true
    next_state.x = step_view(state.x, 19, 1)
  elseif action.type == actions.Step_Grid_Y_Down then
    next_state.loading = true
    next_state.y = step_view(state.y, 19, -1)
  elseif action.type == actions.Step_Grid_Y_Up then
    next_state.loading = true
    next_state.y = step_view(state.y, 19, 1)
  elseif action.type == actions.Step_Grid_Precision_Minus then
    next_state.loading = true
    next_state.precision = step_view(state.precision, 9, -1)
  elseif action.type == actions.Step_Grid_Precision_Plus then
    next_state.loading = true
    next_state.precision = step_view(state.precision, 9, 1)
  elseif action.type == actions.Update_Main_Grid_Start then
    next_state.loading = true
  elseif action.type == actions.Update_Main_Grid_End then
    next_state.loading = false
    next_state.grid = action.payload
    grid_refresh_end(next_state, state)
    print("Main Grid Refresh - End")
  end
  if next_state.loading then
    print("Main Grid Refresh - Start")
  end
  return next_state
end

---Reducer for score grid display state
---@param state { x: integer, y: integer, precision: integer, grid: table, grid_string: string, changes: table, changes_string: string } Score grid display state
---@param action { type: integer, payload: table } Action to execute
---@return { x: integer, y: integer, precision: integer, grid: table, grid_string: string, changes: table, changes_string: string } next_state State after action is applied
local function score_grid_reducer(state, action)
  local next_state = {}
  for k, v in pairs(state) do
    next_state[k] = v
  end
  if action.type == actions.Step_Score_Precision_Down then
    next_state.loading = true
    next_state.precision = step_view(state.precision, 9, -1)
  elseif action.type == actions.Step_Score_Precision_Up then
    next_state.loading = true
    next_state.precision = step_view(state.precision, 9, 1)
  elseif action.type == actions.Update_Score_Grid_Start then
    next_state.loading = true
  elseif action.type == actions.Update_Score_Grid_End then
    next_state.loading = false
    next_state.grid = action.payload
    grid_refresh_end(next_state, state)
    print("Score Grid Refresh - End")
  end
  if next_state.loading then
    print("Score Grid Refresh - Start")
  end
  return next_state
end

---Reducer for all maingrid window state actions. 
---@param state table Current window state
---@param action { type: integer, payload: table } Action to execute
---@return table next_state State after action is applied
local function reducer(state, action)
  local next_state = {}
  for k, v in pairs(state) do
    next_state[k] = v
  end
  if action.type < actions.MAIN_GRID_END then
    next_state.main_grid = main_grid_reducer(state.main_grid, action)
  else
    next_state.score_grid = score_grid_reducer(state.score_grid, action)
  end
  return next_state
end

---Dispatch function for grid window actions
---@param action { type: integer, payload: table } Action to execute
local function dispatch(action)
  Grid_Window_State = reducer(Grid_Window_State, action)
end

local function refresh_main_grid(mg)
  dispatch({
    type = actions.Update_Main_Grid_End,
    payload = maingrid.sub.read_by_super_coord_transposed(mg.x, mg.y)
  })
end

---Create main grid control window 
---@param state table current window state
local function build_grid_controls_window(state)
  local mg = state.main_grid
  if not mg.loading and mg.grid == nil then
    refresh_main_grid(mg)
  end
  local ui = flycast.ui
  ui.beginWindow("Move", 1065, 200, 100, 0)
  -- ui.text("Viewing")
  -- ui.text(string.format("(%d,%d)", og_x, og_y))
  ui.button("-x", function()
    if not mg.loading then
      dispatch({ type = actions.Step_Grid_X_Down })
      refresh_main_grid(mg)
    else
      print("Not changing grid position - loading new grid view")
    end
  end)
  ui.button("+x", function()
    if not mg.loading then
      dispatch({ type = actions.Step_Grid_X_Up })
      refresh_main_grid(mg)
    else
      print("Not changing grid position - loading new grid view")
    end
  end)
  ui.button("-y", function()
    if not mg.loading then
      dispatch({ type = actions.Step_Grid_Y_Down })
      refresh_main_grid(mg)
    else
      print("Not changing grid position - loading new grid view")
    end
  end)
  ui.button("+y", function()
    if not mg.loading then
      dispatch({ type = actions.Step_Grid_Y_Up })
      refresh_main_grid(mg)
    else
      print("Not changing grid position - loading new grid view")
    end
  end)
  ui.button("-1p", function()
    if not mg.loading then
      dispatch({ type = actions.Step_Grid_Precision_Minus })
    else
      print("Not changing precision - loading new grid view")
    end
  end)
  ui.button("+1p", function()
    if not mg.loading then
      dispatch({ type = actions.Step_Grid_Precision_Plus })
      refresh_main_grid(mg)
    else
      print("Not changing precision - loading new grid view")
    end
  end)
  ui.button("Update", function()
    if not mg.loading then
      dispatch({ type = actions.Update_Main_Grid_Start })
      refresh_main_grid(mg)
    else
      print("Not refreshing main grid - grid refresh in progress")
    end
  end)
  ui.endWindow()
end

-- Create main grid data viewer
---@param state table current window state
local function build_grid_viewer(state)
  local mg = state.main_grid
  local ui = flycast.ui
  ui.beginWindow("Grid View", 0, 0, 1060, 0)
  ui.text(string.format("Viewing grid (%d,%d)", mg.x, mg.y))
  ui.rightText(string.format("Viewing grid (%d,%d)", mg.x, mg.y))
  ui.text(mg.grid_string)
  ui.endWindow()
end

local function refresh_score_grid()
  dispatch({ 
    type = actions.Update_Score_Grid_End,
    payload = maingrid.super.get_score_grid()
  })
end

---Create score grid control window
---@param state table current window state
local function build_score_controls_window(state)
  local sg = state.score_grid
  if not sg.loading and sg.grid == nil then
    refresh_score_grid()
  end
  local ui = flycast.ui
  ui.beginWindow("Score", 0, 240, 250, 0)
  ui.button("-1p", function()
    if not sg.loading then
      dispatch({ type = actions.Step_Score_Precision_Down })
      refresh_score_grid()
    else
      print("Not changing precision - loading new grid view")
    end
  end)
  ui.button("+1p", function()
    if not sg.loading then
      dispatch({ type = actions.Step_Score_Precision_Up })
      refresh_score_grid()
    else
      print("Not changing precision - loading new grid view")
    end
  end)
  ui.button("Update", function()
    if not sg.loading then
      refresh_score_grid()
    else
      print("Not refreshing score grid - grid refresh in progress")
    end
  end)
  ui.endWindow()
end

---Build score grid viewer window
---@param state { score_grid: { grid_string: string }} Score grid state
local function build_score_viewer(state)
  local ui = flycast.ui
  ui.beginWindow("Score View", 0, 0, 0, 235)
  ui.text(state.score_grid.grid_string)
  ui.endWindow()
end

---Build main and score grid windows
---@param visibility { maingrid: boolean, scoregrid: boolean } Window visibility options
---@param render_count integer UI render count
local function build_grid_windows(visibility, render_count)
  if visibility.maingrid then
    build_grid_controls_window(Grid_Window_State)
    build_grid_viewer(Grid_Window_State)
  end
  if visibility.scoregrid then
    build_score_controls_window(Grid_Window_State)
    build_score_viewer(Grid_Window_State)
  end
end

return build_grid_windows