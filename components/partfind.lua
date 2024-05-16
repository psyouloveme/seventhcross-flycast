local memory = require("lua.seventhcross.emulator.memory")
local supergrid = require("lua.seventhcross.components.supergrid")
local grid      = require("lua.seventhcross.components.grid")
local GRID_DEF = 0x8c3be40c
local SUPER_GRID_DEF = 0x8c0c72b4

local partfind = {}

local function is_index_in_list(index, coords)
    -- print(string.format("Is Index In List index: %d coords: %s", index, tostring(table.unpack(coords))))
    for i = 0, #coords do
        if coords[i] == index then
            -- print(string.format("Is Index In List end %d %s %s", index, tostring(table.unpack(coords)), tostring(true)))
            return true
        end
    end
    -- print(string.format("Is Index In List end %s", tostring(false)))
    return false
end

-- coords - list if indices, not actual coodinate pairs
local function calculate_score(coord, coords)
    -- print(string.format("Calculate Score: index: %d coords: ", index).. tostring(table.unpack(coords)))
    -- local index = main
    local grid_ptr_cpy = GRID_DEF + (grid.outer_grid.coord_to_index(coord.x, coord.y) * 100 * 4)
    local score = 0
    -- local grid = sg.read_inner_grid(x, y)
    for i = 0, 100 do
        if is_index_in_list(i, coords) then
            local w = 1.0 - memory.readFloat32(grid_ptr_cpy + (i*4))
            local wd = w
            wd = wd * wd
            local scored = score
            scored = scored + wd
            score = scored
        else
            local w = memory.readFloat32(grid_ptr_cpy + (i*4))
            local wd = w
            wd = wd * wd
            local scored = score
            scored = scored + wd
            score = scored
        end
    end
    print(string.format("Calculate Score end score: %.09f", score))
    return score
end

-- search_idx - supergrid index
-- now a coord pair
local function find_simplest(coord, attempts)
    print(string.format("Search for Super Grid: (%d, %d)", coord.x, coord.y))
    local pattern = {}
    local found = false

    -- while(found == false && pattern.size() < attempts) {
    while found == false and #pattern < attempts do
        print(string.format("Attempt %d", #pattern))

        local best_diff_idx = 0
        local best_diff_amount = 400.0

        -- loop over testing a dot
        for draw_grid_idx = 0, 99 do
            table.insert(pattern, draw_grid_idx)
            local search_score = calculate_score(coord.index, pattern)
            local best_idx = 0
            local best_score = 400.0

            -- loop over checking a supergrid idx
            for supergrid_index = 0, 399, 1 do
                if supergrid_index ~= coord.index then
                    local score = calculate_score(supergrid_index, pattern)
                    if score < best_score then
                        best_idx = supergrid_index
                        best_score = score
                    end
                end
            end

            if search_score < best_score then
                found = true
                local coord_str = "Found:"
                for pat_list_idx, pat_grid_index in pairs(pattern) do
                    grid.idx_to_coord(pat_grid_index)
                    local x = (pat_grid_index % 10) + 1
                    local y = math.floor(pat_grid_index / 10) + 1
                    coord_str = coord_str..string.format("  (%d, %d)", x, y)
                end
                print(coord_str)
            end

            if (search_score - best_score) < best_diff_amount then
                best_diff_idx = draw_grid_idx
                best_diff_amount = search_score - best_score
            end
            table.remove(pattern)
        end
        table.insert(pattern, best_diff_idx)
        local c = grid.idx_to_coord(best_diff_idx)
        print(string.format("Attempt %d result: (%d, %d) [%d] : %.09f", #pattern, c.x, c.y, best_diff_idx, best_diff_amount))
    end
end

local function coords_to_index(x, y)
    -- print(string.format("Coords to Index x: %d y: %d", x, y))
    local index = (y * 20) + x
    -- print(string.format("Coords to Index end index: %d", index))
    return index
end

local function get_part_level(index)
    -- print(string.format("Get Part Level index: %d", index))
    local level = memory.read8(SUPER_GRID_DEF + index)
    -- print(string.format("Get Part Level end level: %d", level))
    return level
end

local function find_part(part_type, part_level, attempts)
    print(string.format("Find part: type: %d level: %d attempts: %d", part_type, part_level, attempts))
    local candidates = {}
    local y_min = 0 + ((part_type >> 1) * 10)
    local y_max = 10 + ((part_type >> 1) * 10)
    local x_min = 0 + ((part_type & 1) * 10)
    local x_max = 10 + ((part_type & 1) * 10)

    local part_grid = supergrid.read_part_quadrant(part_type, false)
    for y = y_min, y_max - 1, 1 do
        for x = x_min, x_max - 1, 1 do
            local lvl = part_grid[x][y]
            if (lvl == part_level) then
                -- local coord = supergrid.idx_to_coord(idx)
                local point = {
                    index = supergrid.coord_to_idx(x,y);
                    x = x;
                    y = y;
                }
                table.insert(candidates, point)
                -- print(string.format("%d %d %d ?= %d %d %d", x, y, idx, idx, coord.x, coord.y))
                print(string.format("Candidate: index: %d at supergrid (%d,%d)", point.index, point.x, point.y))
            end
        end
    end
    for key, value in pairs(candidates) do
        print("trying to find simplest", key, value, attempts)
        find_simplest(value, attempts)

        -- print("key ", key)
        -- print("value", value)
    end
    -- print(string.format("candidates: %s, length: %d", table_to_string(candidates), #candidates))
    -- for it = 0, #candidates do
        -- find_simplest(candidates[it], attempts)
    -- end
end


-- 1.
-- example coords_list = {1, 1, 2, 1}
function partfind.do_function_f(ptype, plevel, a)
    print(string.format("Start find part type: %d level: %d attempts: %d", ptype, plevel, a))
    local cleaned_aval = 20
    if a ~= nil then
        cleaned_aval = a
    end
    find_part(ptype, plevel, cleaned_aval)
    print(string.format("End   find part type: %d level: %d attempts: %d", ptype, plevel, a))
end

return partfind