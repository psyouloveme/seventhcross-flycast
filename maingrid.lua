local consts = require("lua.seventhcross.constants")

local grid = {
    height = 200;
    width = 200;
    start_address = consts.addrs.MainGrid;
    value_size = consts.sizeof.float;
    subgrid_width = 10;
    supergrid_width = 20;
};

function grid.index_to_subgrid_coord(index)
    local coord = {}
    coord.x = (index % grid.width) % grid.subgrid_width
    coord.y = math.floor(index / grid.width) % grid.subgrid_width
    return coord
end

function grid.index_to_supergrid_coord(index)
    local coord = {}
    coord.x = (index % grid.width) % grid.supergrid_width
    coord.y = math.floor(math.floor(index / grid.width) / grid.supergrid_width)
    return coord
end

-- PASS
function grid.index_to_coord(index)
    local coord = {}
    coord.x = index % grid.width
    coord.y = math.floor(index / grid.height)
    return coord
end

-- PASS
function grid.index_to_offset(index)
    return (index * grid.value_size)  + grid.start_address
end

-- PASS
function grid.coord_to_index(x, y)
    return (y * grid.width) + x
end

-- PASS
function grid.coord_to_offset(x, y)
    return (((y * grid.width) + x) * grid.value_size) + grid.start_address
end

-- PASS
function grid.offset_to_index(offset)
    return (offset - grid.start_address) / grid.value_size
end

-- PASS
function grid.offset_to_coord(offset)
    local coord = {}
    coord.x = math.floor((offset - grid.start_address) / grid.value_size) % grid.width
    coord.y = math.floor(((offset - grid.start_address) / grid.value_size) / grid.width)
    return coord
end

function grid.run_conversions(x, y, index, offset)
    local st = ""
    if x ~= nil and y ~= nil then
        local i1 = grid.coord_to_index(x, y)
        local o1 = grid.coord_to_offset(x, y)
        st = st..string.format("Coord Test (%d, %d):\n", x, y)
        st = st..string.format("  Index:  %d\n", i1)
        st = st..string.format("  Offset: 0x%08x\n", o1)
    end
    if index ~= nil then
        local c1 = grid.index_to_coord(index)
        local o2 = grid.index_to_offset(index)
        local c3 = grid.index_to_subgrid_coord(index)
        local c4 = grid.index_to_supergrid_coord(index)
        st = st..string.format("Index Test %d:\n", index)
        st = st..string.format("  Coord:      (%d, %d)\n", c1.x, c1.y)
        st = st..string.format("  Sub Coord:  (%d, %d)\n", c3.x, c3.y)
        st = st..string.format("  Sup Coord:  (%d, %d)\n", c4.x, c4.y)
        st = st..string.format("  Offset:     0x%08x\n", o2)
    end
    if offset ~= nil then
        st = st..string.format("Offset Test 0x%08x:\n", offset)
        local c2 = grid.offset_to_coord(offset)
        local i2 = grid.offset_to_index(offset)
        st = st..string.format("  Coord:  (%d, %d)\n", c2.x, c2.y)
        st = st..string.format("  Index:  %d\n", i2)
    end
    return st
end

function grid.test_coords(x, y, index, offset)
    local st = string.format("Coord Test (%d, %d):\n", x, y)
    local i1 = grid.coord_to_index(x, y)
    local o1 = grid.coord_to_offset(x, y)
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
    local c1 = grid.index_to_coord(index)
    local o2 = grid.index_to_offset(index)
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
    local c2 = grid.offset_to_coord(offset)
    local i2 = grid.offset_to_index(offset)
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