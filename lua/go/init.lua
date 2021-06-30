-- local cfg = require("go.cfg")
local lsp = require("go.lsp")

local M = {}

M.config = function(config)
  local cfg = config
  if cfg == nil then
    cfg = require("go.cfg")
  end
  lsp.configure_lsp(cfg)
end
return M
