-- local cfg = require("go.cfg")
local lsp = require("go.lsp")
local cfg = require("go.cfg")

local M = {}

M.config = function(config)
  if config ~= nil then
    cfg = config
  end
  lsp.configure_lsp(cfg)
end
return M
