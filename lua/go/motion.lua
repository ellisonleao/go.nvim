-- grabbed from https://github.com/nvim-treesitter/nvim-treesitter-textobjects/
local queries = require("nvim-treesitter.query")
local ts_utils = require("nvim-treesitter.ts_utils")
local api = vim.api

local M = {}

M.attach = function(bufnr)
  local opts = {silent = true, noremap = true}
  local mappings = {
    {
      "n",
      "[[",
      ":lua require('go.motion').goto_previous_start('@function.inner')<CR>",
      opts,
    },
    {
      "n",
      "]]",
      ":lua require('go.motion').goto_next_start('@function.inner')<CR>",
      opts,
    },
  }
  for _, map in pairs(mappings) do
    api.nvim_buf_set_keymap(bufnr, unpack(map))
  end
end

M.detach = function(bufnr)
  api.nvim_buf_del_keymap(bufnr, "n", "[[")
  api.nvim_buf_del_keymap(bufnr, "n", "]]")
end

local function move(query_string, forward, start)
  local buf = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  local function filter_function(match)
    local range = {match.node:range()}
    if not start then
      if range[4] == 0 then
        range[1] = range[3] - 1
        range[2] = range[4]
      else
        range[1] = range[3]
        range[2] = range[4] - 1
      end
    end
    if forward then
      return range[1] > row or (range[1] == row and range[2] > col)
    else
      return range[1] < row or (range[1] == row and range[2] < col)
    end
  end

  local function scoring_function(match)
    local score, _
    if start then
      _, _, score = match.node:start()
    else
      _, _, score = match.node:end_()
    end
    if forward then
      return -score
    else
      return score
    end
  end

  local match = queries.find_best_match(buf, query_string, "goobjects", filter_function,
                                        scoring_function)
  ts_utils.goto_node(match and match.node, not start, false)
end

M.goto_next_start = function(query_string)
  move(query_string, "forward", "start")
end

M.goto_previous_start = function(query_string)
  move(query_string, not "forward", "start")
end

return M
