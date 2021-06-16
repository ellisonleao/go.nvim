command! -nargs=1 -complete=file GoRun lua require("go.cmd").run(<f-args>)
command! -nargs=* GoBuild lua require("go.cmd").build(<f-args>)
command! -nargs=0 GoAlternate lua require("go.cmd").alternate()
command! -nargs=* GoTest lua require("go.cmd").test()
command! -nargs=* GoTestNearest lua require("go.cmd").test(true)
command! -nargs=0 GoBrowse lua require("go.cmd").browse()
command! -nargs=0 GoPlsInstall lua require("go.lsp").install_gopls()
command! -nargs=0 GoLspConfigure lua require("go.lsp").configure_lsp()
command! -nargs=0 GoLint lua require("go.cmd").lint()
