# trim.nvim

[![GitHub release](https://img.shields.io/github/release/cappyzawa/trim.nvim.svg)](https://github.com/cappyzawa/trim.nvim/releases)
[![GitHub](https://img.shields.io/github/license/cappyzawa/trim.nvim.svg)](./LICENSE)

This plugin trims trailing whitespace and lines.

## How to install

```vim
Plug 'cappyzawa/trim.nvim'
```

## How to setup

```vim
lua require('trim').setup()
" optional
autocmd BufWritePre * Trim
```
