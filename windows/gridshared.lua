local maingrid = require "lua.seventhcross.components.maingrid"
local gridshared = {}

---Step function with bound, wrapping on both ends
---@param current integer the current position
---@param max integer the maximum position
---@param direction integer direction to step
---@return integer next the next position
function gridshared.step_view(current, max, direction)
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
function gridshared.changes_to_string(changes, precision)
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
---@param next_state ScoreGridWindowState | MainGridWindowState Grid window state to update
---@param prev_state ScoreGridWindowState | MainGridWindowState Previous grid window state
function gridshared.grid_refresh_end(next_state, prev_state)
    local tspc = maingrid.to_string_p_comp(next_state.grid, prev_state.grid, prev_state.precision);
    next_state.grid_string = tspc.grid_string
    next_state.changes = tspc.changes
    next_state.changes_string = gridshared.changes_to_string(tspc.changes, prev_state.precision)
end

return gridshared