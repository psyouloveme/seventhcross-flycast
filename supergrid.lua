local memory = require "lua.seventhcross.memory"
local constants = require "lua.seventhcross.constants"
local function debug_print(label, val)
    print(string.format("  %s: 0x%06x (%d)", label, val, val))
end

local grid_props = {
    dimensions = {
        width = 20,
        height = 20
    },
    size = {}
}
grid_props.size.row = grid_props.dimensions.width * constants.sizeof.byte
grid_props.size.col = grid_props.dimensions.height * constants.sizeof.byte

-- print("Constants:")
-- print(string.format("  super_grid_props.dimensions.height: 0x%08x %d", grid_props.dimensions.height, grid_props.dimensions.height))
-- print(string.format("  super_grid_props.dimensions.width: 0x%08x %d", grid_props.dimensions.width, grid_props.dimensions.width))
-- print(string.format("  super_grid_props.size.row: 0x%08x %d", grid_props.size.row, grid_props.size.row))
-- print(string.format("  super_grid_props.size.col: 0x%08x %d", grid_props.size.col, grid_props.size.col))

local function coord_to_idx_transposed(y,x)
    -- print(string.format("coord_to_idx %d, %d -> %d", x, y, (y * 20) + x))
    return (y * grid_props.dimensions.height) + (x * constants.sizeof.byte)
end

local sg = {}

function sg.coord_to_idx(x,y)
    -- print(string.format("coord_to_idx %d, %d -> %d", x, y, (y * 20) + x))
    return (y * grid_props.dimensions.height) + (x * constants.sizeof.byte)
end

function sg.idx_to_coord(index)
    local coords = {}
    coords.x = index % grid_props.dimensions.width
    coords.y = math.floor(index / grid_props.dimensions.height)
    return coords
end

function sg.read_supergrid()
    local s = {}
    for y=0, grid_props.dimensions.height - 1 do
        for x=0, grid_props.dimensions.width - 1 do
            if s[x] == nil then
                s[x] = {}
            end
            if s[x][y] == nil then
                s[x][y] = {}
            end
            local idx = sg.coord_to_idx(x,y)
            -- local coord = sg.idx_to_coord(idx)
            -- print(string.format("%d %d %d ?= %d %d %d", i, j, idx, idx, coord.x, coord.y))
            s[x][y] = memory.read8(constants.addrs.SuperGrid + idx)
        end
    end
    return s
end

function sg.read_part_quadrant(part_type, display)
    local q = {}
    local y_min = 0 + ((part_type >> 1) * 10)
    local y_max = 10 + ((part_type >> 1) * 10)
    local x_min = 0 + ((part_type & 1) * 10)
    local x_max = 10 + ((part_type & 1) * 10)

    -- print(string.format("x min %d, y min %d, x max %d, y max %d", x_min, y_min, x_max, y_max))
    for y = y_min, y_max - 1, 1 do
        for x = x_min, x_max - 1, 1 do
            local adj_x = x
            local adj_y = y
            if display then
                adj_x = x - x_min
                adj_y = y - y_min
            end
            if q[adj_x] == nil then
                q[adj_x] = {}
            end
            if q[adj_x][adj_y] == nil then
                q[adj_x][adj_y] = {}
            end
            local idx = sg.coord_to_idx(x,y)
            local coord = sg.idx_to_coord(idx)
            -- print(string.format("%d %d %d ?= %d %d %d", x, y, idx, idx, coord.x, coord.y))
            -- print(string.format("reading 0x%08x", constants.addrs.SuperGrid + idx))
            q[adj_x][adj_y] = memory.read8(constants.addrs.SuperGrid + idx)
        end
    end
    return q
end

-- function sg.read_part_quadrant(part_type)
--     local q = {}
--     local y_min = 0 + ((part_type >> 1) * 10)
--     local y_max = 10 + ((part_type >> 1) * 10)
--     local x_min = 0 + ((part_type & 1) * 10)
--     local x_max = 10 + ((part_type & 1) * 10)

--     for y = y_min, y_max do
--         for x = x_min, x_max do
--             local idx = coord_to_idx_transposed(x,y)
--             q[x][y] = memory.read8(constants.addrs.SuperGrid + idx)
--         end
--     end
--     return q
-- end


function sg.read_supergrid_coord(x, y)
    local index = sg.coord_to_idx(x,y)
    return memory.read8(constants.addrs.SuperGrid + index)
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
    local header = "00\t"
    for g = 0, #grid do
        header = header..string.format("%02d   ", g)
        st = st..string.format("%02d\t", g)
        for h = 0, #grid[g] do
            if grid[h][g] ~= nil then
                st = st..string.format("%02d   ", grid[h][g])
            else
                error("grid["..tostring(g).."]["..h.."] is nil!")
            end
        end
        st = st.."\n"
    end
    header = header.."\n\n"
    return header..st
end

return sg

