local InputTypes = {
  	---Player number
	---@enum InputTypes.Player
	Player = {
		One   = 1;
		Two   = 2;
		Three = 3;
		Four  = 4;
	};

  ---Convenience enum for controller axes
	---@enum InputTypes.ControllerAxis
	ControllerAxis = {
		JoyX  = 1;
		JoyY  = 2;
		JoyRX = 3;
		JoyRY = 4;
		JoyLT = 5;
		JoyRT = 6;
	};

  ---Convenience enum for controller buttons
	---@enum FlycastTypes.ControllerButton
	ControllerButton = {
		C      = 1 << 0;
		B      = 1 << 1;
		A      = 1 << 2;
		Start  = 1 << 3;
		Up1    = 1 << 4;
		Down1  = 1 << 5;
		Left1  = 1 << 6;
		Right1 = 1 << 7;
		Z      = 1 << 8;
		Y      = 1 << 9;
		X      = 1 << 10;
		D      = 1 << 11;
		Up2    = 1 << 12;
		Down2  = 1 << 13;
		Left2  = 1 << 14;
		Right2 = 1 << 15;
	};
}

local FlycastInput = {
  ---Error wrapped flycast.input.getButtons
  ---@param player InputTypes.Player
  ---@return number buttons The current button state
  getButtons = function(player)
    local status, val = pcall(function() return flycast.input.getButtons(player) end);
    if status ~= true then
      local msg = string.format("Error: Failed retreiving buttons for player %d: %s", player, val);
      print(msg);
      return 0;
    end
    return val;
  end;

  ---Error wrapped flycast.input.getAxis
  ---@param player InputTypes.Player
  ---@param axis InputTypes.ControllerAxis
  ---@return integer value The current axis value
  getAxis = function(player, axis)
    local status, val = pcall(function() return flycast.input.getAxis(player, axis) end);
    if status ~= true then
      local msg = string.format("Error: Failed retreiving axis %s for player %d: %s", axis, player, val);
      print(msg);
      return 0;
    end
    return val;
  end;

  ---Error wrapped flycast.input.getAbsCoordinates
  ---@param player InputTypes.Player the player to get mouse coords for
  ---@return number | nil, number | nil values The mouse absolute coordinate for the player
  getAbsCoordinates = function(player)
    local status, val, valtwo = pcall(function() return flycast.input.getAbsCoordinates(player) end);
    if status ~= true then
      local msg = string.format("Error: Failed retreiving mouse absolute coordinates for player %d: %s", player, val);
      print(msg);
      return 0.0, 0.0;
    end
    return val, valtwo;
  end;

  ---Error wrapped flycast.input.getRelCoordinates
  ---@param player InputTypes.Player the player to get mouse coords for
  ---@return number | nil, number | nil value The mouse relative coordinate for the player
  getRelCoordinates = function(player)
    local status, val, valtwo = pcall(function() return flycast.input.getRelCoordinates(player) end);
    if status ~= true then
      local msg = string.format("Error: Failed retreiving mouse relative coordinates for player %d: %s", player, val);
      print(msg);
      return 0.0, 0.0;
    end
    return val, valtwo;
  end;

  InputTypes = InputTypes;
}

return FlycastInput;