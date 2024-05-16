local maingrid = require "lua.seventhcross.components.maingrid"
local util = require "lua.seventhcross.windows.gridshared"
local logger = require "lua.seventhcross.components.log"

---@enum ScoreGridWindowActionType
local actions = {
  Step_Score_Precision_Up = 9;
  Step_Score_Precision_Down = 10;
  Update_Score_Grid_Start = 11;
  Update_Score_Grid_End = 12;
  Toggle_Score_Grid_Autoupdate = 13;
};

---@class ScoreGridWindowReducerAction
---@field type ScoreGridWindowActionType Reducer action type
---@field payload? any Reducer payload

---@class ScoreGridWindowState
---@field grid? number[][] 20x20 matrix containing the "score" of a each 10x10 sub-grid
---@field grid_string? string String representation of the 20x20 score grid for display
---@field changes? number[][] Table containing change data determined when updating the grid
---@field changes_string? string String representation of the change data for display
---@field loading boolean Internal grid refresh in-progress indicator
---@field autoupdate boolean Enable/disable automatic grid updates
---@field precision integer Floating point decimal precision to use for display
local score_grid_state = {
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

---Reducer for score grid display state
---@param state ScoreGridWindowState Score grid display state
---@param action ScoreGridWindowReducerAction Action to execute
---@return ScoreGridWindowState next_state State after action is applied
local function reducer(state, action)
  local next_state = {}
  for k, v in pairs(state) do
    next_state[k] = v
  end
  if action.type == actions.Step_Score_Precision_Down then
    next_state.loading = true
    next_state.precision = util.step_view(state.precision, 9, -1)
  elseif action.type == actions.Step_Score_Precision_Up then
    next_state.loading = true
    next_state.precision = util.step_view(state.precision, 9, 1)
  elseif action.type == actions.Update_Score_Grid_Start then
    next_state.loading = true
  elseif action.type == actions.Update_Score_Grid_End then
    next_state.loading = false
    next_state.grid = action.payload
    util.grid_refresh_end(next_state, state)
    print("Score Grid Refresh - End")
  end
  if next_state.loading then
    print("Score Grid Refresh - Start")
  end
  return next_state
end

---Dispatch function for grid window actions
---@param action ScoreGridWindowReducerAction Action to execute
local function dispatch(action)
    score_grid_state = reducer(score_grid_state, action)
end

---Refresh the score grid in state
local function get_score_grid()
    dispatch({
        type = actions.Update_Score_Grid_End,
        payload = maingrid.super.get_score_grid()
    })
end

---
local function refresh_score_grid()
  dispatch({ type = actions.Update_Score_Grid_Start })
  get_score_grid()
end

---Create score grid control window
---@param state ScoreGridWindowState current window state
local function build_score_controls_window(state)
  if not state.loading and state.grid == nil then
    refresh_score_grid()
  end
  local ui = flycast.ui
  ui.beginWindow("Score", 0, 240, 250, 0)
  ui.button("-1p", function()
    if not state.loading then
      dispatch({ type = actions.Step_Score_Precision_Down })
      refresh_score_grid()
    else
      print("Not changing precision - loading new grid view")
    end
  end)
  ui.button("+1p", function()
    if not state.loading then
      dispatch({ type = actions.Step_Score_Precision_Up })
      refresh_score_grid()
    else
      print("Not changing precision - loading new grid view")
    end
  end)
  ui.button((state.autoupdate and "O" or "X").." AutoUpdate", function()
    dispatch({ type = actions.Toggle_Score_Grid_Autoupdate })
  end)
  ui.button("Update", function()
    if not state.loading then
        refresh_score_grid()
    else
      print("Not refreshing score grid - grid refresh in progress")
    end
  end)
  ui.endWindow()
end

---Build score grid viewer window
---@param state ScoreGridWindowState Score grid state
local function build_score_viewer(state)
  local ui = flycast.ui
  ui.beginWindow("Score View", 0, 0, 0, 235)
  ui.text(state.grid_string)
  ui.endWindow()
end

---Build score grid windows
local function build_grid_windows()
  render_count = render_count + 1
  build_score_controls_window(score_grid_state)
  build_score_viewer(score_grid_state)
end

return build_grid_windows