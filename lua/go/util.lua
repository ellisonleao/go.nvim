-- util functions
local M = {}

M.print_msg = function(highlight, msg)
  local cmd = string.format([[echohl %s | echo "%s" | echohl None]], highlight, msg)
  vim.cmd(cmd)
end

M.file_exists = function(path)
  return vim.fn.filereadable(path) == 0 and vim.fn.bufexists(path) == 0
end

return M
