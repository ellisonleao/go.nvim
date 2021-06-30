# go.nvim

Go development plugin for Neovim. Highly unstable.

# Motivation

This is a personal exercise on moving [vim-go](https://github.com/fatih/vim-go/) to Lua, using latest features from Neovim. The idea is to try to use Lua as much as possible, without relying
100% on Go 3rd party libs. Of course, some of them will still be needed, but
the focus is to push Lua the most we can.

# Installation

With [vim-plug](https://github.com/junegunn/vim-plug)

```
Plug 'nvim-lua/plenary.nvim'
Plug 'npxbr/go.nvim', {'for': 'go'}
```

With [packer.nvim](https://github.com/wbthomason/packer.nvim)

```
use {'npxbr/go.nvim', requires={'nvim-lua/plenary.nvim'}, ft = {'go'}}
```

# Documentation

TBD
