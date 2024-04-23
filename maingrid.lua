---Grid operations
local consts = require("lua.seventhcross.constants")
local memory = require("lua.seventhcross.memory")

---@class Coord2 (x, y) coordinate
---@field x integer x coordinate.
---@field y integer y coordinate.

---@class GridChange a result from the comparison of grids A and B
---@field a number the value read from grid A
---@field b number the value read from grid B
---@field x integer the x coordinate that the value was read from (in both grids)
---@field y integer the y coordinate that the value was read from (in both grids)

---@alias Grid number[][] a grid of floating point values
---@alias GridChangeCollection GridChange[] an array of grid changes

---@class GridParseResult stringify and compare result
---@field grid_string string the string represenation of the left hand side input grid
---@field changes GridChangeCollection changes between grids a and b

--[[
    The main 200x200 evolution grid that is sub-divided
    into 40 10x10 grids that correspond to positions in the
    20x20 super-grid.
]]
---@module "lua.seventhcross.maingrid"
local grid = {
    --[[
        The main 200x200 evolution grid that is sub-divided
        into 40 10x10 grids that correspond to positions in the
        20x20 super-grid.
    ]]
    main = {
        ---Conversion methods for main grid indices
        index = {
            ---Translate a value index in the main grid to a coordinate in the sub-grid that contains it.
            ---@param index integer index into the array representation of the main grid.
            ---@return Coord2 coordinate x,y coordinate of the sub-grid that contains this index.
            to_sub_coord = function(index)
                return {
                    x = (index % consts.grid.main.width) % consts.grid.sub.width;
                    y = math.floor(index / consts.grid.main.width) % consts.grid.sub.width;
                }
            end;

            ---Translate an index into the array representation of the main grid into a super-grid 
            ---matrix coordinate based on the sub-grid that contains the index.
            ---@param index integer index into the array representation of the main grid.
            ---@return Coord2 coordinate x,y coordinate of the super-grid that contains this index.
            to_super_coord = function(index)
                return {
                    x = (index % consts.grid.main.width) % consts.grid.super.width;
                    y = math.floor(math.floor(index / consts.grid.main.width) / consts.grid.super.width);
                };
            end;

            ---Translate a value index in the main grid to the corresponding coordinate in the matrix representation of the main grid
            ---@param index integer index into the array representation of the main grid.
            ---@return Coord2 coordinate the main-grid coordinate that corresponds to index.
            to_coord = function(index)
                return {
                    x = index % consts.grid.main.width;
                    y = math.floor(index / consts.grid.main.height);
                };
            end;

            ---Translate an index into the array representation of the main grid to its' corresponding memory offset.
            ---@param index integer index into the array representation of the main grid.
            ---@return integer offset memory offset of the value pointed to by index.
            to_offset = function(index)
                return (index * consts.grid.main.value_size) + consts.grid.main.start_address
            end;
        };

        ---Conversion methods for main grid coordinates
        coord = {
            ---Translate a coordinate from the matrix representation of the main grid into the corresponding index into the array representation of the main grid.
            ---@param x integer main grid matrix representation x coordinate
            ---@param y integer main grid matrix representation y coordinate
            ---@return integer index index into the array representation of the main grid corresponding to (x,y)
            to_index = function(x, y)
                return (y * consts.grid.main.width) + x
            end;

            ---Translate a coordinate from the matrix representation of the main grid into the corresponding index into the array representation of the main grid.
            ---@param x integer main grid matrix representation x coordinate
            ---@param y integer main grid matrix representation y coordinate
            ---@return integer offset memory offset of the value corresponding to (x,y)
            to_offset = function(x, y)
                local idx = (y * consts.grid.main.width) + x
                local size_idx = idx * consts.grid.main.value_size
                local ad = size_idx + consts.grid.main.start_address
                -- print(string.format("coord.to_offset - %d %d 0x%08x", idx, size_idx, ad))
                return (((y * consts.grid.main.width) + x) * consts.grid.main.value_size) + consts.grid.main.start_address
            end;

            ---Translate an x,y coordinate in the 200x200 main grid to the corresponding coordinate in the 20x20 super grid.
            ---@param x integer the x component to translate
            ---@param y integer the y component to translate
            ---@return Coord2 coordinate the corresponding (x,y) coordinate in the 20x20 super grid 
            to_super_coord = function(x,y)
                local index = (y * consts.grid.main.width) + x
                return {
                    x = (index % consts.grid.main.width) % consts.grid.super.width;
                    y = math.floor(math.floor(index / consts.grid.main.width) / consts.grid.super.width);
                };
            end;
        };

        ---Conversion methods for main grid offsets
        offset = {
            ---Translate a memory offset into an index into the array representation of the main grid.
            ---@param offset integer memory offset to translate.
            ---@return integer index index into the array representation of the main grid that corresponds to offset.
            to_index = function(offset)
                return (offset - consts.grid.main.start_address) / consts.grid.main.value_size
            end;

            ---Translate a memory offset into a coordinate into the matrix representation of the main grid.
            ---@param offset integer memory offset to translate
            ---@return Coord2 coordinate coordinate in the matrix representation of the main grid that corresponds to offset.
            to_coord = function(offset)
                return {
                    x = math.floor((offset - consts.grid.main.start_address) / consts.grid.main.value_size) % consts.grid.main.width;
                    y = math.floor(((offset - consts.grid.main.start_address) / consts.grid.main.value_size) / consts.grid.main.width);
                }
            end;

            ---Translate an index into the array representation of the main grid into a super-grid 
            ---matrix coordinate based on the sub-grid that contains the index.
            ---@param offset integer index into the array representation of the main grid.
            ---@return Coord2 coordinate x,y coordinate of the super-grid that contains this index.
            to_super_coord = function(offset)
                local index = (offset - consts.grid.main.start_address) / consts.grid.main.value_size
                return {
                    x = (index % consts.grid.main.width) % consts.grid.super.width;
                    y = math.floor(math.floor(index / consts.grid.main.width) / consts.grid.super.width);
                };
            end;
        };
    };

    --[[
        The 20x20 super-grid that contains level values 
        for each body part, represented by quadrant.
        In order, the quadrants are: Head, Body, Arm, Leg.
        Each cell corresponds to a 10x10 grid in the
        main 200x200 grid.
    ]]
    super = {
        ---Conversion methods for super grid coordinates
        coord = {
            ---Translate a super-grid coordinate into the index of the first element of the array representation of the main grid.
            ---@param x integer x coordinate of the matrix representation of the super-grid to translate.
            ---@param y integer y coordinate of the matrix representation of the super-grid to translate.
            ---@return integer index index of the first value of the sub-grid indicated by the super-grid coordinate in the array representation of the main grid.
            to_main_offset = function(x, y)
                return (((y * consts.grid.sub.width * consts.grid.main.width) + (x * consts.grid.sub.width * consts.grid.sub.height)) * consts.grid.main.value_size) + consts.grid.main.start_address
            end;

            ---Translate a super-grid coordinate into the index of the first element of the array representation of the main grid.
            ---@param x integer x coordinate of the matrix representation of the super-grid to translate.
            ---@param y integer y coordinate of the matrix representation of the super-grid to translate.
            ---@return integer index index of the first value of the sub-grid indicated by the super-grid coordinate in the array representation of the main grid.
            to_main_index = function(x, y)
                local xpart = (x * consts.grid.sub.width)
                local ypart = (y * consts.grid.sub.width * consts.grid.main.width)
                -- print(string.format("%d %d -> ypart: %d  xpart: %d", x, y, ypart, xpart))
                return (y * consts.grid.sub.width * consts.grid.main.width) + (x * consts.grid.sub.width * consts.grid.sub.height)
            end;

            ---Translate a super-grid coordinate into main grid matrix coordinate that corresponds to (0,0) of the corresponding sub-grid pointed to by (x,y).
            ---@param x integer x coordinate of the matrix representation of the super-grid to translate.
            ---@param y integer y coordinate of the matrix representation of the super-grid to translate.
            ---@return Coord2 coordinate main grid matrix coordinate of the (0,0) corresponding sub-grid pointed to by (x,y).
            to_main_coord = function(x, y)
                return {
                    x = x * consts.grid.sub.width;
                    y = y * consts.grid.sub.height;
                }
            end;

            ---Translate a 20x20 super-grid coordinate to an index into the array represenation of the super-grid.
            ---@param x integer x coordinate of the matrix representation of the super-grid to translate.
            ---@param y integer y coordinate of the matrix representation of the super-grid to translate.
            ---@return integer index the corresponding array index of the coordinate
            to_index = function(x,y)
                return (y * consts.grid.super.width) + x;
            end;
        };
        ---Conversion methods for super grid indices
        index = {
            to_coord = function(index)
                return {
                    x = index % consts.grid.super.width;
                    y = math.floor(index / consts.grid.super.width);
                };
            end;
        };
    };

    --[[
        The 10x10 divisions of the main 200x200 grid
        that correspond to cells in the 20x20 super-grid.
    ]]
    sub = {
        ---Conversion methods for sub-grid coordinates
        coord = {
            ---Translate a sub-grid x,y coordinate into a value index into the array representation of the sub-grid that contains it
            ---@param x integer x cooridnate of the coordinate in the matrix representation of this sub-grid
            ---@param y integer y cooridnate of the coordinate in the matrix representation of this sub-grid
            ---@return integer index coordinate (x,y) translated to an index into the array representation of the sub-grid that contains this coordinate.
            to_index = function(x, y)
                return (y * consts.grid.sub.width) + x
            end;

            to_offset = function(x, y)
                return ((y * consts.grid.sub.width) + x) * consts.grid.main.value_size
            end;
        };
    };

    ---Compare two matricies of the same size and return an object containing the differences
    ---@param a Grid grid to use for left hand side of comparison
    ---@param b Grid grid to use for right hand side of comparison
    ---@return GridChangeCollection changes array of changes determined from the grid
    compare = function (a, b)
        ---@type GridChangeCollection
        local changes = {}
        for y = 0, #a do
            for x = 0, #a[0] do
                if a[x][y] ~= b[x][y] then
                    table.insert(changes, {
                        a = a[x][y];
                        b = b[x][y];
                        x = x;
                        y = y;
                    })
                end
            end
        end
        return changes
    end;

    ---Create a string representation of a grid
    ---@param grid Grid the grid to stringify
    ---@return string grid_string the string represenation of the grid
    to_string = function (grid)
        local st = "\t\t\t"
        for a = 0, #grid[0] do
            st = st..string.format("%02d\t\t\t\t\t\t", a)
        end
        st = st.."\n"
        for g = 0, #grid do
            st = st..string.format("%02d\t", g)
            for h = 0, #grid[g] do
                st = st..string.format("%0.9f",grid[h][g])
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
    end;

    ---Create a string representation of a grid with a specific float precision
    ---@param grid Grid the grid to stringify
    ---@param precision integer float precision to pass to string.format
    ---@return string grid_string the string represenation of the grid
    to_string_p = function (grid, precision)
        local st = "    \t"
        local fmt = "%0."..tostring(precision).."f"
        for a = 0, #grid[0] do
                                --    00.
            st = st..string.format("%02d", a)
            for a = 1, precision do
                st = st.."_"                
            end
            if precision < 5 then
                st = st.."\t"
            elseif precision < 7 then
                st = st.."\t\t"
            else
                st = st.."\t\t"
            end
            -- st = st..'\t'
        end
        -- "┌────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┬────┐"
   
        st = st.."\n"
        for g = 0, #grid do
            st = st..string.format("%02d\t", g)
            for h = 0, #grid[g] do
                st = st..string.format(fmt, grid[h][g])
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
    end;

    ---Create a string representation of a grid with a specific float precision and collect changes
    ---@param grid_a Grid the grid to stringify and the left hand side of the grid comparison
    ---@param grid_b Grid right hand side of the grid comparison
    ---@param precision integer float precision to pass to string.format
    ---@return GridParseResult result the stringified version of grid A and the comparison result vs B
    to_string_p_comp = function (grid_a, grid_b, precision)
        local st = "    \t"
        local fmt = "%0."..tostring(precision).."f"
        local changes = {}
        for a = 0, #grid_a[0] do
            st = st..string.format("%02d", a)
            for a = 1, precision do
                st = st.."_"   
            end
            if precision < 5 then
                st = st.."\t"
            elseif precision < 7 then
                st = st.."\t\t"
            else
                st = st.."\t\t"
            end
        end
        st = st.."\n"
        for g = 0, #grid_a do
            st = st..string.format("%02d\t", g)
            for h = 0, #grid_a[g] do
                if grid_b ~= nil and grid_b[h] ~= nil and grid_a[h][g] ~= grid_b[h][g] then
                    table.insert(changes, {
                        a = grid_a[h][g];
                        b = grid_b[h][g];
                        x = h;
                        y = g;
                    })
                end
                st = st..string.format(fmt, grid_a[h][g])
                if h ~= #grid_a[g] then
                    st = st .. "\t"
                end
            end
            st = st.."\n"
        end
        return {
            grid_string = st;
            changes = changes;
        }
    end;

    ---Test methods for the grid
    tests = {};
};



--[[ ********** Values **********]]

---Read a value from the main grid by a coordinate into the matrix representation of the main grid.
---@param x integer main grid matrix representation x coordinate
---@param y integer main grid matrix representation y coordinate
---@return number value the float value stored in game memory that corresponds to (x,y)
function grid.main.coord.read(x,y)
    return memory.readFloat32(grid.main.coord.to_offset(x,y))
end

---Read a value from the main grid by a coordinate into the matrix representation of the main grid.
---@param x1 integer super-grid matrix representation x coordinate
---@param y1 integer super-grid matrix representation y coordinate
---@param x2 integer sub-grid matrix representation x coordinate
---@param y2 integer sub-grid matrix representation y coordinate
---@return number value the float value stored in game memory that corresponds to (x1,y1,x2,y2)
function grid.main.read_value_by_super_sub_coord(x1, y1, x2, y2)
    local mgo = grid.super.coord.to_main_offset(x1, y1) + grid.sub.coord.to_offset(x2, y2)
    local val = memory.readFloat32(mgo);
    return val;
end

---Read a 10x10 subgrid from the matrix representation of the main grid by the corresponding super-grid coordinate.
---@param x integer super-grid matrix representation x coordinate.
---@param y integer super-grid matrix representation y coordinate.
---@return Grid subgrid a 10x10 matrix of floats that correspond the super-grid coordinate (x,y).
function grid.sub.read_by_super_coord(x,y)
    local g = {}
    for k = 0, consts.grid.sub.width - 1 do
        for j = 0, consts.grid.sub.width - 1 do
            if g[j] == nil then
                g[j] = {}
            end
            if g[j][k] == nil then
                g[j][k] = {}
            end
            g[j][k] = grid.main.read_value_by_super_sub_coord(x, y, j, k)
        end
    end
    return g
end

---Compute the "score" of a 10x10 sub-grid by super-grid coordinates
---@param x integer super-grid matrix representation x coordinate.
---@param y integer super-grid matrix representation y coordinate.
---@return number score the square sum of the component values
function grid.sub.score_by_super_coord(x,y)
    local score = 0
    for k = 0, consts.grid.sub.width - 1 do
        for j = 0, consts.grid.sub.width - 1 do
            local w = grid.main.read_value_by_super_sub_coord(x, y, j, k)
            local wd = w;
            wd = wd * wd;
            local scored = score;
            scored = scored + wd;
            score = scored;
        end
    end
    return score
end

---Create a 20x20 grid of floating point score values corresponding to the super-grid
---@return Grid subgrid a 10x10 matrix of floats that correspond the super-grid coordinate (x,y).
function grid.super.get_score_grid()
    local g = {}
    for k = 0, consts.grid.super.width - 1 do
        for j = 0, consts.grid.super.width - 1 do
            if g[j] == nil then
                g[j] = {}
            end
            if g[j][k] == nil then
                g[j][k] = {}
            end
            g[j][k] = grid.sub.score_by_super_coord(j, k)
        end
    end
    return g
end

---Read a 10x10 subgrid from the matrix representation of the main grid by the corresponding super-grid coordinate.
---@param x integer super-grid matrix representation x coordinate.
---@param y integer super-grid matrix representation y coordinate.
---@return Grid subgrid a 10x10 matrix of floats that correspond the super-grid coordinate (x,y).
function grid.sub.read_by_super_coord_transposed(x,y)
    local g = {}
    for k = 0, consts.grid.sub.width - 1 do
        for j = 0, consts.grid.sub.width - 1 do
            if g[k] == nil then
                g[k] = {}
            end
            if g[k][j] == nil then
                g[k][j] = {}
            end
            g[k][j] = grid.main.read_value_by_super_sub_coord(x, y, j, k)
        end
    end
    return g
end

--[[ ********** Tests **********]]
---Unchecked test for several conversion methods
---@param x integer main-grid coordinate x component
---@param y integer main-grid coordinate x component
---@param index integer main-grid array offset
---@param offset integer main-grid memory offset
---@return string results test results in string format
function grid.tests.run_conversions(x, y, index, offset)
    local st = ""
    if x ~= nil and y ~= nil then
        local i1 = grid.main.coord.to_index(x, y)
        local o1 = grid.main.coord.to_offset(x, y)
        local sp = grid.main.coord.to_super_coord(x, y)
        -- local sb = grid.main.coord.to_sub_coord(x, y)
        st = st..string.format("Coord Test (%d, %d):\n", x, y)
        st = st..string.format("  Index:  %d\n", i1)
        -- st = st..string.format("  Sub Coord:  (%d, %d)\n", sbc4.x, sb4.y)
        st = st..string.format("  Sup Coord:  (%d, %d)\n", sp.x, sp.y)
        st = st..string.format("  Offset: 0x%08x\n", o1)
    end
    if index ~= nil then
        local c1 = grid.main.index.to_coord(index)
        local o2 = grid.main.index.to_offset(index)
        local c3 = grid.main.index.to_sub_coord(index)
        local c4 = grid.main.index.to_super_coord(index)
        st = st..string.format("Index Test %d:\n", index)
        st = st..string.format("  Coord:      (%d, %d)\n", c1.x, c1.y)
        st = st..string.format("  Sub Coord:  (%d, %d)\n", c3.x, c3.y)
        st = st..string.format("  Sup Coord:  (%d, %d)\n", c4.x, c4.y)
        st = st..string.format("  Offset:     0x%08x\n", o2)
    end
    if offset ~= nil then
        st = st..string.format("Offset Test 0x%08x:\n", offset)
        local c2 = grid.main.offset.to_coord(offset)
        local i2 = grid.main.offset.to_index(offset)
        local sp1 = grid.main.coord.to_super_coord(x, y)
        st = st..string.format("  Coord:  (%d, %d)\n", c2.x, c2.y)
        st = st..string.format("  Sup Coord:  (%d, %d)\n", sp1.x, sp1.y)
        st = st..string.format("  Index:  %d\n", i2)
    end
    return st
end

---Test for several conversion methods for equlivalant values
---@param x integer known main-grid coordinate x component
---@param y integer known main-grid coordinate x component
---@param index integer known main-grid array offset
---@param offset integer known main-grid memory offset
---@return string results test results in string format
function grid.tests.test_coords(x, y, index, offset)
    local st = string.format("Coord Test (%d, %d):\n", x, y)
    local i1 = grid.main.coord.to_index(x, y)
    local o1 = grid.main.coord.to_offset(x, y)
    st = st..string.format("  Index:  %d", i1)
    if i1 == index then
        st = st.." PASS\n"
    else
        st = st.." FAIL\n"
    end
    st = st..string.format("  Offset: 0x%08x", o1)
    if o1 == offset then
        st = st.." PASS\n"
    else
        st = st.." FAIL\n"
    end

    st = st..string.format("Index Test %d:\n", index)
    local c1 = grid.main.index.to_coord(index)
    local o2 = grid.main.index.to_offset(index)
    st = st..string.format("  Coord:  (%d, %d)", c1.x, c1.y)
    if c1.x == x then
        st = st.." x PASS"
    else
        st = st.." x FAIL"
    end
    if c1.y == y then
        st = st.." y PASS\n"
    else
        st = st.." y FAIL\n"
    end
    st = st..string.format("  Offset: 0x%08x", o2)
    if o2 == offset then
        st = st.." PASS\n"
    else
        st = st.." FAIL\n"
    end

    st = st..string.format("Offset Test 0x%08x:\n", offset)
    local c2 = grid.main.offset.to_coord(offset)
    local i2 = grid.main.offset.to_index(offset)
    st = st..string.format("  Coord:  (%d, %d)", c2.x, c2.y)
    if c2.x == x then
        st = st.." x PASS"
    else
        st = st.." x FAIL"
    end
    if c2.y == y then
        st = st.." y PASS\n"
    else
        st = st.." y FAIL\n"
    end
    st = st..string.format("  Index:  %d", i2)
    if i1 == index then
        st = st.." PASS\n"
    else
        st = st.." FAIL\n"
    end
    return st
end

return grid