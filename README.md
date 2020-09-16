# trim.nvim

This plugin trims whitespace and trailing lines.

**TODO**

- [x] whitespace
- [ ] trailing lines

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
