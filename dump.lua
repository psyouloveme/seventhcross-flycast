local consts = require "lua.seventhcross.constants"
local dump = {}

---Dump a memory region to file from start_offset to end_offset
---@param start_offset integer the first address to dump
---@param end_offset integer the last address + 1 to dump
function dump.dump_mem_region(start_offset, end_offset)
  local memfilename = "memdump-" .. os.date("%d%m%Y%H%M%S") .. "-" .. string.format("%x", start_offset) .. "-" .. string.format("%x", end_offset)  .. ".bin"
  local memfile = assert(io.open(memfilename, "wb"))
  print("Creating memory dump file" .. memfilename)
  local offset = start_offset
  while offset < end_offset do
    local b = flycast.memory.read8(offset)
    memfile:write(string.char(b))
    offset = offset + 1
  end
  memfile:close()
  print("Dump file closed.")
end

---Wrapper for dump_mem_region to handle UI notifications (which are broken in the current flycast lol)
---@param start_offset integer the first address to dump 
---@param end_offset integer the last address + 1 to dump
function dump.do_region_dump(start_offset, end_offset)
  -- this doesn't work while paused
  -- flycast.emulator.displayNotification("Dump Starting", 2000)
  print(string.format("Starting memory dump 0x%x-0x%x", start_offset, end_offset))
  dump.dump_mem_region(start_offset, end_offset)
  print(string.format("Finished memory dump 0x%x-0x%x", start_offset, end_offset))
  -- this doesn't work while paused
  -- flycast.emulator.displayNotification("Dump Complete", 2000)
end

---UI callback to start a memory dump to file
---@param dump_type DumpType the type of dump to perform, maps to a constant MemoryRange
function dump.do_gui_dump(dump_type)
  if dump_type == consts.dump_type.Player or dump_type == consts.dump_type.All then
    dump.do_region_dump(consts.ranges.PlayerStruct.Start,consts.ranges.PlayerStruct.End)
    flycast.emulator.resume()
  elseif dump_type == consts.dump_type.Main or dump_type == consts.dump_type.All then
    dump.do_region_dump(consts.ranges.MainMemory.Start, consts.ranges.MainMemory.End)
    flycast.emulator.resume()
  elseif dump_type == consts.dump_type.MainGrid or dump_type == consts.dump_type.All then
    dump.do_region_dump(consts.ranges.MainGrid.Start, consts.ranges.MainGrid.End)
    flycast.emulator.resume()
  end
end

return dump