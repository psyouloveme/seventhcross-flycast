local constants = require "lua.seventhcross.constants"
local mem = require "lua.seventhcross.emulator.memory"

local StatGroups = {}
table.insert(StatGroups, {
  type = constants.types.UShort;
  label = "HP Current";
  id = 15;
  address = 0x8c1e19de;
  history = {};
  track = true;
  edit = true;
});
table.insert(StatGroups, {
  type = constants.types.UShort;
  label = "HP";
  id = 0;
  address = 0x8c1e19e2;
  history = {};
  track = true;
  edit = true;
});
table.insert(StatGroups, {
  type = constants.types.UShort;
  label = "EP Current";
  id = 16;
  address = 0x8c1e19e0;
  history = {};
  track = true;
  edit = true;
});
table.insert(StatGroups, {
  type = constants.types.UShort;
  label = "EP";
  id = 1;
  address = 0x8c1e19e4;
  history = {};
  track = true;
  edit = true;
});
table.insert(StatGroups, {
  type = constants.types.UShort;
  label = "EVP";
  id = 2;
  address = 0x8c1e19ec;
  history = {};
  track = true;
  edit = true;
});
table.insert(StatGroups, {
  type = constants.types.UShort;
  label = "Attack";
  id = 3;
  address = 0x8c1e19f4;
  history = {};
  track = true;
  edit = true;
});
table.insert(StatGroups, {
  type = constants.types.UShort;
  label = "EXAttack";
  id = 4;
  address = 0x8c1e19f6;
  history = {};
  track = true;
  edit = true;
});
table.insert(StatGroups, {
  type = constants.types.UShort;
  label = "Defense";
  id = 5;
  address = 0x8c1e19f8;
  history = {};
  track = true;
  edit = true;
});
table.insert(StatGroups, {
  type = constants.types.UShort;
  label = "Intelligence";
  id = 6;
  address = 0x8c1e19fa;
  history = {};
  track = true;
  edit = true;
});
table.insert(StatGroups, {
  type = constants.types.UShort;
  label = "Healing";
  id = 7;
  address = 0x8c1e19fc;
  history = {};
  track = true;
  edit = true;
});
table.insert(StatGroups, {
  type = constants.types.UShort;
  label = "Dextarity";
  id = 8;
  address = 0x8c1e19fe;
  history = {};
  track = true;
  edit = true;
});
table.insert(StatGroups, {
  type = constants.types.UShort;
  label = "Water";
  id = 9;
  address = 0x8c1e1a00;
  history = {};
  track = true;
  edit = true;
});
table.insert(StatGroups, {
  type = constants.types.UShort;
  label = "Protein";
  id = 10;
  address = 0x8c1e1a02;
  history = {};
  track = true;
  edit = true;
});
table.insert(StatGroups, {
  type = constants.types.UShort;
  label = "Calcium";
  id = 11;
  address = 0x8c1e1a04;
  history = {};
  track = true;
  edit = true;
});
table.insert(StatGroups, {
  type = constants.types.UShort;
  label = "Fiber";
  id = 12;
  address = 0x8c1e1a06;
  history = {};
  track = true;
  edit = true;
});
table.insert(StatGroups, {
  type = constants.types.UShort;
  label = "Hard Cell";
  id = 13;
  address = 0x8c1e1a08;
  history = {};
  track = true;
  edit = true;
});
table.insert(StatGroups, {
  type = constants.types.UShort;
  label = "Neuro-Bio";
  id = 14;
  address = 0x8c1e1a0a;
  history = {};
  track = true;
  edit = true;
});
table.insert(StatGroups, {
  type = constants.types.Float;
  label = "EnemyFloatOne";
  id = 15;
  address = 0x8c33afe4;
  history = {};
  track = false;
  edit = false;
})
table.insert(StatGroups, {
  type = constants.types.Float;
  label = "EnemyFloatTwo";
  id = 16;
  address = 0x8c33afe8;
  history = {};
  track = false;
  edit = false;
})
table.insert(StatGroups, {
  type = constants.types.Float;
  label = "EnemyFloatThree";
  id = 17;
  address = 0x8c33afec;
  history = {};
  track = false;
  edit = false;
})
table.insert(StatGroups, {
  type = constants.types.Short;
  label = "EnemyShortOne";
  id = 18;
  address = 0x8c33aff0;
  history = {};
  track = false;
  edit = false;
})

local selected_stat = nil;
local old_value = nil;
local new_value = nil;

local stat_log = {};

local stat_display_x = 0;
local stat_display_width = 140;
local stat_changes_x = stat_display_x + stat_display_width;
local stat_changes_width = 200;
local stat_changes_height = 456;
local stat_select_x = stat_changes_x + stat_changes_width;
local stat_select_width = 110;
local stat_edit_x = stat_select_x + stat_select_width;
local stat_edit_width = 145;

local function build_stat_editor()
  local ui = flycast.ui
  local memory = flycast.memory
  if selected_stat ~= nil then
    old_value = mem.read16(selected_stat.address)
    if new_value == nil then
      new_value = old_value
    end
    ui.beginWindow("Edit Stat", stat_edit_x, 0, stat_edit_width, 0);
    ui.text(string.format("%s", selected_stat.label))
    ui.text("Current Value:")
    ui.rightText(string.format("%d", old_value))
    ui.text("New Value:")
    ui.rightText(string.format("%d", new_value))
    ui.button("+1", function()
      if new_value < 999 then
        new_value = new_value + 1
      end
    end)
    ui.button("-1", function()
      if (new_value > 0) then
        new_value = new_value - 1
      end
    end)
    ui.button("+10", function()
      if (new_value + 10) <= 999 then
        new_value = new_value + 10
      end
    end)
    ui.button("-10", function()
      if (new_value - 10) >= 0 then
        new_value = new_value - 10
      end
    end)
    ui.button("+100", function()
      if (new_value + 100) <= 999 then
        new_value = new_value + 100
      end
    end)
    ui.button("-100", function()
      if (new_value - 100) >= 0 then
        new_value = new_value - 100
      end
    end)
    ui.button("Set", function ()
      if new_value ~= nil and new_value ~= old_value then
        memory.write16(selected_stat.address, new_value);
      end
    end)
    ui.button("End", function ()
      selected_stat = nil;
      new_value = nil;
      old_value = nil;
    end)
    ui.endWindow();
  end
end;

local function select_stat(stat)
  selected_stat = stat;
  old_value = nil;
  new_value = nil;
end;

local function build_stat_button(stat)
  local ui = flycast.ui
  if selected_stat ~= nil and stat.id == selected_stat.id then
    ui.button(string.format("%s %s", stat.label, "X"), function()
      select_stat(stat)
    end)
  else
    ui.button(stat.label, function()
      select_stat(stat)
    end)
  end
end

local function build_stat_text(index)
  local stat = StatGroups[index]
  flycast.ui.text(stat.label)
  local val = mem.read16(stat.address)
  if stat.track then
    if #stat.history > 0 then
      local old_val = stat.history[#stat.history]
      if old_val ~= val then
        table.insert(stat.history, val)
        table.insert(stat_log, { stat = stat.label, value = val - old_val })
      end
    else
      table.insert(stat.history, val)
      -- table.insert(stat_log, { stat = stat.label, value = val })
    end
  end
  flycast.ui.rightText(val)
end

local function build_stat_selector()
  local ui = flycast.ui
  ui.beginWindow("Select", stat_select_x, 0, stat_select_width, 0);
  for i, v in ipairs(StatGroups) do
    if v.edit then
      build_stat_button(v)
    end
  end
  ui.endWindow();
end;

local function log_stat_text(index, val)
  if val.value > 0 then
    flycast.ui.text(string.format("%05d: %s +%d", index, val.stat, val.value))
  else
    flycast.ui.text(string.format("%05d: %s %d", index, val.stat, val.value))
  end
end;

local function build_stat_change_display()
  local ui = flycast.ui
  ui.beginWindow("Changes", stat_changes_x, 0, stat_changes_width, stat_changes_height);
  for i = #stat_log, 1, -1 do
    log_stat_text(i, stat_log[i])
  end
  ui.endWindow();
end;

local function build_stat_display()
  local ui = flycast.ui
  ui.beginWindow("Stats", stat_display_x, 0, stat_display_width, 0);
  for i, v in ipairs(StatGroups) do
    build_stat_text(i)
  end
  ui.endWindow();
end;

local function build_stat_edit_windows()
  build_stat_display()
  build_stat_selector()
  build_stat_editor()
  build_stat_change_display()
end

return build_stat_edit_windows