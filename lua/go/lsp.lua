-- lsp module
-- adding neovim lsp support if installed
local M = {}

M.on_attach = function(client, bufnr)
  local opts = {silent = true, noremap = true}
  local mappings = {
    {"n", "gd", [[<Cmd>lua vim.lsp.buf.definition()<CR>]], opts},
    {"n", "gD", [[<Cmd>lua vim.lsp.buf.declaration()<CR>]], opts},
    {"n", "gR", [[<Cmd>lua vim.lsp.buf.references()<CR>]], opts},
    {"n", "gr", [[<Cmd>lua vim.lsp.buf.rename()<CR>]], opts},
  }

  for _, map in pairs(mappings) do
    vim.api.nvim_buf_set_keymap(bufnr, unpack(map))
  end

  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
    augroup lsp_document_highlight
    autocmd! * <buffer>
    autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
    autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
    augroup END
    ]], false)
  end

end

M.configure_lsp = function(config)
  -- required: nvim-lspconfig && gopls
  local ok = pcall(vim.cmd, [[packadd nvim-lspconfig]])
  if not ok then
    vim.api.nvim_err_writeln("nvim-lspconfig is required")
    return
  end

  -- check if gopls is installed
  if not vim.fn.executable("gopls") then
    vim.api.nvim_err_writeln("gopls is required. Call :GoPlsInstall to install it")
    return
  end

  -- setting omnifunc
  local omnifunc = vim.o.omnifunc
  if omnifunc == "" then
    vim.o.omnifunc = "v:lua.lsp.omnifunc"
  end

  -- calling the lsp config for go
  local lspconfig = require("lspconfig")
  local cfg = {
    on_attach = config.lsp.on_attach,
    capabilities = config.lsp.capabilities(),
  }
  lspconfig["go"].setup(cfg)
end

M.capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport =
    {properties = {'documentation', 'detail', 'additionalTextEdits'}}

  return capabilities
end

M.install_gopls = function()
  if vim.fn.executable("gopls") then
    return
  end

  local answer = vim.fn.input("do you want to install gopls? Y/n = ")
  answer = string.lower(answer)
  while answer ~= "y" and answer ~= "n" do
    answer = vim.fn.input("please answer Y or n = ")
    answer = string.lower(answer)
  end

  if answer == "n" then
    return
  end

  local cmd = "GO111MODULE=on go get -v golang.org/x/tools/gopls"
  vim.cmd("new")
  local shell = vim.o.shell
  vim.o.shell = '/bin/bash'
  vim.fn.termopen("set -e\n" .. cmd)
  vim.o.shell = shell
  vim.cmd("startinsert")
end

return M
