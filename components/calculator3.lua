local consts = require "lua.seventhcross.constants"
local grid = require "lua.seventhcross.components.maingrid"
local logger = require "lua.seventhcross.components.log"
local calc = {}


function calc.find_simplest(coord, attempts)
    local pattern = {}
    local found = false
    while found == false and #pattern < attempts do
        local best_diff_index = 0;
        local best_diff_coord = {};
        local best_diff_amount = 400.0;
        -- loop over points on the 10x10 game grid
        for y2 = 0, consts.grid.sub.height - 1, 1 do
            for x2 = 0, consts.grid.sub.width - 1, 1 do
                table.insert(pattern, { x = x2; y = y2; })
                local search_score = grid.sub.score_by_super_coord_pattern(x2, y2, pattern)
                local best_coord = {}
                local best_score = 400.0
                -- print(string.format("Grid (%d, %d) -> %0.9f", x2, y2, search_score))
                -- loop over points on the 20x20 super grid
                for y1 = 0, consts.grid.super.height - 1, 1 do
                    for x1 = 0, consts.grid.super.width - 1, 1 do
                        if x1 ~= coord.x and y1 ~= coord.y then
                            local score = grid.sub.score_by_super_coord_pattern(x1, y1, pattern)
                            if score < best_score then
                                best_coord = { x = x1; y = y1; };
                                best_score = score;
                            end
                        end
                    end
                end
                if search_score < best_score then
                    found = true
                    local pat_str = "Found:"
                    for k, v in pairs(pattern) do
                        pat_str = pat_str..string.format(" (%d, %d)", v.x, v.y)
                    end
                    print(pat_str)
                else
                    print(string.format("Search score %0.9f did't beat %0.9f", best_score, search_score))
                end
                if ((search_score - best_score) < best_diff_amount) then
                    best_diff_coord = { x = x2; y = y2; }
                    best_diff_index = grid.super.coord.to_index(x2, y2)
                    best_diff_amount = search_score - best_score;
                end
                table.remove(pattern)
            end
        end
        table.insert(pattern, best_diff_coord)
    end
end;

---Find a part
---@param part_type PartType
---@param part_level integer
---@param attempts integer
function calc.find_part(part_type, part_level, attempts)
    local candidates = grid.super.find_coords_by_value(part_type, part_level)
    local results = {}
    print(string.format("Part Type: %s, Part Level: %d, Attempts: %d", consts.get_part_string(part_type), part_level, attempts))
    for key, value in pairs(candidates) do
        print(string.format("Candidate: (%d, %d)", value.x, value.y))
        calc.find_simplest(value, attempts)
    end
    print("Done!")
end;

return calc