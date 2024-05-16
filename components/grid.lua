local memory = require("lua.seventhcross.emulator.memory")
local consts = require("lua.seventhcross.constants")
local logger = require "lua.seventhcross.components.log"


local sg = {}
-- local grid = {
--     height = 400,
--     width = 400,
--     value_size = consts.sizeof.float
-- }

local grid_props = {
    outer = {
        dimensions = {
            width = 20,
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


-- grid_props.outer


grid_props.inner.dimensions.height = grid_props.inner.dimensions.width
grid_props.inner.size.row = grid_props.inner.dimensions.width * consts.sizeof.float
grid_props.inner.size.col = 1 * consts.sizeof.float

grid_props.outer.dimensions.height = grid_props.outer.dimensions.width
grid_props.outer.size.row = (grid_props.outer.dimensions.width * (grid_props.inner.dimensions.width * grid_props.inner.dimensions.height)) * consts.sizeof.float
grid_props.outer.size.col = (grid_props.inner.dimensions.height * grid_props.inner.dimensions.width) * consts.sizeof.float


-- grid_props.full.dimensions.height = grid_props.outer.dimensions.height * grid_props.inner.dimensions.height
-- grid_props.full.dimensions.width = grid_props.outer.dimensions.width * grid_props.inner.dimensions.width
-- grid_props.full.size.row = grid_props.full.dimensions.width * consts.sizeof.float
-- grid_props.full.size.col = grid_props.full.dimensions.height * consts.sizeof.float


-- print(string.format("  grid_props.full.dimensions.height: 0x%08x %d", grid_props.full.dimensions.height, grid_props.full.dimensions.height))
-- print(string.format("  grid_props.full.dimensions.width: 0x%08x %d", grid_props.full.dimensions.width, grid_props.full.dimensions.width))
-- 800 bytes for a row or col, whole table is 160,000 = (800 * 10 * 10 * 2)
-- print(string.format("  grid_props.full.size.row: 0x%08x %d", grid_props.full.size.row, grid_props.full.size.row))
-- print(string.format("  grid_props.full.size.col: 0x%08x %d", grid_props.full.size.col, grid_props.full.size.col))

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

local function debug_print(label, val)
    print(string.format("  %s: 0x%06x (%d)", label, val, val))
end

local function try_float_print_formats(fl, label)
    if fl == nil then
        print(string.format("%s is nil", label))
    else
      print(string.format("%s: print: ", label), fl)
      print(string.format("%s: tostring: ", label), tostring(fl))
      print(string.format("%s: strf: %f", label, fl))
    end
end
  
  
  local function try_float_formats(addr, label)
    local m1 = memory.read32(addr)
    local m2 = memory.readFloat32_old(addr)
    local m3 = memory.read32_dumb_str(addr)
    local m4 = memory.read32_dumb_str2(addr)
    local m5 = memory.read32_dumb_str3(addr)
    local m6 = memory.read32_dumb_str4(addr)
    local m6 = memory.readFloat32(addr)
  
    try_float_print_formats(m1, label.."-1")
    try_float_print_formats(m2, label.."-2")
    try_float_print_formats(m3, label.."-3")
    try_float_print_formats(m4, label.."-4")
    try_float_print_formats(m5, label.."-5")
    try_float_print_formats(m6, label.."-6")
end

-- (0, 0, 0, 0) 8c3be40c = (0, 0, 0, 0)+0x000000 (0)    
-- (0, 1, 0, 0) 8c3be59c = (0, 0, 0, 0)+0x000190 (400)  
-- (1, 0, 0, 0) 8c3c034c = (0, 0, 0, 0)+0x001F40 (8,000)
-- (1, 1, 0, 0) 8c3c04dc = (0, 0, 0, 0)+0x0020D0 (8,400)
-- (1, 1, 0, 1) 8c3c04e0 = (0, 0, 0, 0)+0x0020D4 (8,404)
-- (1, 1, 1, 0) 8c3c0504 = (0, 0, 0, 0)+0x0020F8 (8,440)
-- (1, 1, 1, 1) 8c3c0508 = (0, 0, 0, 0)+0x0020FC (8,444)

local function coord_to_idx(y,x)
    -- print(string.format("coord_to_idx %d, %d -> %d", x, y, (y * 20) + x))
    return (y * grid_props.dimensions.height) + (x * consts.sizeof.byte)
end


-- this is correct
local function coord_to_index(x1, y1, x2, y2)
    local offset = (x1 * 2000)    -- 8,000 / 4 = 2000
    offset = offset + (y1 * 100)  -- 400 / 4 = 100
    offset = offset + (x2 * 10)   -- 40 / 4 = 10
    offset = offset + (y2 * 1)    -- 4 / 4 = 1
    return offset
end

local function coord_to_offset(x1, y1, x2, y2)
    local offset = (x1 * grid_props.outer.size.row)       -- 8,000 / 4 = 2000
    offset = offset + (y1 * grid_props.outer.size.col)    -- 400 / 4 = 100
    offset = offset + (x2 * grid_props.inner.size.row)    -- 40 / 4 = 10
    offset = offset + (y2 * grid_props.inner.size.col)    -- 4 / 4 = 1
    return offset
end




-- local cn = 0
-- for x = 0, 19 do
--     for y = 0, 19 do
--         for x2 = 0, 9 do
--             for y2 = 0, 9 do
--                 print(string.format("%06d: %02d, %02d, %02d, %02d = 0x%08x", cn, x, y, x2, y2, consts.addrs.MainGrid + coord_to_offset(x, y, x2, y2)))
--                 cn = cn + 1
--             end
--         end
--     end
-- end

local function outer_grid_coord_to_offset(x, y)
    return sg.coord_to_offset_transposed(x, y, 0, 0)
    -- local x_part = x * grid_props.outer.size.row
    -- local y_part = y * grid_props.outer.size.col
    -- print(string.format("Grid Outer Coord to Offset:"))
    -- debug_print("x_part", x_part)
    -- debug_print("y_part", y_part)
    -- debug_print("(x * grid_props.outer.size.row) + (y * grid_props.outer.size.col) + ", x_part + y_part)
    -- return y_part + x_part
end


sg.outer_grid = {}

--  coord index offset
--  _____ _____ ______
--    0     0     0

-- ci done
-- co done
-- ic done
-- io done
-- oc 
-- oi
print("Constants:")
print(string.format("  consts.sizeof.float: 0x%08x %d", consts.sizeof.float, consts.sizeof.float))
print("Grid props:")
print(string.format("  grid_props.outer.dimensions.height: 0x%08x %d", grid_props.outer.dimensions.height, grid_props.outer.dimensions.height))
print(string.format("  grid_props.outer.dimensions.width: 0x%08x %d", grid_props.outer.dimensions.width, grid_props.outer.dimensions.width))
print(string.format("  grid_props.outer.size.row: 0x%08x %d", grid_props.outer.size.row, grid_props.outer.size.row))
print(string.format("  grid_props.outer.size.col: 0x%08x %d", grid_props.outer.size.col, grid_props.outer.size.col))
print(string.format("  grid_props.inner.dimensions.height: 0x%08x %d", grid_props.inner.dimensions.height, grid_props.inner.dimensions.height))
print(string.format("  grid_props.inner.dimensions.width: 0x%08x %d", grid_props.inner.dimensions.width, grid_props.inner.dimensions.width))
print(string.format("  grid_props.inner.size.row: 0x%08x %d", grid_props.inner.size.row, grid_props.inner.size.row))
print(string.format("  grid_props.inner.size.col: 0x%08x %d", grid_props.inner.size.col, grid_props.inner.size.col))

function sg.outer_grid.coord_to_index(x1, y1, x2, y2)
    -- print("C2I", x1, y1, x2, y2)
    -- print("Grid props:")
    -- print(string.format("  grid_props.outer.dimensions.height: 0x%08x %d", grid_props.outer.dimensions.height, grid_props.outer.dimensions.height))
    -- print(string.format("  grid_props.outer.dimensions.width: 0x%08x %d", grid_props.outer.dimensions.width, grid_props.outer.dimensions.width))
    -- print(string.format("  grid_props.inner.dimensions.height: 0x%08x %d", grid_props.inner.dimensions.height, grid_props.inner.dimensions.height))
    -- print(string.format("  grid_props.inner.dimensions.width: 0x%08x %d", grid_props.inner.dimensions.width, grid_props.inner.dimensions.width))
    
    -- print((x1 * grid_props.outer.dimensions.width))
    -- print((y1 * grid_props.outer.dimensions.height))
    -- print((x2 * grid_props.inner.dimensions.width))
    -- print((y2 * grid_props.inner.dimensions.height))
    local index = (x1 * grid_props.outer.size.row) / consts.sizeof.float      -- 8,000 / 4 = 2000
    index = index + (y1 * grid_props.outer.size.col) / consts.sizeof.float   -- 400 / 4 = 100
    index = index + (x2 * grid_props.inner.size.row) / consts.sizeof.float    -- 40 / 4 = 10
    index = index + (y2 * grid_props.inner.size.col) / consts.sizeof.float   -- 4 / 4 = 1
    return index
end

function sg.outer_grid.coord_to_offset(x1, y1, x2, y2)
    local offset = (x1 * grid_props.outer.size.row)       -- 8,000 / 4 = 2000
    offset = offset + (y1 * grid_props.outer.size.col)    -- 400 / 4 = 100
    offset = offset + (x2 * grid_props.inner.size.row)    -- 40 / 4 = 10
    offset = offset + (y2 * grid_props.inner.size.col)    -- 4 / 4 = 1
    return offset
end

-- ic
-- io
function sg.outer_grid.index_to_coord(index)
    local coords = {}
    coords.x1 = math.floor(index / (grid_props.outer.size.row * grid_props.inner.size.row))
    coords.y1 = index % (grid_props.outer.dimensions.width * grid_props.inner.dimensions.width)
    coords.x2 = math.floor(index / grid_props.inner.size.row)
    coords.y2 = math.floor(index / grid_props.inner.size.col)
    return coords
end

function sg.outer_grid.index_to_offset(index)
    return index * consts.sizeof.float
end

-- offset -> x methods
function sg.outer_grid.offset_to_coord(offset)
    local coords = {}
    local index = offset / consts.sizeof.float
    coords.x1 = index % grid_props.outer.dimensions.width
    coords.y1 = math.floor(index / grid_props.outer.dimensions.height)
    coords.x2 = index % grid_props.inner.dimensions.width
    coords.y2 = math.floor(index / grid_props.inner.dimensions.height)
    return coords
end

function sg.outer_grid.offset_to_index(offset)
    return offset / consts.sizeof.float
end



-- function sg.outer_grid.coord_to_offset(x1, x2, y1, y2)
--     local offset = (x1 * grid_props.outer.size.row)       -- 8,000 / 4 = 2000
--     offset = offset + (y1 * grid_props.outer.size.col)    -- 400 / 4 = 100
--     offset = offset + (x2 * grid_props.inner.size.row)    -- 40 / 4 = 10
--     offset = offset + (y2 * grid_props.inner.size.col)    -- 4 / 4 = 1
--     return offset
-- end

-- function sg.outer_grid.coord_to_index(x1, x2, y1, y2)
--     local offset = (x1 * grid_props.outer.dimensions.row)       -- 8,000 / 4 = 2000
--     offset = offset + (y1 * grid_props.outer.dimensions.col)    -- 400 / 4 = 100
--     offset = offset + (x2 * grid_props.inner.dimensions.row)    -- 40 / 4 = 10
--     offset = offset + (y2 * grid_props.inner.dimensions.col)    -- 4 / 4 = 1
--     return offset
-- end

-- function sg.outer_grid.index_to_coord(index)
--     local coords = {}
--     coords.x1 = index % grid_props.outer.dimensions.width
--     coords.y2 = math.floor(index / grid_props.outer.dimensions.height)
--     coords.x2 = index % grid_props.inner.dimensions.width
--     coords.y2 = math.floor(index / grid_props.inner.dimensions.height)
--     return coords
-- end

function sg.idx_to_coord(index)
    local coords = {}
    coords.x = index % grid_props.outer.dimensions.width
    coords.y = math.floor(index / grid_props.outer.dimensions.height)
    coords.index = index
    return coords
end

function sg.coord_to_offset_transposed(y1, x1, y2, x2)
    local offset = (x1 * grid_props.outer.size.row)       -- 8,000 / 4 = 2000
    offset = offset + (y1 * grid_props.outer.size.col)    -- 400 / 4 = 100
    offset = offset + (x2 * grid_props.inner.size.row)    -- 40 / 4 = 10
    offset = offset + (y2 * grid_props.inner.size.col)    -- 4 / 4 = 1
    return offset
end

function sg.coord_to_offset(x1, x2, y1, y2)
    local offset = (x1 * grid_props.outer.size.row)       -- 8,000 / 4 = 2000
    offset = offset + (y1 * grid_props.outer.size.col)    -- 400 / 4 = 100
    offset = offset + (x2 * grid_props.inner.size.row)    -- 40 / 4 = 10
    offset = offset + (y2 * grid_props.inner.size.col)    -- 4 / 4 = 1
    return offset
end

function sg.read_inner_grid_by_index(grid_idx)
    local coord = sg.idx_to_coord(grid_idx)
    return sg.read_inner_grid(coord.x, coord.y)
end

function sg.read_inner_grid_by_coord(x, y)
    local offset = consts.addrs.MainGrid + sg.coord_to_offset(x, y, 0, 0)
    return memory.readFloat32(offset)
end

function sg.read_inner_grid(x, y)
    print(string.format("Reading inner grid (%d, %d)", x, y))
    -- local grid_offset = outer_grid_coord_to_offset(x, y)
    -- local start_addr = consts.addrs.MainGrid + grid_offset
    -- print(string.format("Got start offset 0x%08x -> 0x%08x", grid_offset, start_addr))
    local g = {}
    for y2 = 0, grid_props.inner.dimensions.height - 1 do
        for x2 = 0, grid_props.inner.dimensions.width - 1 do
            if g[x2] == nil then
                g[x2] = {}
            end
            if g[x2][y2] == nil then
                g[x2][y2] = {}
            end
            -- debug_print(string.format("g[%02d][%02d]", i, j), g[i][j])
            -- g[i][j] = memory.readFloat32(start_addr + inner_grid_coord_to_offset(x, y))
            local offset = consts.addrs.MainGrid + sg.coord_to_offset(x, y, x2, y2)
            -- local index = coord_to_index(x, y, i, j)
            g[x2][y2] = memory.readFloat32(offset)
            -- debug_print(string.format("g[%02d][%02d]", i, j), g[i][j])
            -- print(string.format("g[i][j] = g[%02d][%02d] = ", i, j), g[i][j])
            -- try_float_formats(offset, string.format("0x%08x", offset))
            -- print(string.format("0x%08x = (x, y, i, j) = (%02d, %02d, %02d, %02d) = [%d] = ", offset, x, y, i, j, index), string.format("%0.9f",g[i][j]))
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
    local st = "\t\t\t"
    for a = 0, #grid[0] do
        st = st..string.format("%02d\t\t\t\t\t\t", a)
    end
    st = st.."\n"
    for g = 0, #grid do
        st = st..string.format("%02d\t", g)
        for h = 0, #grid[g] do
            st = st..string.format("%0.9f",grid[g][h])
            if h ~= #grid[g] then
                st = st .. "\t"
            end
            -- st = st..string.format("%f", grid[g][h]) .. "    "
            -- io.write(string.format("%02d", grid[g][h]) .. " ")
        end

        st = st.."\n"
        -- io.write("\n")
    end
    return st
end

return sg

-- 0x8c3e543c = (19, 19,  9,  9) = [39999]
-- ^ !!! this is wrong. 
-- 0x8c3e543c = (19, 19,  4,  8) = [39948]
-- 0x8c3e5508 = (19, 19,  9,  9) = [39999]