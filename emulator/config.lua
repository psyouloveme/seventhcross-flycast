local MapleTypes =  {
  ---Maple bus number - aka controller port, analogous to FlycastTypes.Input.Player
  ---@enum MapleTypes.Bus
  Bus = {
    Bus1 = 1;
    Bus2 = 2;
    Bus3 = 3;
    Bus4 = 4;
  };

  ---Maple port number - controller port for accessories, 2 per bus (controller)
  ---@enum MapleTypes.Port
  Port = {
    Port1 = 1;
    Port2 = 2;
  };

  ---Maple device type - e.g. controller, mouse, lightgun, etc.
  ---Only valid devices for flycast.config.maple.setDeviceType are here
  ---@enum MapleTypes.Device
  Device = {
    SegaController =  0;
    AsciiStick     =  4;
    Keyboard       =  5;
    Mouse          =  6;
    LightGun       =  7;
    TwinStick      =  8;
    None           = 10;
  };

  ---Sub-devices that are accepted by flycast.config.maple.setSubDeviceType
  ---@enum MapleTypes.SubDevice
  SubDevice = {
    SegaVMU      =  1;
    Microphone   =  2;
    PurupuruPack =  3;
    None         = 10;
  };

  ---Unable to send inputs to these, so not considering them valid
  ---@enum MapleTypes.OtherDeviceType
  OtherDeviceType = {
    MDT_NaomiJamma           =  9;
    MDT_RFIDReaderWriter     = 11;
    MDT_MaracasController    = 12;
    MDT_FishingController    = 13;
    MDT_PopnMusicController  = 14;
    MDT_RacingController     = 15;
    MDT_DenshaDeGoController = 16;
    MDT_Dreameye             = 17;
    MDT_Count                = 18;
  };
}

FlycastConfig = {
  Maple = {
    ---Error wrapped flycast.config.maple.getDeviceType
    ---@param bus MapleTypes.Bus the maple bus to query
    ---@return MapleTypes.Device value The current maple device or None (10)
    getDeviceType = function(bus)
      local status, val = pcall(function() return flycast.config.maple.getDeviceType(bus) end);
      if status ~= true then
        local msg = string.format("Error: Failed retreiving maple device type for bus %d: %s", bus, val);
        print(msg);
        return MapleTypes.Device.None;
      end
      return val;
    end;

    ---Error wrapped flycast.config.maple.getDeviceSubType
    ---@param bus MapleTypes.Bus the maple bus to query
    ---@return MapleTypes.SubDevice value The current maple device or None (10)
    getSubDeviceType = function(bus, port)
      local status, val = pcall(function() return flycast.config.maple.getSubDeviceType(bus, port) end);
      if status ~= true then
        local msg = string.format("Error: Failed retreiving maple sub device type for bus %d port %d: %s", bus, port, val);
        print(msg);
        return MapleTypes.SubDevice.None;
      end
      return val;
    end;
  };
  MapleTypes = MapleTypes;
}

return FlycastConfig;