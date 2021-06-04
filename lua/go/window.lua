-- window module
local window = require("plenary.window.float")
local M = {}

M.create_window = function(range_x, range_y)
  local win = window.percentage_range_window(tonumber(range_x), tonumber(range_y))
  vim.api.nvim_buf_set_keymap(win.bufnr, "n", "q",
                              ":lua require('go.cmd').close_win()<cr>",
                              {noremap = true, silent = true})
  vim.api.nvim_buf_set_keymap(win.bufnr, "n", "<Esc>",
                              ":lua require('go.cmd').close_win()<cr>",
                              {noremap = true, silent = true})

  return win
end

return M
