-- util functions
local Job = require("plenary.job")
local Path = require("plenary.path")
local M = {}

M.print_msg = function(highlight, msg)
  local cmd = string.format([[echohl %s | echo "%s" | echohl None]], highlight, msg)
  vim.schedule(function()
    vim.cmd(cmd)
  end)
end

M.file_exists = function(path)
  local f = Path:new(path)
  return f:exists()
end

M.open_browser = function(url)
  -- TODO: support windows
  Job:new{"xdg-open", url}:start()
end

local function get_cover_data(line)
  local groups = "([^:]+):(%d+).(%d+),(%d+).(%d+)%s(%d+)%s(%d+)"
  local _, _, file, line0, col0, line1, col1, _, ok = string.find(line, groups)
  local res = {
    file = file,
    line0 = tonumber(line0),
    col0 = tonumber(col0),
    line1 = tonumber(line1),
    col1 = tonumber(col1),
    ok = ok,
  }
  return res
end

M.parse_cover = function(file)
  -- grab cover file contents and parse it
  local lines = {}
  for line in io.lines(file) do
    if line ~= "mode: set" then
      table.insert(lines, get_cover_data(line))
    end
  end
  return lines
end

return M
