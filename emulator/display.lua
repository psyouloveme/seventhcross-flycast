local disp = {}

---@class DisplayDimensions
---@field width integer
---@field height integer

---Get current display dimensions
---@return DisplayDimensions dimensions display dimensions
function disp.get_display_dimensions()
  return {
    height = flycast.state.display.height;
    width = flycast.state.display.width;
  };
end;

return disp;