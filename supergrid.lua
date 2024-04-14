local memory = require "lua.seventhcross.memory"
local constants = require "lua.seventhcross.constants"
local SUPER_GRID_ADDR = 0x8c0c72b4

local grid_props = {
    dimensions = {
        width = 20,
        height = 20
    },
    size = {}
}
grid_props.size.row = grid_props.dimensions.width * constants.sizeof.float
grid_props.size.col = grid_props.dimensions.height * constants.sizeof.float

local function coord_to_idx(x,y)
    -- print(string.format("coord_to_idx %d, %d -> %d", x, y, (y * 20) + x))
    return (y * 20) + x
end

local function idx_to_coord(index)
    local x = index % grid_props.dimensions.width
    local y = math.floor(index / grid_props.dimensions.height)
    -- print(string.format("idx_to_coord %d -> %d, %d", index, x, y))
    return { x = x, y = y }
end

local sg = {}

function sg.read_supergrid()
    local s = {}
    for i=0, grid_props.dimensions.height - 1 do
        s[i] = {}
        for j=0, grid_props.dimensions.width - 1 do
            local idx = coord_to_idx(i,j)
            local coord = idx_to_coord(idx)
            -- print(string.format("%d %d %d ?= %d %d %d", i, j, idx, idx, coord.x, coord.y))
            s[i][j] = memory.read8(SUPER_GRID_ADDR + idx)
        end
    end
    return s
end

function sg.row_to_string(grid, row_idx)
    local r = grid[row_idx]
    local s = ""
    for g = 0, #r do
        s = s..string.format("%02d ", r[g])
    end
    return s
end

function sg.print_grid(grid)
    local st = ""
    for g = 0, #grid do
        for h = 0, #grid[g] do
            -- io.write(string.format("%02d", grid[g][h]) .. " ")
            st = st..string.format("%02d", grid[g][h]) .. " "
        end
        -- io.write("\n")
        st = st.."\n"
    end
    return st
end

return sg

