-- local cfg = require("go.cfg")
local lsp = require("go.lsp")
local treesitter = require("go.treesitter")

local M = {}

M.config = function(config)
  -- TODO: validate config
  local cfg = config
  if cfg == nil then
    cfg = require("go.cfg")
  end

  -- setup lsp
  lsp.setup(cfg)

  -- setup treesitter
  treesitter.setup()
end
return M
