-- treesitter module configs for go.nvim
local ok = pcall(require, "nvim-treesitter")
if not ok then
  print("nvim-treesitter not installed")
  return
end

local M = {}

M.setup = function()
  require("nvim-treesitter.configs").setup({
    highlight = {enable = true},
    ensure_installed = {"go"},
    goobjects = {
      motion = {
        module_path = "go.motion",
        enable = true,
        is_supported = function()
          return true
        end,
        disable = {},
      },
    },
  })
end

return M
