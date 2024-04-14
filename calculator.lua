local memory = require("lua.seventhcross.memory")
local GRID_DEF = 0x8c3be40c
local SUPER_GRID_DEF = 0x8c0c72b4

local calc = {}

calc.PART_TYPE_HEAD = 0
calc.PART_TYPE_BODY = 1
calc.PART_TYPE_ARM  = 2
calc.PART_TYPE_LEG  = 3

local function table_to_string(tab)
    return tostring(table.unpack(tab))
end

function calc.calculate_score(index, coords)
    -- print(string.format("Calculate Score: index: %d coords: ", index)..table_to_string(coords))
    local grid_ptr_cpy = GRID_DEF + (index * 100 * 4)
    local score = 0
    for i = 0, 100, 1 do
        if calc.is_index_in_list(i, coords) then
            local w = 1.0 - memory.read32_dumb_str5(grid_ptr_cpy + (i*4))
            local wd = w
            wd = wd * wd
            local scored = score
            scored = scored + wd
            score = scored
        else
            local w = memory.read32_dumb_str5(grid_ptr_cpy + (i*4))
            local wd = w
            wd = wd * wd
            local scored = score
            scored = scored + wd
            score = scored
        end
    end
    -- print(string.format("Calculate Score end score: %f", score))
    return score
end

-- if score < best_score // just <, not <=
function calc.calculate_part(coords)
    -- print(string.format("Calculate Part: coords: ", coords))
    local best_idx = 0
    local best_score = 400.0
    for i = 0, 400, 1 do
        local score = calc.calculate_score(i, coords)
        if score < best_score then
            best_idx = i
            best_score = score
            print(string.format("Calculate Part new best - idx: %d score: %f", best_idx, best_score))
        end
    end
    -- print(string.format("Calculate Part end best_idx: %d best_score %f", best_idx, best_score))
    return table.pack(best_idx, best_score)
end

function calc.index_to_coords(index)
    -- print(string.format("Index to Coords index: %d", index))
    local coords = table.pack(index % 20, index / 20)
    -- print(string.format("Index to Coords end coords: %s", table_to_string(coords)))
    return coords
end


function calc.get_part_type(index)
    -- print(string.format("Get Part Type index: %d", index))
    local x = index % 20
    local y = index / 20
    local result
    if y < 10 then
        if x < 10 then
            result = calc.PART_TYPE_HEAD
        else
            result = calc.PART_TYPE_BODY
        end
    else
        if x < 10 then
            result = calc.PART_TYPE_ARM
        else
            result = calc.PART_TYPE_LEG
        end
    end
    -- print(string.format("Get Part Type end result: %d", result))
    return result
end

function calc.is_index_in_list(index, coords)
    -- print(string.format("Is Index In List index: %d coords: %s", index, table_to_string(coords)))
    for k, v in pairs(coords) do
        if k == index then
            -- print(string.format("Is Index In List end %d %s %s", index, table_to_string(coords), tostring(true)))
            return true
        end
    end
    -- print(string.format("Is Index In List end %s", tostring(false)))
    return false
end


-- example coords_list = {1, 1, 2, 1}
function calc.do_function_t(coords_list)
    print(string.format("Running function t coords_list: %s", table_to_string(coords_list)))
    local coords = {}

    -- copy the list of coordinates
    -- into a vector
    for coord in coords_list do
        table.insert(coords, coord - 1)
    end
    -- remove any trailing numbers (indended for console input)
    if (#coords % 1) == 1 then
        table.remove(coords)
    end

    local indices = {}
    -- create an index vector
    -- this may need to be #coords - 1
    for idx_it = 0, #coords, 2 do
        local idx = coords[idx_it] + (coords[idx_it + 1] * 10)
        table.insert(indices, idx)
    end
    
    local index, score = table.unpack(calc.calculate_part(indices))
    local ptype = calc.get_part_type(index)
    local plevel = calc.get_part_level(index)

    print(string.format("Found: idx: %d type: %d level: %d score: %f"), index, ptype, plevel, score)
end

-- example coords_list = {1, 1, 2, 1}
function calc.do_function_s(index, coords_list)
    print("Running function score index: %d coords_list: %s", index, table_to_string(coords_list))
    local coords = {}

    -- copy the list of coordinates
    -- into a vector
    for coord in coords_list do
        table.insert(coords, coord - 1)
    end

    -- remove any trailing numbers (indended for console input)
    if (#coords % 1) == 1 then
        table.remove(coords)
    end

    -- create an index vector
    local indices = {}
    -- this may need to be #coords - 1
    for idx_it = 0, #coords - 1, 2 do
        local idx = coords[idx_it] + (coords[idx_it + 1] * 10)
        table.insert(indices, idx)
    end
    local score = calc.calculate_score(index, indices)
    print(string.format("Score: %f"), score)
end





function calc.find_simplest(search_idx, attempts)
    print(string.format("Search for sg idx: %d", search_idx))
    local pattern = {}
    local found = false
    while found ~= true and #pattern < attempts do
        local best_diff_idx = 0
        local best_diff_amount = 400.0
        -- loop over testing a dot
        for i = 0, 100, 1 do
            table.insert(pattern, i)
            local search_score = calc.calculate_score(search_idx, pattern)
            local best_idx = 0
            local best_score = 400.0
            -- loop over checking a supergrid idx
            for j = 0, 400, 1 do
                if j ~= search_idx then
                    local score = calc.calculate_score(j, pattern)
                    if score < best_score then
                        best_idx = j
                        best_score = score
                    end
                end
            end
            if search_score < best_score then
                found = true
                print("Found: ")
                for j = 0, #pattern - 1, 1 do
                    local p = pattern[j]
                    local x = (p % 10) + 1
                    local y = (p / 10) + 1
                    print(string.format("(%d, %d)", x, y))
                end
            end
            if (search_score - best_score) < best_diff_amount then
                best_diff_idx = i
                best_diff_amount = search_score - best_score
            end
            table.remove(pattern)
        end
        table.insert(pattern, best_diff_idx)
    end
end

function calc.coords_to_index(x, y)
    -- print(string.format("Coords to Index x: %d y: %d", x, y))
    local index = (y * 20) + x
    -- print(string.format("Coords to Index end index: %d", index))
    return index
end

function calc.get_part_level(index)
    -- print(string.format("Get Part Level index: %d", index))
    local level = memory.read8(SUPER_GRID_DEF + index)
    -- print(string.format("Get Part Level end level: %d", level))
    return level
end


function calc.find_part(part_type, part_level, attempts)
    -- print(string.format("Find part: type: %d level: %d attempts: %d", part_type, part_level, attempts))
    local candidates = {}
    local part_y = ((part_type >> 1) * 10)
    for y = 0 + part_y, part_y, 1 do
        local part_x = ((part_type & 1) * 10)
        for x = 0 + part_x, 10  + part_x, 1 do
            local i = (y * 20) + x
            if (calc.get_part_level(i) == part_level) then
                table.insert(candidates, i)
                print(string.format("Candidate: index: %d at supergrid (%d,%d)", calc.coords_to_index(x, y), x, y))
            end
        end
    end
    -- print(string.format("candidates: %s, length: %d", table_to_string(candidates), #candidates))
    for k,v in pairs(candidates) do
        -- print("trying to find simplest", v, attempts)
        calc.find_simplest(v, attempts)
    end
end

-- example coords_list = {1, 1, 2, 1}
function calc.do_function_f(ptype, plevel, a)
    print(string.format("Running function find part type: %d level: %d attempts: %d", ptype, plevel, a))
    local cleaned_aval = 20
    if a ~= nil then
        cleaned_aval = a
    end
    calc.find_part(ptype, plevel, cleaned_aval)
end

-- example coords_list = {1, 1, 2, 1}
function calc.do_function_f2(ptype, plevel, a)
    print(string.format("Running function find part 2 type: %d level: %d attempts: %d", ptype, plevel, a))
        local cleaned_aval = 20
    if a ~= nil then
        cleaned_aval = a
    end
    calc.find_part_alt(ptype, plevel, cleaned_aval)
end


return calc