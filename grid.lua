local memory = require("lua.seventhcross.memory")
local consts = require("lua.seventhcross.constants")
local GRID_ADDR = 0x8c3be40c

local sg = {}

local grid_props = {
    outer = {
        dimensions = {
            width = 20
        },
        size = {}
    },
    inner = {
        dimensions = {
            width = 10
        },
        size = {}
    },
    full = {
        dimensions = {},
        size = {}
    }
}
grid_props.outer.dimensions.height = grid_props.outer.dimensions.width
grid_props.outer.size.row = grid_props.outer.dimensions.width * consts.sizeof.float
grid_props.outer.size.col = grid_props.outer.dimensions.height * consts.sizeof.float

grid_props.inner.dimensions.height = grid_props.inner.dimensions.width
grid_props.inner.size.row = grid_props.inner.dimensions.width * consts.sizeof.float
grid_props.inner.size.col = grid_props.inner.dimensions.height * consts.sizeof.float

grid_props.full.dimensions.height = grid_props.outer.dimensions.height * grid_props.inner.dimensions.height
grid_props.full.dimensions.width = grid_props.outer.dimensions.width * grid_props.inner.dimensions.width
grid_props.full.size.row = grid_props.full.dimensions.width * consts.sizeof.float
grid_props.full.size.col = grid_props.full.dimensions.height * consts.sizeof.float



-- grid is 20x20 -> 10x10
-- each row/col is 200 indices
-- each 20x20 is subdivided into 10x10s

local function coord_to_idx(x,y)
    return (y * 10) + x
end


local function outer_grid_coord_to_index(x,y)
    return (y * grid_props.outer.dimensions.row) + x
end

local function inner_grid_coord_to_index(x, y)
    return (y * grid_props.inner.dimensions.height) + x
end

local function inner_grid_coord_to_offset(x, y)
    return inner_grid_coord_to_index(x, y) * consts.sizeof.float
end

local function outer_grid_coord_to_offset(x, y)
    return (y * grid_props.inner.size.col) + (x * consts.sizeof.float)
end

function sg.read_inner_grid(x, y)
    print(string.format("Reading inner grid (%d, %d)", x, y))
    local grid_offset = outer_grid_coord_to_offset(x, y)
    local start_addr = GRID_ADDR + outer_grid_coord_to_offset(x, y)
    print(string.format("Got start offset 0x%08x -> 0x%08x", grid_offset, start_addr))
    local g = {}
    for i = 0, grid_props.inner.dimensions.height, 1 do
        g[i] = {}
        for j = 0, grid_props.inner.dimensions.width, 1 do
            g[i][j] = memory.readFloat32(start_addr + inner_grid_coord_to_offset(x, y))
        end
    end
    return g
end

function sg.row_to_string(grid, row_idx)
    local r = grid[row_idx]
    local s = ""
    for g = 0, #r do
        s = s..string.format("%f ", r[g])
    end
    return s
end

function sg.print_grid(grid)
    local st = ""
    for g = 0, #grid, 1 do
        for h = 0, #grid[g], 1 do
            st = st..string.format("%f", grid[g][h]) .. " "
            -- io.write(string.format("%02d", grid[g][h]) .. " ")
        end
        st = st.."\n"
        -- io.write("\n")
    end
    return st
end

return sg

