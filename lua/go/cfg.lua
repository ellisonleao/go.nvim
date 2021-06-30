local l = require("go.lsp")

return {lsp = {on_attach = l.on_attach, capabilities = l.capabilities()}}
