# trim.nvim

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
