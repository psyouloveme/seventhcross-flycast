local mem = require "lua.seventhcross.emulator.memory"
local supergrid = require "lua.seventhcross.components.supergrid"
local grid  = require "lua.seventhcross.components.grid"
local logger  = require "lua.seventhcross.components.log"

local function build_test_window()
    local ui = flycast.ui
    ui.beginWindow("Tests", 1065, 270, 100, 0)
    ui.button("Float 1", function()
        local g = supergrid.read_supergrid()
        supergrid.print_grid(g)
        print("trying float formats")
        local ad1 = mem.read8(0x8c0c72b4)
        local ad2 = mem.read8(0x8c0c72b4+1)
        print(mem.read32(0x8c0c72b4))
        print(ad1)
        print(ad2)
        flycast.emulator.displayNotification(string.format("read supergrid %d, %d", ad1, ad2), 2500)
        print(mem.read32(0x8c0c72b4 + 4))
    end)
    ui.button("Float 2", function()
      print("trying float formats")
        mem.tests.try_float_formats(0x8c3be40c, "f1")
        mem.tests.try_float_formats(0x8c1e1984, "f2")
        mem.tests.try_float_formats(0x8c1e1990, "f3")
      end)
      ui.button("Float 3", function()
        local ad5 = mem.readFloat32(0x8c3be40c)
        print("0x8c3be410: 5 print: ", ad5)
        print(string.format("0x8c3be40c: 5 hex: %f", ad5))
        flycast.emulator.displayNotification(string.format("read grid %f", ad5), 2500)

        local ad6 = mem.readFloat32(0x8c1e1984)
        print("0x8c1e1984: 5 print: ", ad6)
        print("0x8c1e1984: 5 tostring: ", tostring(ad6))
        print(string.format("0x8c1e1984: 5 hex: %f", ad6))
        flycast.emulator.displayNotification(string.format("read grid %f", ad6), 2500)
      end)
      ui.button("Grid 1", function()
        local g = grid.read_inner_grid(0,0)
        local grid_str  = grid.print_grid(g)
        print(grid_str)
        g = grid.read_inner_grid(0,1)
        grid_str  = grid.print_grid(g)
        print(grid_str)
        g = grid.read_inner_grid(1,1)
        grid_str  = grid.print_grid(g)
        print(grid_str)
    end)
end

return build_test_window
