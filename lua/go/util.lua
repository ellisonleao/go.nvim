-- util functions
local Job = require("plenary.job")
local M = {}

M.print_msg = function(highlight, msg)
  local cmd = string.format([[echohl %s | echo "%s" | echohl None]], highlight, msg)
  vim.schedule(function()
    vim.cmd(cmd)
  end)
end

M.file_exists = function(path)
  return vim.fn.filereadable(path) == 0 and vim.fn.bufexists(path) == 0
end

M.open_browser = function(url)
  -- TODO: support windows
  Job:new{"xdg-open", url}:start()
end

return M
