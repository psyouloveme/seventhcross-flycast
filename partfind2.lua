local memory = require("lua.seventhcross.memory")
local supergrid = require("lua.seventhcross.supergrid")
local grid      = require("lua.seventhcross.grid")
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
    print(string.format("Calculate Score: index: %d coords: ", index).. tostring(table.unpack(coords)))
    local grid_ptr_cpy = GRID_DEF + (index * 100 * 4)
    local score = 0
    -- local grid = sg.read_inner_grid(x, y)
    local coord = grid.idx_to_coord(index)
    for y = 0, #grid do
        for x = 0, #grid[y] do
            
        end
    end
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
local function find_simplest(search_idx, attempts)
    -- std::cout << "Searching for sg idx: " << search_idx << "\n";
    print(string.format("Search for sg idx: %d", search_idx))

    -- std::vector<int> pattern;
    local pattern = {}
    -- bool found = false;
    local found = false

    -- while(found == false && pattern.size() < attempts) {
    while found == false and #pattern < attempts do
        print(string.format("Attempt %d", #pattern))

        -- int best_diff_idx = 0;
        local best_diff_idx = 0

        -- float best_diff_amount = 400.f;
        local best_diff_amount = 400.0


        -- loop over testing a dot
        -- for(int i = 0; i < 100; i++) { // loop over testing a dot
        -- for i = 0, 100 do
        for i = 0, 2 do

            -- pattern.push_back(i);
            table.insert(pattern, i)

            -- float search_score = calculate_score(search_idx, pattern);
            local search_score = calculate_score(coord, pattern)

            -- int best_idx = 0;
            local best_idx = 0

            -- float best_score = 400.f;
            local best_score = 400.0


            -- loop over checking a supergrid idx
            -- for(int j = 0; j < 400; j++) { // loop over checking a supergrid idx
            -- for j = 0, 399, 1 do
            for j = 0, 2, 1 do
                -- print('j=',j)

                -- if(j != search_idx) {
                if j ~= search_idx then

                    -- float score = calculate_score(j, pattern);
                    local score = calculate_score(j, pattern)

                    -- if(score < best_score) {
                    if score < best_score then

                        -- best_idx = j;
                        best_idx = j

                        -- best_score = score;
                        best_score = score
                    end
                end
            end

            -- if(search_score < best_score) {
            if search_score < best_score then

                -- found = true;
                found = true

                -- std::cout << "Found: ";
                print("Found: ")
                
                -- for(int j = 0; j < pattern.size(); j++) {
                    -- for i, val in ipairs(pattern) do
                for it = 0, #pattern do

                    -- int p = pattern.at(j);
                    local p = pattern[it]

                    -- int x = (p % 10) + 1;
                    local x = (p % 10) + 1

                    -- int y = (p / 10) + 1;
                    local y = (p / 10) + 1

                    -- std::cout << "(" << x << ", " << y << ") ";
                    print(string.format("(%d, %d)", x, y))
                end
            end

            -- if((search_score - best_score) < best_diff_amount) {
            if (search_score - best_score) < best_diff_amount then

                -- best_diff_idx = i;
                best_diff_idx = i

                -- best_diff_amount = search_score - best_score;
                best_diff_amount = search_score - best_score
            end

            -- pattern.pop_back();
            table.remove(pattern)
        end
        -- pattern.push_back(best_diff_idx);
        table.insert(pattern, best_diff_idx)
        print(string.format("Attempt %d result: %d : %.09f", #pattern, best_diff_idx, best_diff_amount))
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
    -- print(string.format("Find part: type: %d level: %d attempts: %d", part_type, part_level, attempts))
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
                local idx = supergrid.coord_to_idx(x,y)
                local coord = supergrid.idx_to_coord(idx)
                table.insert(candidates, {x = x, y = y})
                -- print(string.format("%d %d %d ?= %d %d %d", x, y, idx, idx, coord.x, coord.y))
                print(string.format("Candidate: index: %d at supergrid (%d,%d)", supergrid.coord_to_idx(x,y), x, y))
            end
        end
    end
    -- print(string.format("candidates: %s, length: %d", table_to_string(candidates), #candidates))
    for it = 0, #candidates do
        print("trying to find simplest", candidates[it], attempts)
        find_simplest(candidates[it], attempts)
    end
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