# go.nvim

Go development plugin for Neovim. Highly unstable.

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

# Commands

## :GoRun

Runs current go file in a floating window

## :GoAlternate

Alternate between a go file and its test file

## :GoTest

Runs all tests for current file

## :GoTestNearest

Runs test under cursor

## :GoLint

Runs [golangci-lint](https://github.com/golangci/golangci-lint) for current folder.
