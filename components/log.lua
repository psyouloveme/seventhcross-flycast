local List = require "lua.seventhcross.components.list"
local logger = {}

---@class LogState
local log_state = {
  ---@type List
  log = List.new();
  limit = 1000;
}

---@enum LogActionType
local actions = {
  Init = 0;
  Append = 1;
  Clear = 2;
};

---@class LogAction
---@field type LogActionType
---@field payload? any

---Log reducer
---@param state LogState log state to update
---@param action LogAction action to take
---@return LogState next_state the next state
local function reducer(state, action)
  print("aabaaasdgfdgdgdaaaaa")

  local next_state = {}
  for k, v in pairs(state) do
    next_state[k] = v
  end
  if action.type == actions.Init then
    if action.payload ~= nil then
      next_state.limit = action.payload
    end
    next_state.log = List.new()
  elseif action.type == actions.Clear then
    next_state.log = List.new()
  elseif action.type == actions.Append then
    if action.payload ~= nil then
  print("aabahdahdahdaasdgfdgdgdaaaaa")
      if #state.log >= state.limit then
        List.popleft(next_state.log)
      end
      List.pushright(next_state.log, action.payload)
    end
  end
  return next_state
end

---Dispatch a log action
---@param action LogAction
local function dispatch(action)
  print("aaa")
  log_state = reducer(log_state, action)
end

function logger.print(...)
  print("aaba")
  if arg == nil then
    return
  end
  local res = ""
  for i, v in pairs(arg) do
     print("aa444baaaaa", v)

    res = res..tostring(v)
  end
  print("aaaaabaaaaa")
  print(res)
  dispatch({ type = actions.Append, payload = res })
end

function logger.get()
  return log_state.log
end

return logger