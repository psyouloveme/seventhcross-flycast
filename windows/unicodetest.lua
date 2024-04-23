local function build_unicode_window()
    local ui = flycast.ui
    ui.beginWindow("UnicodeTest", 0, 0, 600, 600)
    ui.text("string.char")
    local st = ""
    for i = 0, 255 do
        if i == 0 then
            st = "'"..string.char(i).."'"
        elseif i > 1 and i % 16 == 0 then
            st = st.." '"..string.char(i).."'\n"
            ui.text(st)
            st = ""
        else 
            st = st.." '"..string.char(i).."'"
        end
    end
    ui.text("unicode")
    st = st.."'\x00'"
    st = st.." '\x01'"
    st = st.." '\x02'"
    st = st.." '\x03'"
    st = st.." '\x04'"
    st = st.." '\x05'"
    st = st.." '\x06'"
    st = st.." '\x07'"
    st = st.." '\x08'"
    st = st.." '\x09'"
    st = st.." '\x0A'"
    st = st.." '\x0B'"
    st = st.." '\x0C'"
    st = st.." '\x0D'"
    st = st.." '\x0E'"
    st = st.." '\x0F'\n"
    ui.text(st)
    st = ""
    st = st.. "'\x10'"
    st = st.." '\x11'"
    st = st.." '\x12'"
    st = st.." '\x13'"
    st = st.." '\x14'"
    st = st.." '\x15'"
    st = st.." '\x16'"
    st = st.." '\x17'"
    st = st.." '\x18'"
    st = st.." '\x19'"
    st = st.." '\x1A'"
    st = st.." '\x1B'"
    st = st.." '\x1C'"
    st = st.." '\x1D'"
    st = st.." '\x1E'"
    st = st.." '\x1F'\n"
    ui.text(st)
    st = ""
    st = st.. "'\x20'"
    st = st.." '\x21'"
    st = st.." '\x22'"
    st = st.." '\x23'"
    st = st.." '\x24'"
    st = st.." '\x25'"
    st = st.." '\x26'"
    st = st.." '\x27'"
    st = st.." '\x28'"
    st = st.." '\x29'"
    st = st.." '\x2A'"
    st = st.." '\x2B'"
    st = st.." '\x2C'"
    st = st.." '\x2D'"
    st = st.." '\x2E'"
    st = st.." '\x2F'\n"
    ui.text(st)
    st = ""
    st = st.. "'\x30'"
    st = st.." '\x31'"
    st = st.." '\x32'"
    st = st.." '\x33'"
    st = st.." '\x34'"
    st = st.." '\x35'"
    st = st.." '\x36'"
    st = st.." '\x37'"
    st = st.." '\x38'"
    st = st.." '\x39'"
    st = st.." '\x3A'"
    st = st.." '\x3B'"
    st = st.." '\x3C'"
    st = st.." '\x3D'"
    st = st.." '\x3E'"
    st = st.." '\x3F'\n"
    ui.text(st)
    st = ""
    st = st.. "'\x40'"
    st = st.." '\x41'"
    st = st.." '\x42'"
    st = st.." '\x43'"
    st = st.." '\x44'"
    st = st.." '\x45'"
    st = st.." '\x46'"
    st = st.." '\x47'"
    st = st.." '\x48'"
    st = st.." '\x49'"
    st = st.." '\x4A'"
    st = st.." '\x4B'"
    st = st.." '\x4C'"
    st = st.." '\x4D'"
    st = st.." '\x4E'"
    st = st.." '\x4F'\n"
    ui.text(st)
    st = ""
    st = st.. "'\x50'"
    st = st.." '\x51'"
    st = st.." '\x52'"
    st = st.." '\x53'"
    st = st.." '\x54'"
    st = st.." '\x55'"
    st = st.." '\x56'"
    st = st.." '\x57'"
    st = st.." '\x58'"
    st = st.." '\x59'"
    st = st.." '\x5A'"
    st = st.." '\x5B'"
    st = st.." '\x5C'"
    st = st.." '\x5D'"
    st = st.." '\x5E'"
    st = st.." '\x5F'\n"
    ui.text(st)
    st = ""
    st = st.. "'\x60'"
    st = st.." '\x61'"
    st = st.." '\x62'"
    st = st.." '\x63'"
    st = st.." '\x64'"
    st = st.." '\x65'"
    st = st.." '\x66'"
    st = st.." '\x67'"
    st = st.." '\x68'"
    st = st.." '\x69'"
    st = st.." '\x6A'"
    st = st.." '\x6B'"
    st = st.." '\x6C'"
    st = st.." '\x6D'"
    st = st.." '\x6E'"
    st = st.." '\x6F'\n"
    ui.text(st)
    st = ""
    st = st.. "'\x70'"
    st = st.." '\x71'"
    st = st.." '\x72'"
    st = st.." '\x73'"
    st = st.." '\x74'"
    st = st.." '\x75'"
    st = st.." '\x76'"
    st = st.." '\x77'"
    st = st.." '\x78'"
    st = st.." '\x79'"
    st = st.." '\x7A'"
    st = st.." '\x7B'"
    st = st.." '\x7C'"
    st = st.." '\x7D'"
    st = st.." '\x7E'"
    st = st.." '\x7F'\n"
    ui.text(st)
    st = ""
    st = st.. "'\x80'"
    st = st.." '\x81'"
    st = st.." '\x82'"
    st = st.." '\x83'"
    st = st.." '\x84'"
    st = st.." '\x85'"
    st = st.." '\x86'"
    st = st.." '\x87'"
    st = st.." '\x88'"
    st = st.." '\x89'"
    st = st.." '\x8A'"
    st = st.." '\x8B'"
    st = st.." '\x8C'"
    st = st.." '\x8D'"
    st = st.." '\x8E'"
    st = st.." '\x8F'\n"
    ui.text(st)
    st = ""
    st = st.. "'\x90'"
    st = st.." '\x91'"
    st = st.." '\x92'"
    st = st.." '\x93'"
    st = st.." '\x94'"
    st = st.." '\x95'"
    st = st.." '\x96'"
    st = st.." '\x97'"
    st = st.." '\x98'"
    st = st.." '\x99'"
    st = st.." '\x9A'"
    st = st.." '\x9B'"
    st = st.." '\x9C'"
    st = st.." '\x9D'"
    st = st.." '\x9E'"
    st = st.." '\x9F'\n"
    ui.text(st)
    st = ""
    st = st.. "'\xA0'"
    st = st.." '\xA1'"
    st = st.." '\xA2'"
    st = st.." '\xA3'"
    st = st.." '\xA4'"
    st = st.." '\xA5'"
    st = st.." '\xA6'"
    st = st.." '\xA7'"
    st = st.." '\xA8'"
    st = st.." '\xA9'"
    st = st.." '\xAA'"
    st = st.." '\xAB'"
    st = st.." '\xAC'"
    st = st.." '\xAD'"
    st = st.." '\xAE'"
    st = st.." '\xAF'\n"
    ui.text(st)
    st = ""
    st = st.. "'\xB0'"
    st = st.." '\xB1'"
    st = st.." '\xB2'"
    st = st.." '\xB3'"
    st = st.." '\xB4'"
    st = st.." '\xB5'"
    st = st.." '\xB6'"
    st = st.." '\xB7'"
    st = st.." '\xB8'"
    st = st.." '\xB9'"
    st = st.." '\xBA'"
    st = st.." '\xBB'"
    st = st.." '\xBC'"
    st = st.." '\xBD'"
    st = st.." '\xBE'"
    st = st.." '\xBF'\n"
    ui.text(st)
    st = ""
    st = st.. "'\xC0'"
    st = st.." '\xC1'"
    st = st.." '\xC2'"
    st = st.." '\xC3'"
    st = st.." '\xC4'"
    st = st.." '\xC5'"
    st = st.." '\xC6'"
    st = st.." '\xC7'"
    st = st.." '\xC8'"
    st = st.." '\xC9'"
    st = st.." '\xCA'"
    st = st.." '\xCB'"
    st = st.." '\xCC'"
    st = st.." '\xCD'"
    st = st.." '\xCE'"
    st = st.." '\xCF'\n"
    ui.text(st)
    st = ""
    st = st.. "'\xD0'"
    st = st.." '\xD1'"
    st = st.." '\xD2'"
    st = st.." '\xD3'"
    st = st.." '\xD4'"
    st = st.." '\xD5'"
    st = st.." '\xD6'"
    st = st.." '\xD7'"
    st = st.." '\xD8'"
    st = st.." '\xD9'"
    st = st.." '\xDA'"
    st = st.." '\xDB'"
    st = st.." '\xDC'"
    st = st.." '\xDD'"
    st = st.." '\xDE'"
    st = st.." '\xDF'\n"
    ui.text(st)
    st = ""
    st = st.. "'\xE0'"
    st = st.." '\xE1'"
    st = st.." '\xE2'"
    st = st.." '\xE3'"
    st = st.." '\xE4'"
    st = st.." '\xE5'"
    st = st.." '\xE6'"
    st = st.." '\xE7'"
    st = st.." '\xE8'"
    st = st.." '\xE9'"
    st = st.." '\xEA'"
    st = st.." '\xEB'"
    st = st.." '\xEC'"
    st = st.." '\xED'"
    st = st.." '\xEE'"
    st = st.." '\xEF'\n"
    ui.text(st)
    st = ""
    st = st.. "'\xF0'"
    st = st.." '\xF1'"
    st = st.." '\xF2'"
    st = st.." '\xF3'"
    st = st.." '\xF4'"
    st = st.." '\xF5'"
    st = st.." '\xF6'"
    st = st.." '\xF7'"
    st = st.." '\xF8'"
    st = st.." '\xF9'"
    st = st.." '\xFA'"
    st = st.." '\xFB'"
    st = st.." '\xFC'"
    st = st.." '\xFD'"
    st = st.." '\xFE'"
    st = st.." '\xFF'"
    ui.text(st)
    ui.endWindow()
end
return build_unicode_window