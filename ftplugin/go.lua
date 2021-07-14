-- creating commands
vim.cmd([[command! -nargs=1 -complete=file GoRun lua require("go.cmd").run(<f-args>)]])
vim.cmd([[command! -nargs=* GoBuild lua require("go.cmd").build(<f-args>)]])
vim.cmd([[command! -nargs=0 GoAlternate lua require("go.cmd").alternate()]])
vim.cmd([[command! -nargs=* GoTest lua require("go.cmd").test()]])
vim.cmd([[command! -nargs=* GoTestFunc lua require("go.cmd").test(true)]])
vim.cmd([[command! -nargs=0 GoBrowse lua require("go.cmd").browse()]])
vim.cmd([[command! -nargs=0 GoPlsInstall lua require("go.lsp").install_gopls()]])
vim.cmd([[command! -nargs=0 GoLspConfigure lua require("go.lsp").configure_lsp()]])
vim.cmd([[command! -nargs=0 GoLint lua require("go.cmd").lint()]])
vim.cmd(
  [[command! -nargs=0 -range=% GoPlay lua require("go.cmd").play(<line1>, <line2>)]])
vim.cmd([[command! -nargs=0 GoReportGithubIssue lua require("go.cmd").open_issue()]])
vim.cmd([[command! -nargs=0 GoDocBrowser lua require("go.cmd").open_doc()]])
vim.cmd(
  [[command! -nargs=0 -bang GoCoverageToggle lua require("go.cmd").cover("<bang>")]])
